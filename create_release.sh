#!/bin/bash

echo "Creating DirectionUI Release Package"
echo "===================================="

# バージョン番号を設定
VERSION="1.0.0"
RELEASE_NAME="DirectionUI_8way_Mac_v${VERSION}"
RELEASE_DIR="releases/${RELEASE_NAME}"

# リリースディレクトリを作成
echo "Creating release directory..."
mkdir -p "${RELEASE_DIR}"

# 1. アプリケーションをコピー
if [ -d "dist/DirectionUI_8way_Mac.app" ]; then
    echo "Copying application..."
    cp -r "dist/DirectionUI_8way_Mac.app" "${RELEASE_DIR}/"
else
    echo "❌ Error: Application not found. Please run ./build_mac.sh first"
    exit 1
fi

# 2. インストーラースクリプトを作成
echo "Creating installer script..."
cat > "${RELEASE_DIR}/Install DirectionUI.command" << 'EOF'
#!/bin/bash

# DirectionUI Installer for macOS
echo "DirectionUI 8way Installer"
echo "========================="
echo ""

# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# アプリケーションのパスを確認
APP_PATH="${SCRIPT_DIR}/DirectionUI_8way_Mac.app"

if [ ! -d "$APP_PATH" ]; then
    echo "❌ Error: DirectionUI_8way_Mac.app not found!"
    echo "Please make sure the app is in the same folder as this installer."
    read -p "Press Enter to exit..."
    exit 1
fi

# 1. アプリケーションをApplicationsフォルダにコピー
echo "Installing DirectionUI..."
cp -r "$APP_PATH" /Applications/
echo "✅ Application installed to /Applications/"

# 2. LaunchAgentを作成
echo ""
echo "Setting up auto-start..."
mkdir -p ~/Library/LaunchAgents

cat > ~/Library/LaunchAgents/com.autokey.directionui.plist << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.autokey.directionui</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/DirectionUI_8way_Mac.app/Contents/MacOS/DirectionUI_8way_Mac</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
PLIST

# 3. LaunchAgentを有効化
launchctl load ~/Library/LaunchAgents/com.autokey.directionui.plist 2>/dev/null
launchctl start com.autokey.directionui

echo "✅ Auto-start configured"
echo ""
echo "Installation complete!"
echo ""
echo "⚠️  IMPORTANT: macOS Security Settings"
echo "Please grant the following permissions:"
echo ""
echo "1. Go to System Settings > Privacy & Security > Privacy"
echo "2. Allow DirectionUI in 'Accessibility'"
echo "3. Allow DirectionUI in 'Screen Recording' (for screenshot feature)"
echo ""
read -p "Press Enter to open System Settings..."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

echo ""
echo "DirectionUI is now installed and running!"
echo "Hold the side mouse button and drag to use."
read -p "Press Enter to close this window..."
EOF

chmod +x "${RELEASE_DIR}/Install DirectionUI.command"

# 3. アンインストーラースクリプトを作成
echo "Creating uninstaller script..."
cat > "${RELEASE_DIR}/Uninstall DirectionUI.command" << 'EOF'
#!/bin/bash

echo "DirectionUI Uninstaller"
echo "======================"
echo ""

# 1. LaunchAgentを停止・削除
echo "Removing auto-start..."
launchctl stop com.autokey.directionui 2>/dev/null
launchctl unload ~/Library/LaunchAgents/com.autokey.directionui.plist 2>/dev/null
rm -f ~/Library/LaunchAgents/com.autokey.directionui.plist

# 2. アプリケーションを削除
echo "Removing application..."
rm -rf /Applications/DirectionUI_8way_Mac.app

echo ""
echo "✅ DirectionUI has been uninstalled"
echo ""
read -p "Press Enter to close this window..."
EOF

chmod +x "${RELEASE_DIR}/Uninstall DirectionUI.command"

# 4. READMEを作成
echo "Creating README..."
cat > "${RELEASE_DIR}/README.txt" << 'EOF'
DirectionUI 8way for macOS
==========================

A mouse gesture control application that provides quick access to common 
keyboard shortcuts through an intuitive radial menu interface.

INSTALLATION
------------
1. Double-click "Install DirectionUI.command"
2. Follow the on-screen instructions
3. Grant necessary permissions in System Settings

USAGE
-----
Hold the side mouse button (Mouse Button 4) and drag in any direction:
- ↑ Up: Select All (Cmd+A)
- ↗ Up-Right: Copy (Cmd+C)
- → Right: Save (Cmd+S)
- ↘ Down-Right: Paste (Cmd+V)
- ↓ Down: Enter
- ↙ Down-Left: Screenshot (Cmd+Shift+5)
- ← Left: Undo (Cmd+Z)
- ↖ Up-Left: Delete

UNINSTALLATION
--------------
Double-click "Uninstall DirectionUI.command"

TROUBLESHOOTING
---------------
If the app doesn't work:
1. Make sure you granted Accessibility permission
2. Make sure you have a mouse with side buttons
3. Try restarting the app or your Mac

For more information, visit: https://github.com/abelia123/AutoKey
EOF

# 5. DMGを作成（dmgutilがある場合）
if command -v create-dmg &> /dev/null; then
    echo ""
    echo "Creating DMG installer..."
    create-dmg \
        --volname "${RELEASE_NAME}" \
        --window-pos 200 120 \
        --window-size 600 400 \
        --icon-size 100 \
        --icon "DirectionUI_8way_Mac.app" 175 190 \
        --hide-extension "DirectionUI_8way_Mac.app" \
        --app-drop-link 425 190 \
        --text-size 12 \
        --background-color "#1e1e1e" \
        "${RELEASE_DIR}.dmg" \
        "${RELEASE_DIR}"
    echo "✅ DMG created: ${RELEASE_DIR}.dmg"
else
    echo "⚠️  create-dmg not found. Creating ZIP instead..."
    cd releases
    zip -r "${RELEASE_NAME}.zip" "${RELEASE_NAME}"
    cd ..
    echo "✅ ZIP created: releases/${RELEASE_NAME}.zip"
fi

echo ""
echo "Release package created successfully!"
echo "Location: ${RELEASE_DIR}"
echo ""
echo "Distribution files:"
echo "- ${RELEASE_DIR}/ (folder with all files)"
if [ -f "${RELEASE_DIR}.dmg" ]; then
    echo "- ${RELEASE_DIR}.dmg (DMG installer)"
else
    echo "- releases/${RELEASE_NAME}.zip (ZIP archive)"
fi