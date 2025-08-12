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
