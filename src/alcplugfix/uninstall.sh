#!/bin/bash

sudo launchctl unload /Library/LaunchAgents/good.win.ALCPlugFix.plist 2>/dev/null
sudo rm /usr/local/bin/ALCPlugFix 2>/dev/null
sudo rm /usr/local/bin/hda-verb 2>/dev/null
sudo rm /Library/LaunchAgents/good.win.ALCPlugFix.plist 2>/dev/null

exit 0
