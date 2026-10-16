#!/bin/bash
set -e
echo ""
echo "  ========================"
echo "   ReaCC - Installer"
echo "  ========================"
echo ""

if [ -d "$HOME/.config/REAPER" ]; then
  BASE="$HOME/.config/REAPER"
elif [ -d "$HOME/REAPER" ]; then
  BASE="$HOME/REAPER"
else
  BASE="$HOME/.config/REAPER"
fi

WWW="$BASE/reaper_www_root"
EFFECTS="$BASE/Effects"
SCRIPTS="$BASE/Scripts"
STARTUP="$SCRIPTS/__startup.lua"
REPORT="$SCRIPTS/ReaCC_Install_Report.txt"
DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$WWW" "$EFFECTS" "$SCRIPTS"

cp -f "$DIR/ReaCC.html"            "$WWW/ReaCC.html"
cp -f "$DIR/CC_Fader_Bridge.jsfx"  "$EFFECTS/CC_Fader_Bridge.jsfx"
cp -f "$DIR/CC_Fader_Mirror.lua"   "$SCRIPTS/CC_Fader_Mirror.lua"

if ! grep -Fq "ReaCC startup begin" "$STARTUP" 2>/dev/null; then
  cat >> "$STARTUP" <<'LUA'

-- ReaCC startup begin
dofile(reaper.GetResourcePath() .. "/Scripts/CC_Fader_Mirror.lua")
-- ReaCC startup end
LUA
  STARTUP_RESULT="Added"
else
  STARTUP_RESULT="Already present"
fi

cat > "$REPORT" <<EOF
ReaCC installation: SUCCESS
Startup hook: $STARTUP_RESULT
Monitoring FX bridge: will be added automatically at next REAPER startup
Web interface: select ReaCC.html once in REAPER Control/OSC/web preferences
Startup file: $STARTUP
Web page: $WWW/ReaCC.html
Bridge: $EFFECTS/CC_Fader_Bridge.jsfx
Mirror script: $SCRIPTS/CC_Fader_Mirror.lua
EOF

echo "Installation complete: all three ReaCC files were copied."
echo "Auto-start hook: $STARTUP_RESULT in $STARTUP"
echo "Written confirmation: $REPORT"
echo ""
echo "Next:"
echo "  1. In REAPER: Options → Preferences → Control/OSC/web → Add"
echo "     → Web browser interface"
echo "     → User pages..."
echo "     → ReaCC.html"
echo "  2. On your control device's browser, open the Access URL shown (e.g. http://192.168.0.80:8080)"
echo ""
echo "The installer does not configure REAPER's web interface; complete the steps above once."
echo "The bridge and mirror script are installed automatically; no second install is needed."
echo "Restart REAPER if it was open during installation. The bridge is added to Monitoring FX on startup."
echo "Move a plugin control to unlock Mirror DAW, then tap it to link a fader."
echo ""
echo "Press Enter to close..."
read
