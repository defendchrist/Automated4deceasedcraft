@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ============================================
type art.txt

echo  ASM 9.7.1 Fix for Prism Launcher
echo  DeceasedCraft / Forge modpack installer
echo ============================================
echo.

:: Detect Prism Launcher data folder
set "PRISM_DATA=%APPDATA%\PrismLauncher"
if not exist "%PRISM_DATA%" (
    set "PRISM_DATA=%LOCALAPPDATA%\PrismLauncher"
)
if not exist "%PRISM_DATA%" (
    echo [ERROR] Could not find PrismLauncher data folder.
    echo Looked in:
    echo   %APPDATA%\PrismLauncher
    echo   %LOCALAPPDATA%\PrismLauncher
    echo.
    echo Please enter your Prism Launcher data path manually:
    set /p PRISM_DATA="Path: "
)

echo [INFO] Using Prism data folder: %PRISM_DATA%
echo.

:: Base library path
set "LIB_BASE=%PRISM_DATA%\libraries\org\ow2\asm"

:: Maven Central base URL
set "MAVEN=https://repo1.maven.org/maven2/org/ow2/asm"

:: List of ASM modules to download
set MODULES=asm asm-tree asm-commons asm-util asm-analysis
set VERSION=9.7.1

echo [INFO] Creating library directories...
for %%M in (%MODULES%) do (
    if not exist "%LIB_BASE%\%%M\%VERSION%" (
        mkdir "%LIB_BASE%\%%M\%VERSION%"
        echo   Created: %LIB_BASE%\%%M\%VERSION%
    ) else (
        echo   Already exists: %LIB_BASE%\%%M\%VERSION%
    )
)
echo.

echo [INFO] Downloading ASM %VERSION% jars from Maven Central...
echo.

for %%M in (%MODULES%) do (
    set "DEST=%LIB_BASE%\%%M\%VERSION%\%%M-%VERSION%.jar"
    set "URL=%MAVEN%/%%M/%VERSION%/%%M-%VERSION%.jar"

    if exist "!DEST!" (
        echo   [SKIP] %%M-%VERSION%.jar already present
    ) else (
        echo   [DOWNLOAD] %%M-%VERSION%.jar
        powershell -Command "Invoke-WebRequest -Uri '!URL!' -OutFile '!DEST!' -UseBasicParsing" >nul 2>&1
        if exist "!DEST!" (
            echo   [OK] %%M-%VERSION%.jar downloaded successfully
        ) else (
            echo   [FAIL] Failed to download %%M-%VERSION%.jar
            echo          Try manually: !URL!
        )
    )
)

echo.
echo ============================================
echo  Done! Now retry the modpack install
echo  in Prism Launcher.
echo ============================================
echo.
pause
