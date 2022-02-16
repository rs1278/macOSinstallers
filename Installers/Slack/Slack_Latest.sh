#!/bin/sh

#Variables
slackURL="https://slack.com/ssb/download-osx-universal"
downloadUrl=$(curl "${slackURL}" -s -L -I -o /dev/null -w '%{url_effective}')
dmgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
dmgPath="/tmp/$dmgName"
running=0

#Download file
sudo /usr/bin/curl -L -o "$dmgPath" "$downloadUrl"

# Attach DMG
sudo hdiutil attach -nobrowse "$dmgPath" -quiet

# Quit a running slack
[ $(ps aux | grep -v grep | grep -ci Slack) != 0 ] && sudo killall Slack && running=1

# Remove a previous installation (increases reliability)
[ -d /Applications/Slack.app ] && sudo rm -rf /Applications/Slack.app
[ -d ~/Slack.app ] && sudo rm -rf ~/Slack.app

# Move App to /Applications/
sudo cp -RL /Volumes/Slack*/Slack.app /Applications/

# Give non-Administrators the ability to update Slack (prevents popups non-Admins)
sudo chown -R :localaccounts /Applications/Slack.app && sudo chmod -R 755 /Applications/Slack.app


# Restore if running
if [ "$running" -eq 1 ]; then
open -a /Applications/Slack.app
fi

# Detach DMG
sudo hdiutil detach /Volumes/Slack*

#Remove downloaded DMG
sudo /bin/rm "$dmgPath"




exit 0
