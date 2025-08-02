@echo off
echo ===================================
echo AutoKey Release Script
echo ===================================
echo.

REM Check if exe exists
if not exist "dist\DirectionUI_8way.exe" (
    echo Error: DirectionUI_8way.exe not found!
    echo Please run build.bat first.
    pause
    exit /b 1
)

REM Get version number from user
set /p VERSION="Enter release version (e.g., v1.0.0): "

echo.
echo Creating release %VERSION%...
echo.

REM Create release directory
if not exist "releases" mkdir "releases"

REM Copy exe to release directory with version
copy "dist\DirectionUI_8way.exe" "releases\DirectionUI_8way_%VERSION%.exe"

echo.
echo ===================================
echo Release created successfully!
echo.
echo File: releases\DirectionUI_8way_%VERSION%.exe
echo.
echo Next steps:
echo 1. Commit and push your changes to GitHub
echo 2. Create a new release on GitHub with tag %VERSION%
echo 3. Upload releases\DirectionUI_8way_%VERSION%.exe to the release
echo ===================================
echo.

pause