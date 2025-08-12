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
