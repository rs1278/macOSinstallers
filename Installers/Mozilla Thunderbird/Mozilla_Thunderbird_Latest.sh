#!/bin/sh

#Variables
thunderbirdURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=en-US"
downloadUrl=$(curl "${thunderbirdURL}" -s -L -I -o /dev/null -w '%{url_effective}')
downloadUrl=${downloadUrl/dmg/pkg}
pkgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
pkgPath="/tmp/$pkgName"

#Downloads file
/usr/bin/curl -L -o "$pkgPath" "$downloadUrl"


# Install PKG
sudo installer -pkg "$pkgPath" -target /


#Remove downloaded PKG
sudo /bin/rm "$pkgPath"



exit 0
