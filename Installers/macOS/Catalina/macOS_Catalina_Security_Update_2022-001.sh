#!/bin/sh

#Variables
updateURL="https://updates.cdn-apple.com/2022/macos/002-56999-20220125-DF55B049-F69C-429C-A119-C2E647FD97F5/SecUpd2022-001Catalina.dmg"
downloadUrl=$(curl "${updateURL}" -s -L -I -o /dev/null -w '%{url_effective}')
dmgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
dmgPath="/tmp/$dmgName"
pkgName="${dmgName/dmg/pkg}"


#Download file
sudo /usr/bin/curl -L -o "$dmgPath" "$downloadUrl"


# Attach DMG
location=${$(sudo hdiutil attach -nobrowse "$dmgPath" -quiet -verbose | grep "/Volumes/")#*HFS}
location=${location#*disk}
location=${location#*Volumes}
location=${location/#/"/Volumes"}

# Install pkg
sudo installer -pkg "$location/$pkgName" -target /


# Detach DMG
sudo /usr/bin/hdiutil detach "$location"

#Remove images
sudo /bin/rm "$dmgPath"



exit 0
