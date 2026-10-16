# ReaCC

A four-fader MIDI CC controller for REAPER. Use ReaCC in a browser on your phone or tablet as a touch-friendly control surface.

ReaCC can also mirror REAPER plug-in parameters: the fader follows changes in REAPER, and moving the fader controls the linked parameter.

## Features

- Four touch-friendly MIDI CC faders
- Editable CC numbers from 0–127
- Values remembered automatically
- Optional **Mirror DAW** linking for plug-in parameters and their automation
- Runs in a browser; no companion app is required

## Install

1. Download the ReaCC files and run the installer for your operating system:
   - Windows: `INSTALL_Windows.bat`
   - macOS: `INSTALL_macOS.command`
   - Linux: `INSTALL_Linux.sh`
2. If REAPER was open during installation, restart it once. The installer registers the mirror script to start with REAPER. At startup, the script adds **CC Fader Bridge** to Monitoring FX if it is not already there.
3. In REAPER, open **Options → Preferences → Control/OSC/web**, click **Add**, and select **Web browser interface**.
4. In the web interface settings, open **User pages…** and select `ReaCC.html`.
5. Open the displayed **Access URL** in a browser on your phone or tablet. Keep the device and REAPER computer on the same network.

The installer writes `ReaCC_Install_Report.txt` to REAPER’s `Scripts` folder. The web browser interface setup is a one-time step in REAPER; the installer does not configure it for you.

## Basic use

Move a fader to send MIDI CC. Change the green number above a fader to assign a different CC number.

When a fader is not linked with **Mirror DAW**, it sends standard 7-bit MIDI CC values.

## Optional: Mirror DAW

The installer sets up the bridge and mirror script automatically. You do not need to run the installer a second time or add the bridge manually.

1. Open the plug-in whose parameter you want to control.
2. Move that parameter once. ReaCC will unlock the **Mirror DAW** buttons when it detects the change.
3. Tap **Mirror DAW** on the fader you want to link.

The icon changes from a broken link to a connected chain, and the label changes to **Mirroring**. The fader then follows manual or automated changes to that parameter, and moving the fader controls it through REAPER. An envelope can drive the linked fader when it automates the linked plug-in parameter.

Tap **Mirroring** again to cancel a pending link or remove an existing link. Unlinked faders continue to work as MIDI CC controls.

## Troubleshooting

- **The page says it is not connected:** Open ReaCC through REAPER’s **Access URL**, not as a local HTML file. Check that the Web browser interface is enabled and that `ReaCC.html` is selected under **User pages…**.
- **Mirror DAW stays locked:** Restart REAPER if installation happened while it was open. Then move a plug-in parameter again. The bridge must be in Monitoring FX and `CC_Fader_Mirror.lua` must be running.
- **Regular MIDI CC control still works:** Plug-in mirroring is optional; a locked Mirror DAW button does not disable the regular faders.

## License

ReaCC is released under the GNU General Public License, version 3. See [LICENSE](LICENSE).
