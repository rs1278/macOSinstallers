#!/bin/sh

#Variables
firefoxURL="https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx"
downloadUrl=$(curl "${firefoxURL}" -s -L -I -o /dev/null -w '%{url_effective}')
pkgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
pkgPath="/tmp/$pkgName"

#Downloads file
/usr/bin/curl -L -o "$pkgPath" "$downloadUrl"


# Install PKG
sudo installer -pkg "$pkgPath" -target $3


#Remove downloaded PKG
sudo /bin/rm "$pkgPath"



exit 0
