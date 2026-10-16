# ReaCC

ReaCC
=====
Graphical CC Faderbox for Reaper DAW. Open a browser on any local device and use it as a long-throw faderbox to control Midi CC parameters, just like those expensive physical boxes. Optional Function to "motorize" your faders to auto-follow the parameters if they change on the VST or envelope.
Install once. Works in every project.


INSTALL (once)
--------------

1. Run the installer for your OS
2. In REAPER:
   Preferences → Control/OSC/web → Add
   → choose “Web browser interface”
3. Click the "User Pages" button, and in the window that opens, select "ReaCC.html"
4. In that window, copy the "Access URL" (e.g. http://192.168.0.80:8080). This is what you paste into your browser on your controlling device (phone, iPad, etc.).
Optional: For ease of access, when you open the Access URL, you can save the webpage to your home screen, aka install the page as an app.


BASIC USE
---------

Move the faders to send MIDI CC.
Change the green numbers for different CC numbers.
Values are remembered automatically.


OPTIONAL – Live following (VST parameters)
------------------------------------------

1. View → Monitoring FX
2. Add: JS: CC Fader Bridge
3. Actions → Show action list
   → New action → Load ReaScript → CC_Fader_Mirror.lua
   → click Run
4. Touch or adjust the VST parameter you want the fader to follow, then click
   that fader's “Learn VST” button in ReaCC. The button changes to “Learned”
   when linked. Tap it again to cancel learning or remove the learned link.

The web fader follows manual or automated changes to the learned parameter,
and writes high-resolution normalized values directly through REAPER. VST MIDI
learn is not required for a learned fader. Its CC number is used when the fader
is not linked; the CC entry remains saved and editable. Unlinked faders use
standard 7-bit MIDI CC resolution.
