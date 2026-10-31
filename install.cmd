@echo off
setlocal

set "INSTALLER=%~dp0scripts\install-profile-files.ps1"

if not exist "%INSTALLER%" (
    echo Installer not found: "%INSTALLER%"
    echo Run install.cmd from the cloned repository folder, not from a ZIP preview or a copy.
    goto :done_fail
)

echo Installing Copilot files to "%USERPROFILE%"...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%INSTALLER%"
set "INSTALL_EXIT_CODE=%ERRORLEVEL%"

echo.
if "%INSTALL_EXIT_CODE%"=="0" (
    echo Installation completed successfully.
) else (
    echo Installation failed with exit code %INSTALL_EXIT_CODE%.
)
pause
exit /b %INSTALL_EXIT_CODE%

:done_fail
echo.
pause
exit /b 1
