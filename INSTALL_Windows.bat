@echo off
title ReaCC Installer
echo.
echo  ========================
echo   ReaCC - Installer
echo  ========================
echo.

set "WWW=%APPDATA%\REAPER\reaper_www_root"
set "EFFECTS=%APPDATA%\REAPER\Effects"
set "SCRIPTS=%APPDATA%\REAPER\Scripts"

if not exist "%WWW%" mkdir "%WWW%"
if not exist "%EFFECTS%" mkdir "%EFFECTS%"
if not exist "%SCRIPTS%" mkdir "%SCRIPTS%"

copy /Y "%~dp0ReaCC.html"           "%WWW%\ReaCC.html" >nul
copy /Y "%~dp0CC_Fader_Bridge.jsfx"  "%EFFECTS%\CC_Fader_Bridge.jsfx" >nul
copy /Y "%~dp0CC_Fader_Mirror.lua"   "%SCRIPTS%\CC_Fader_Mirror.lua" >nul

echo Files installed.
echo.
echo Next:
echo  1. REAPER Preferences -^> Control/OSC/web -^> Add
echo     -^> Web browser interface
echo     -^> User pages...
echo     -^> ReaCC.html
echo  2. On your control device's browser, open the "Access URL" as shown (e.g. http://192.168.0.80:8080)
echo.
echo Optional Live setup (sliders auto-follow changes on DAW) is in README.txt
echo.
pause
