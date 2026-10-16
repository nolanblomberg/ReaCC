#!/bin/bash
echo ""
echo "  ========================"
echo "   ReaCC - Installer"
echo "  ========================"
echo ""

WWW="$HOME/Library/Application Support/REAPER/reaper_www_root"
EFFECTS="$HOME/Library/Application Support/REAPER/Effects"
SCRIPTS="$HOME/Library/Application Support/REAPER/Scripts"
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
echo "  2. On your control device's browser, open the "Access URL" as shown (e.g. http://192.168.0.80:8080)"
echo ""
echo "Optional Live setup (sliders auto-follow changes on DAW) is in README.txt"
echo ""
echo "Press Enter to close..."
read
