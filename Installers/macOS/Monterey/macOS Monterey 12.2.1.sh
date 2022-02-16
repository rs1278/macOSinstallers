#!/bin/sh

#Variables
macOSURL="http://swcdn.apple.com/content/downloads/11/62/002-66265-A_HKQGKQG1Z4/orfaxf4k2gvqeatuhx6agnr5nlti3rwq93/InstallAssistant.pkg"
downloadUrl=$(curl "${macOSURL}" -s -L -I -o /dev/null -w '%{url_effective}')
pkgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
pkgPath="/tmp/$pkgName"

#Downloads file
/usr/bin/curl -L -o "$pkgPath" "$downloadUrl"


# Install PKG
sudo installer -pkg "$pkgPath" -target $3


#Remove downloaded PKG
sudo /bin/rm "$pkgPath"



exit 0
