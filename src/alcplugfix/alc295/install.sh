#!/bin/bash

sudo cp ALCPlugFix /usr/local/bin
sudo chmod 755 /usr/local/bin/ALCPlugFix
sudo chown root:wheel /usr/local/bin/ALCPlugFix

sudo cp hda-verb /usr/local/bin
sudo chmod 755 /usr/local/bin/hda-verb
sudo chown root:wheel /usr/local/bin/hda-verb

sudo cp good.win.ALCPlugFix.plist /Library/LaunchAgents/
sudo chmod 644 /Library/LaunchAgents/good.win.ALCPlugFix.plist
sudo chown root:wheel /Library/LaunchAgents/good.win.ALCPlugFix.plist

sudo launchctl unload /Library/LaunchAgents/good.win.ALCPlugFix.plist 2>/dev/null
sudo launchctl load /Library/LaunchAgents/good.win.ALCPlugFix.plist

exit 0
