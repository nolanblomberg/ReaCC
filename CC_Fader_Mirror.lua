-- ReaCC bridge and VST parameter feedback.
-- Add CC Fader Bridge to Monitoring FX, then run this ReaScript.

local SECTION = "CCFaders"
local BRIDGE_NAME = "CC Fader Bridge"

-- Prevent duplicate loops if the script is started manually and at startup.
if reaper.GetExtState(SECTION, "mirrorRunning") == "1" then return end
reaper.SetExtState(SECTION, "mirrorRunning", "1", false)
reaper.atexit(function()
  reaper.SetExtState(SECTION, "mirrorRunning", "0", false)
end)

local UPDATE_HZ = 120
local nextUpdate = 0
local lastValue = {}
local lastTarget = {}
local lastTouchedKey = nil
local lastTouchedValue = nil
local heartbeatAt = 0
local heartbeatCounter = 0

-- The UI only exposes parameter learning after this script detects a touch.
reaper.SetExtState(SECTION, "learnAvailable", "0", false)

local function get_bridge(master)
  local count = reaper.TrackFX_GetRecCount(master)
  for i = 0, count - 1 do
    local fx = i + 0x1000000
    local _, name = reaper.TrackFX_GetFXName(master, fx)
    if name and name:find(BRIDGE_NAME, 1, true) then return fx end
  end
  return -1
end

-- Ensure the global Monitoring FX bridge exists. This is safe to repeat:
-- REAPER queries the existing instance and only creates it when absent.
do
  local master = reaper.GetMasterTrack(0)
  if master and get_bridge(master) < 0 then
    reaper.TrackFX_AddByName(master, "JS: CC Fader Bridge", true, 1)
  end
end

local function track_by_guid(guid)
  if not guid or guid == "" then return nil end
  local master = reaper.GetMasterTrack(0)
  if reaper.GetTrackGUID(master) == guid then return master end
  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    if reaper.GetTrackGUID(track) == guid then return track end
  end
  return nil
end

local function fx_by_guid(track, guid)
  if not track or not guid or guid == "" then return -1 end
  for i = 0, reaper.TrackFX_GetCount(track) - 1 do
    if reaper.TrackFX_GetFXGUID(track, i) == guid then return i end
  end
  for i = 0, reaper.TrackFX_GetRecCount(track) - 1 do
    local fx = i + 0x1000000
    if reaper.TrackFX_GetFXGUID(track, fx) == guid then return fx end
  end
  return -1
end

local function touched_parameter()
  local ok, encodedTrack, fx, param = reaper.GetLastTouchedFX()
  if not ok or math.floor(encodedTrack / 0x1000000) ~= 0 then return nil end
  local trackNumber = encodedTrack % 0x1000000
  local track = trackNumber == 0 and reaper.GetMasterTrack(0)
    or reaper.GetTrack(0, trackNumber - 1)
  if not track or param < 0 or param >= reaper.TrackFX_GetNumParams(track, fx) then
    return nil
  end
  local trackGuid = reaper.GetTrackGUID(track)
  local fxGuid = reaper.TrackFX_GetFXGUID(track, fx)
  local _, fxName = reaper.TrackFX_GetFXName(track, fx)
  return {
    param = param,
    trackGuid = trackGuid,
    fxGuid = fxGuid,
    fxName = fxName or "",
    value = reaper.TrackFX_GetParamNormalized(track, fx, param)
  }
end

local function touch_key(candidate)
  return candidate.trackGuid .. "/" .. candidate.fxGuid .. "/" .. candidate.param
end

-- Baseline the last touched parameter on startup, so an old selection alone
-- does not make the learn controls appear.
do
  local candidate = touched_parameter()
  if candidate and not candidate.fxName:find(BRIDGE_NAME, 1, true) then
    lastTouchedKey = touch_key(candidate)
    lastTouchedValue = candidate.value
  end
end

local function learn_parameter(slot, candidate)
  reaper.SetExtState(SECTION, "mapTrack" .. slot, candidate.trackGuid, true)
  reaper.SetExtState(SECTION, "mapFX" .. slot, candidate.fxGuid, true)
  reaper.SetExtState(SECTION, "mapParam" .. slot, tostring(candidate.param), true)
  reaper.SetExtState(SECTION, "learn" .. slot, "2", false)
  return true
end

local function main()
  local now = reaper.time_precise()
  if now >= nextUpdate then
    nextUpdate = now + 1 / UPDATE_HZ
    local master = reaper.GetMasterTrack(0)
    local bridge = master and get_bridge(master) or -1

    if master and bridge >= 0 then
      if now - heartbeatAt >= 0.25 then
        heartbeatAt = now
        heartbeatCounter = heartbeatCounter + 1
        reaper.SetExtState(SECTION, "bridgeHeartbeat", tostring(heartbeatCounter), false)
      end

      local candidate = touched_parameter()
      if candidate and not candidate.fxName:find(BRIDGE_NAME, 1, true) then
        local key = touch_key(candidate)
        if key ~= lastTouchedKey
          or (lastTouchedKey == key and lastTouchedValue ~= nil
            and math.abs(candidate.value - lastTouchedValue) > 0.0000001) then
          reaper.SetExtState(SECTION, "learnAvailable", "1", false)
        end
        lastTouchedKey = key
        lastTouchedValue = candidate.value
      end
    end

    if master and bridge >= 0 then
      for slot = 1, 4 do
        if reaper.GetExtState(SECTION, "unlink" .. slot) == "1" then
          reaper.SetExtState(SECTION, "mapTrack" .. slot, "", true)
          reaper.SetExtState(SECTION, "mapFX" .. slot, "", true)
          reaper.SetExtState(SECTION, "mapParam" .. slot, "", true)
          reaper.SetExtState(SECTION, "target" .. slot, "", false)
          reaper.SetExtState(SECTION, "learn" .. slot, "0", false)
          reaper.SetExtState(SECTION, "unlink" .. slot, "0", false)
          lastValue[slot] = nil
          lastTarget[slot] = nil
        end

        if reaper.GetExtState(SECTION, "learn" .. slot) == "1" then
          local candidate = touched_parameter()
          if candidate then
            learn_parameter(slot, candidate)
          else
            reaper.SetExtState(SECTION, "learn" .. slot, "3", false)
          end
        end

        local trackGuid = reaper.GetExtState(SECTION, "mapTrack" .. slot)
        local fxGuid = reaper.GetExtState(SECTION, "mapFX" .. slot)
        local param = tonumber(reaper.GetExtState(SECTION, "mapParam" .. slot))
        local targetTrack = track_by_guid(trackGuid)
        local targetFX = fx_by_guid(targetTrack, fxGuid)

        if targetTrack and targetFX >= 0 and param
          and param >= 0 and param < reaper.TrackFX_GetNumParams(targetTrack, targetFX) then
          -- Learned faders write high-resolution normalized values directly
          -- to the VST; manual VST or automation changes flow back to the page.
          local targetKey = "target" .. slot
          local requested = tonumber(reaper.GetExtState(SECTION, targetKey))
          local normalized = reaper.TrackFX_GetParamNormalized(targetTrack, targetFX, param)
          if lastTarget[slot] ~= nil and requested ~= nil
            and math.abs(requested - lastTarget[slot]) > 0.0000001 then
            normalized = math.max(0, math.min(1, requested))
            reaper.TrackFX_SetParamNormalized(targetTrack, targetFX, param, normalized)
            normalized = reaper.TrackFX_GetParamNormalized(targetTrack, targetFX, param)
          end
          if requested == nil or math.abs(requested - normalized) > 0.0000001 then
            reaper.SetExtState(SECTION, targetKey, string.format("%.8f", normalized), false)
          end
          lastTarget[slot] = normalized
          local value = math.max(0, math.min(127, math.floor(normalized * 127 + 0.5)))
          local bridgeValue = math.floor(reaper.TrackFX_GetParam(master, bridge, slot - 1) + 0.5)
          if bridgeValue ~= value then
            reaper.TrackFX_SetParam(master, bridge, slot - 1, value)
          end
          if tonumber(reaper.GetExtState(SECTION, "val" .. slot)) ~= value then
            reaper.SetExtState(SECTION, "val" .. slot, tostring(value), false)
          end
          lastValue[slot] = value
        else
          -- Without a learned VST parameter, synchronize the web fader and bridge.
          local key = "val" .. slot
          local ext = reaper.GetExtState(SECTION, key)
          local requested = tonumber(ext)
          local bridgeValue = math.floor(reaper.TrackFX_GetParam(master, bridge, slot - 1) + 0.5)
          if lastValue[slot] == nil and requested ~= nil then
            bridgeValue = math.max(0, math.min(127, math.floor(requested + 0.5)))
            reaper.TrackFX_SetParam(master, bridge, slot - 1, bridgeValue)
          elseif lastValue[slot] ~= nil and requested ~= nil and requested ~= lastValue[slot] then
            bridgeValue = math.max(0, math.min(127, math.floor(requested + 0.5)))
            reaper.TrackFX_SetParam(master, bridge, slot - 1, bridgeValue)
          else
            if requested ~= bridgeValue then
              reaper.SetExtState(SECTION, key, tostring(bridgeValue), false)
            end
          end
          lastValue[slot] = bridgeValue
        end
      end
    end
  end
  reaper.defer(main)
end

reaper.defer(main)
