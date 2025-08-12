#!/bin/bash

echo "DirectionUI AutoStart Installer"
echo "==============================="

# 1. アプリケーションをApplicationsフォルダにコピー
if [ -d "dist/DirectionUI_8way_Mac.app" ]; then
    echo "Copying app to Applications folder..."
    cp -r dist/DirectionUI_8way_Mac.app /Applications/
    echo "✅ App installed to /Applications/"
else
    echo "❌ Error: DirectionUI_8way_Mac.app not found in dist/"
    echo "Please run ./build_mac.sh first"
    exit 1
fi

# 2. LaunchAgentをインストール
echo ""
echo "Installing LaunchAgent..."
mkdir -p ~/Library/LaunchAgents
cp com.autokey.directionui.plist ~/Library/LaunchAgents/
echo "✅ LaunchAgent installed"

# 3. LaunchAgentを有効化
echo ""
echo "Activating LaunchAgent..."
launchctl load ~/Library/LaunchAgents/com.autokey.directionui.plist 2>/dev/null
launchctl start com.autokey.directionui
echo "✅ LaunchAgent activated"

echo ""
echo "Installation complete!"
echo ""
echo "DirectionUI will now start automatically when you log in."
echo ""
echo "To uninstall auto-start:"
echo "  launchctl unload ~/Library/LaunchAgents/com.autokey.directionui.plist"
echo "  rm ~/Library/LaunchAgents/com.autokey.directionui.plist"
echo ""
echo "To stop the app:"
echo "  launchctl stop com.autokey.directionui"