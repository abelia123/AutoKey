@echo off
echo ===================================
echo AutoKey Build Script
echo ===================================
echo.

REM Check if PyInstaller is installed
python -m pip show pyinstaller >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo PyInstaller is not installed.
    echo Installing PyInstaller...
    python -m pip install pyinstaller
    echo.
)

REM Clean old build files
echo Cleaning old build files...
if exist "dist" rmdir /s /q "dist"
if exist "build" rmdir /s /q "build"
if exist "*.spec" del /q "*.spec"
echo.

REM Start build
echo Starting build...
echo.

REM Build with PyInstaller
REM --onefile: Create single exe file
REM --windowed: No console window
REM --name: Output filename
pyinstaller --onefile --windowed --name "DirectionUI_8way" "direction_ui_8way.py"

echo.
echo ===================================
if exist "dist\DirectionUI_8way.exe" (
    echo Build successful!
    echo Output: dist\DirectionUI_8way.exe
) else (
    echo Build failed!
    echo Please check the error messages above.
)
echo ===================================
echo.

pause