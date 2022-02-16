#!/bin/sh

#Variables
officeURL="https://go.microsoft.com/fwlink/p/?linkid=525133"
downloadUrl=$(curl "${officeURL}" -s -L -I -o /dev/null -w '%{url_effective}')
pkgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
pkgPath="/tmp/$pkgName"

#Downloads file
/usr/bin/curl -L -o "$pkgPath" "$downloadUrl"


# Install PKG
sudo installer -pkg "$pkgPath" -target /


#Remove downloaded PKG
sudo /bin/rm "$pkgPath"


exit 0
