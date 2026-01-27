@echo off
setlocal enabledelayedexpansion

:: Keymapper Setup Script for Windows (Batch)

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click Command Prompt and select "Run as Administrator"
    pause
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"
set "KEYMAPPER_VERSION=5.3.1"
set "KEYMAPPER_EXE=C:\Program Files\keymapper\keymapper.exe"
set "KEYMAPPER_ZIP_URL=https://github.com/houmain/keymapper/releases/download/%KEYMAPPER_VERSION%/keymapper-%KEYMAPPER_VERSION%-Windows-x86_64.zip"

:: Configuration arrays
set "CONFIG[0]=Multi-tap (bottom row single-handed)"
set "CONF_FILE[0]=multitap.conf"
set "CONFIG[1]=Right-hand mirrored"
set "CONF_FILE[1]=right_hand_mirrored_keymapper.conf"
set "CONFIG[2]=Left-hand mirrored"
set "CONF_FILE[2]=left_hand_mirrored_keymapper.conf"
set "CONFIG[3]=Full mirrored (both hands)"
set "CONF_FILE[3]=full_mirrored_keymapper.conf"

set "SELECTED=0"

:: Check if keymapper is installed
if exist "%KEYMAPPER_EXE%" (
    echo Keymapper is already installed
) else (
    call :InstallKeymapper
    if errorlevel 1 exit /b 1
)

echo.
call :SetupAutostart
echo.

:MenuLoop
call :ShowMenu
call :GetMenuInput
if "!MENU_ACTION!"=="select" (
    call :SelectConfig
    if errorlevel 1 goto MenuLoop
    exit /b 0
) else if "!MENU_ACTION!"=="cancel" (
    cls
    echo Setup cancelled.
    exit /b 0
)
goto MenuLoop

:ShowMenu
cls
echo ┌─────────────────────────────────────────────────────┐
echo │ Keymapper Configuration - Select Configuration      │
echo ├─────────────────────────────────────────────────────┤
echo │ Choose a keyboard configuration:                    │
echo │                                                     │
for /l %%i in (0,1,3) do (
    if %%i equ !SELECTED! (
        echo │ ► %%i !CONFIG[%%i]!
    ) else (
        echo │   %%i !CONFIG[%%i]!
    )
)
echo │                                                     │
echo │ (1-4 to select, Enter to confirm, Esc to cancel)   │
echo └─────────────────────────────────────────────────────┘
exit /b 0

:GetMenuInput
set "MENU_ACTION=continue"

for /f "tokens=*" %%a in ('choice /C:1234E /N /M ""') do (
    set "CHOICE=%%a"
)

if "!CHOICE!"=="1" set "SELECTED=0" & exit /b 0
if "!CHOICE!"=="2" set "SELECTED=1" & exit /b 0
if "!CHOICE!"=="3" set "SELECTED=2" & exit /b 0
if "!CHOICE!"=="4" set "SELECTED=3" & exit /b 0
if "!CHOICE!"=="E" set "MENU_ACTION=cancel" & exit /b 0

set "MENU_ACTION=continue"
exit /b 0

:SelectConfig
set "CONFIG_NAME=!CONFIG[%SELECTED%]!"
set "CONFIG_FILE=!CONF_FILE[%SELECTED%]!"
set "CONFIG_PATH=%SCRIPT_DIR%%CONFIG_FILE%"

if not exist "%CONFIG_PATH%" (
    cls
    echo Error: Configuration file not found: %CONFIG_PATH%
    pause
    exit /b 1
)

:: Kill existing keymapper
taskkill /IM keymapper.exe /F >nul 2>&1
timeout /t 1 /nobreak >nul

:: Update autostart shortcut
call :UpdateAutostart "%CONFIG_PATH%"

:: Start keymapper
start "" "%KEYMAPPER_EXE%" -c "%CONFIG_PATH%" -u

cls
echo Setup complete
echo Configuration: %CONFIG_NAME%
echo Config file: %CONFIG_FILE%
echo Autostart configured
echo Keymapper started

exit /b 0

:InstallKeymapper
echo.
echo Installing Keymapper %KEYMAPPER_VERSION%...
echo   Downloading from %KEYMAPPER_ZIP_URL%...

set "TEMP_ZIP=%TEMP%\keymapper-%KEYMAPPER_VERSION%-Windows-x86_64.zip"
set "TEMP_DIR=%TEMP%\keymapper-extract"

:: Download using PowerShell
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%KEYMAPPER_ZIP_URL%', '%TEMP_ZIP%')"

if errorlevel 1 (
    echo   Error: Failed to download keymapper
    exit /b 1
)

echo   Extracting...
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
powershell -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%TEMP_DIR%'"

echo   Installing to Program Files...
set "INSTALL_DIR=C:\Program Files\keymapper"
if exist "%INSTALL_DIR%" rmdir /s /q "%INSTALL_DIR%"
mkdir "%INSTALL_DIR%"
xcopy "%TEMP_DIR%\*" "%INSTALL_DIR%" /E /Y >nul

:: Cleanup
del /q "%TEMP_ZIP%"
rmdir /s /q "%TEMP_DIR%"

echo   Keymapper installed successfully
exit /b 0

:SetupAutostart
echo Setting up autostart...

set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT_PATH=%STARTUP_FOLDER%\keymapper.lnk"

:: Create shortcut using PowerShell
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); $Shortcut.TargetPath = '%KEYMAPPER_EXE%'; $Shortcut.WorkingDirectory = '%SCRIPT_DIR%'; $Shortcut.Save()"

echo   Autostart configured
exit /b 0

:UpdateAutostart
set "CONFIG_PATH=%~1"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT_PATH=%STARTUP_FOLDER%\keymapper.lnk"

:: Update shortcut with arguments
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); $Shortcut.Arguments = '-c \"%CONFIG_PATH%\" -u'; $Shortcut.Save()"

exit /b 0
