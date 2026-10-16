ReaCC
=====

Install once. Works in every project.


INSTALL (once)
--------------

1. Run the installer for your operating system once. On Windows, press a key
   when the installer finishes to close its window. It saves a confirmation
   report, ReaCC_Install_Report.txt, in REAPER's Scripts folder.
2. If REAPER was open during installation, restart it once. The installer
   registers the mirror script to start automatically and installs the bridge;
   the script adds “CC Fader Bridge” to Monitoring FX on REAPER startup.
3. The installer does not configure REAPER's web server. In REAPER, open
   Options → Preferences → Control/OSC/web, click Add, and
   choose “Web browser interface.” Open “User pages…” and select ReaCC.html.
4. Use the displayed “Access URL” in a browser on your phone or tablet. Keep
   the device and computer on the same network. You can save the page to your
   device's home screen for easier access.


BASIC USE
---------

Move the faders to send MIDI CC.
Change the green numbers for different CC numbers.
Values are remembered automatically.


OPTIONAL – DAW parameter mirroring
----------------------------------

The installer sets up the bridge and mirror script automatically; no second
installer run or manual Monitoring FX insertion is needed. To mirror a
plug-in control, move it once in its plug-in window to unlock the buttons, then
tap “Mirror DAW” on the fader you want to link. Its broken-link icon becomes a
connected chain and the label becomes “Mirroring.” Tap again to cancel learning
or remove the link.

The installer preserves any existing Scripts/__startup.lua file and adds one
ReaCC startup block only once. To disable auto-start, remove the lines between
“ReaCC startup begin” and “ReaCC startup end” in that file.

The linked fader follows manual or automated changes to the parameter, and the
phone fader controls it through REAPER. MIDI learn is not required. When a
fader is not linked, it continues sending its selected standard 7-bit MIDI CC;
the CC number remains saved and editable.
