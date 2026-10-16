#!/bin/bash
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
DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$WWW" "$EFFECTS" "$SCRIPTS"

cp -f "$DIR/ReaCC.html"            "$WWW/ReaCC.html"
cp -f "$DIR/CC_Fader_Bridge.jsfx"  "$EFFECTS/CC_Fader_Bridge.jsfx"
cp -f "$DIR/CC_Fader_Mirror.lua"   "$SCRIPTS/CC_Fader_Mirror.lua"

echo "Files installed."
echo ""
echo "Next:"
echo "  1. REAPER Preferences → Control/OSC/web → Add"
echo "     → Web browser interface"
echo "     → User pages..."
echo "     → ReaCC.html"
echo "  2. On your control device's browser, open the "Access URL" as shown (e.g. http://192.168.0.80:8080)l"
echo ""
echo "Optional Live setup (sliders auto-follow changes on DAW) is in README.txt"
echo ""
echo "Press Enter to close..."
read
