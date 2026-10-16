@echo off
rem A launcher (including some archive and installer tools) may close the
rem console after the batch file exits. Re-run in a dedicated persistent
rem Command Prompt so the result remains visible for review.
if /i not "%~1"=="--keep-open" (
  start "ReaCC Installer" "%ComSpec%" /c ""%~f0" --keep-open"
  exit /b
)

title ReaCC Installer
echo.
echo  ========================
echo   ReaCC - Installer
echo  ========================
echo.

set "WWW=%APPDATA%\REAPER\reaper_www_root"
set "EFFECTS=%APPDATA%\REAPER\Effects"
set "SCRIPTS=%APPDATA%\REAPER\Scripts"
set "STARTUP=%SCRIPTS%\__startup.lua"
set "REPORT=%SCRIPTS%\ReaCC_Install_Report.txt"

rem Keep a status file even when the installer fails partway through.
if not exist "%SCRIPTS%" mkdir "%SCRIPTS%"
>"%REPORT%" echo ReaCC installation: IN PROGRESS

if not exist "%WWW%" mkdir "%WWW%"
if not exist "%EFFECTS%" mkdir "%EFFECTS%"
if not exist "%SCRIPTS%" mkdir "%SCRIPTS%"

copy /Y "%~dp0ReaCC.html"           "%WWW%\ReaCC.html" >nul || goto :install_failed
copy /Y "%~dp0CC_Fader_Bridge.jsfx"  "%EFFECTS%\CC_Fader_Bridge.jsfx" >nul || goto :install_failed
copy /Y "%~dp0CC_Fader_Mirror.lua"   "%SCRIPTS%\CC_Fader_Mirror.lua" >nul || goto :install_failed

findstr /C:"ReaCC startup begin" "%STARTUP%" >nul 2>&1
if errorlevel 1 (
  >>"%STARTUP%" echo.
  >>"%STARTUP%" echo -- ReaCC startup begin
  >>"%STARTUP%" echo dofile^(reaper.GetResourcePath^(^) .. "/Scripts/CC_Fader_Mirror.lua"^)
  >>"%STARTUP%" echo -- ReaCC startup end
  rem Echo may leave findstr's earlier error level unchanged; verify the file itself.
  findstr /C:"ReaCC startup begin" "%STARTUP%" >nul 2>&1
  if errorlevel 1 goto :startup_failed
  set "STARTUP_RESULT=Added"
) else (
  set "STARTUP_RESULT=Already present"
)

(
  echo ReaCC installation: SUCCESS
  echo Startup hook: %STARTUP_RESULT%
  echo Monitoring FX bridge: will be added automatically at next REAPER startup
  echo Web interface: select ReaCC.html once in REAPER Control/OSC/web preferences
  echo Startup file: %STARTUP%
  echo Web page: %WWW%\ReaCC.html
  echo Bridge: %EFFECTS%\CC_Fader_Bridge.jsfx
  echo Mirror script: %SCRIPTS%\CC_Fader_Mirror.lua
) > "%REPORT%" || goto :report_failed

echo Installation complete: all three ReaCC files were copied.
echo Auto-start hook: %STARTUP_RESULT% in "%STARTUP%"
echo Written confirmation: "%REPORT%"
echo.
echo Next:
echo  1. In REAPER: Options -^> Preferences -^> Control/OSC/web -^> Add
echo     -^> Web browser interface
echo     -^> User pages...
echo     -^> ReaCC.html
echo  2. On your control device's browser, open the "Access URL" as shown (e.g. http://192.168.0.80:8080)
echo.
echo The installer does not configure REAPER's web interface; complete the steps above once.
echo The bridge and mirror script are installed automatically; no second install is needed.
echo Restart REAPER if it was open during installation. The bridge is added to Monitoring FX on startup.
echo Move a plugin control to unlock Mirror DAW, then tap it to link a fader.
echo.
pause
exit /b 0

:install_failed
>"%REPORT%" echo ReaCC installation: FAILED - a ReaCC file could not be copied.
echo ERROR: A ReaCC file could not be copied. Check the REAPER folders and try again.
echo Details: "%REPORT%"
pause
exit /b 1

:startup_failed
>"%REPORT%" echo ReaCC installation: FAILED - startup hook could not be written.
echo ERROR: The startup hook could not be written to "%STARTUP%".
echo Details: "%REPORT%"
pause
exit /b 1

:report_failed
echo ERROR: The install report could not be written to "%REPORT%".
pause
exit /b 1
