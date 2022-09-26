#!/bin/bash

# Variables
nudgeLatestURL="https://github.com/macadmins/nudge/releases/latest/"
versionUrl=$(curl "${nudgeLatestURL}" -s -L -I -o /dev/null -w '%{url_effective}')
versionNumber=$(printf "%s" "${versionUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
versionNumber=${versionNumber:1}
downloadUrl="https://github.com/macadmins/nudge/releases/download/v$versionNumber/Nudge_Suite-$versionNumber.pkg"
header="$(curl -sI "$downloadUrl" | tr -d '\r')"
pkgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
pkgPath="/tmp/$pkgName"

# Download files
/usr/bin/curl -L -o "$pkgPath" "$downloadUrl"

# Install PKGs
sudo installer -pkg $pkgPath -target /


# Delete PKGs
sudo /bin/rm "$pkgPath"



exit 0
