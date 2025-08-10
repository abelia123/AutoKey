#!/bin/bash

# Mac用ビルドスクリプト
echo "Building DirectionUI 8way for macOS..."

# 仮想環境の作成（必要に応じて）
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# 仮想環境のアクティベート
source venv/bin/activate

# 必要なパッケージのインストール
echo "Installing dependencies..."
pip install PyQt6 pynput pyautogui pyinstaller

# macOSのアクセシビリティ権限の確認
echo ""
echo "⚠️  重要: macOSのセキュリティ設定"
echo "このアプリケーションを正しく動作させるには、以下の権限が必要です："
echo "1. システム環境設定 > セキュリティとプライバシー > プライバシー"
echo "2. 'アクセシビリティ'タブで、このアプリケーションまたはTerminalを許可"
echo "3. '画面収録'タブでも同様に許可（スクリーンショット機能のため）"
echo ""

# PyInstallerでビルド
echo "Building with PyInstaller..."
pyinstaller --name="DirectionUI_8way_Mac" \
            --onefile \
            --windowed \
            --icon=icon.icns \
            --add-data="icon.icns:." \
            --hidden-import=PyQt6 \
            --hidden-import=pynput \
            --hidden-import=pyautogui \
            --osx-bundle-identifier="com.autokey.directionui" \
            direction_ui_8way_mac.py

# ビルド結果の確認
if [ -f "dist/DirectionUI_8way_Mac.app" ]; then
    echo "✅ Build successful!"
    echo "Application created at: dist/DirectionUI_8way_Mac.app"
    
    # アプリケーションバンドルの権限設定
    echo "Setting permissions..."
    chmod +x "dist/DirectionUI_8way_Mac.app/Contents/MacOS/DirectionUI_8way_Mac"
    
    # Info.plistに必要な権限を追加
    echo "Adding privacy permissions to Info.plist..."
    /usr/libexec/PlistBuddy -c "Add :NSAppleEventsUsageDescription string 'This app needs to control other applications to perform keyboard shortcuts.'" "dist/DirectionUI_8way_Mac.app/Contents/Info.plist" 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Add :NSAccessibilityUsageDescription string 'This app needs accessibility access to detect mouse events and perform actions.'" "dist/DirectionUI_8way_Mac.app/Contents/Info.plist" 2>/dev/null || true
    
else
    echo "❌ Build failed!"
    exit 1
fi

# DMGの作成（オプション）
read -p "Do you want to create a DMG installer? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Creating DMG..."
    # create-dmgツールがインストールされている場合
    if command -v create-dmg &> /dev/null; then
        create-dmg \
            --volname "DirectionUI 8way" \
            --window-pos 200 120 \
            --window-size 600 400 \
            --icon-size 100 \
            --icon "DirectionUI_8way_Mac.app" 200 190 \
            --hide-extension "DirectionUI_8way_Mac.app" \
            --app-drop-link 400 190 \
            "DirectionUI_8way_Mac.dmg" \
            "dist/"
        echo "✅ DMG created successfully!"
    else
        echo "create-dmg not found. Install it with: brew install create-dmg"
        echo "Or manually create DMG using Disk Utility"
    fi
fi

echo ""
echo "🎉 Build process complete!"
echo ""
echo "To run the app:"
echo "  open dist/DirectionUI_8way_Mac.app"
echo ""
echo "To add to Login Items (auto-start):"
echo "  1. Open System Preferences > Users & Groups"
echo "  2. Select your user account"
echo "  3. Click 'Login Items' tab"
echo "  4. Click '+' and add DirectionUI_8way_Mac.app"