#!/bin/sh
#Script auto fix time on hackintosh
#Version 1.1: Otc 11, 2015
#OSX: 10.6 and above

echo "This script required to run as root"

sudo curl -o "/tmp/localtime-toggle" "https://raw.githubusercontent.com/hieplpvip/LocalTime-Toggle/master/sbin/localtime-toggle"
sudo curl -o "/tmp/org.osx86.localtime-toggle.plist" "https://raw.githubusercontent.com/hieplpvip/LocalTime-Toggle/master/Library/LaunchDaemons/org.osx86.localtime-toggle.plist"

echo "Downloading required file"

# exit if error
if [ "$?" != "0" ]; then
echo "Error: Download failure, verify network"
exit 1
fi

echo "Copy file to destination place..."

sudo cp -R "/tmp/localtime-toggle" "/sbin/"
sudo cp -R "/tmp/org.osx86.localtime-toggle.plist" "/Library/LaunchDaemons/"

sudo rm /tmp/localtime-toggle
sudo rm /tmp/org.osx86.localtime-toggle.plist

echo "Chmod localtime-toggle..."

sudo chmod +x /sbin/localtime-toggle

echo "Chmod org.osx86.localtime-toggle.plist..."

sudo chown root /Library/LaunchDaemons/org.osx86.localtime-toggle.plist
sudo chmod 644 /Library/LaunchDaemons/org.osx86.localtime-toggle.plist

echo "Load LaunchDaemons..."

sudo launchctl load -w /Library/LaunchDaemons/org.osx86.localtime-toggle.plist

echo "Done!"
