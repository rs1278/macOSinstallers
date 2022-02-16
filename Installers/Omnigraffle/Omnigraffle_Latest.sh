#!/bin/sh

#Variables
graffleURL="https://www.omnigroup.com/download/latest/omnigraffle"
downloadUrl=$(curl "${graffleURL}" -s -L -I -o /dev/null -w '%{url_effective}')
dmgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
dmgPath="/tmp/$dmgName"
cdrPath="${dmgPath/dmg/cdr}"


#Download file
sudo /usr/bin/curl -L -o "$dmgPath" "$downloadUrl"

# Convert DMG to CDR
echo $cdrPath
sudo /usr/bin/hdiutil convert "$dmgPath" -format UDTO -o "$cdrPath"

# Attach DMG
sudo /usr/bin/hdiutil attach "$cdrPath" -nobrowse

# Move App to /Applications/
sudo /bin/cp -RL /Volumes/OmniGraffle/OmniGraffle.app /Applications/


# Detach DMG
sudo /usr/bin/hdiutil detach /Volumes/OmniGraffle*

#Remove images
sudo /bin/rm "$dmgPath"
sudo /bin/rm "$cdrPath"



exit 0
