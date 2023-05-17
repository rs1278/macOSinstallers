#!/bin/bash

# Variables
nudgeLatestURL="https://github.com/macadmins/nudge/releases/latest/"
versionUrl=$(curl "${nudgeLatestURL}" -s -L -I -o /dev/null -w '%{url_effective}')
versionNumber=$(printf "%s" "${versionUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
versionNumber=${versionNumber:1}
downloadUrl="https://github.com/macadmins/nudge/releases/download/v$versionNumber/Nudge-$versionNumber.pkg"
header="$(curl -sI "$downloadUrl" | tr -d '\r')"
pkgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
pkgPath="/tmp/$pkgName"
downloadUrl2="https://github.com/macadmins/nudge/releases/download/v$versionNumber/Nudge_LaunchAgent-1.0.1.pkg"
pkgName2=$(printf "%s" "${downloadUrl2[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
pkgPath2="/tmp/$pkgName2"

# Download files
/usr/bin/curl -L -o "$pkgPath" "$downloadUrl"
/usr/bin/curl -L -o "$pkgPath2" "$downloadUrl2"

# Install PKGs
sudo installer -pkg $pkgPath -target /
sudo installer -pkg $pkgPath2 -target /


# Delete PKGs
sudo /bin/rm "$pkgPath"
sudo /bin/rm "$pkgPath2"




exit 0
