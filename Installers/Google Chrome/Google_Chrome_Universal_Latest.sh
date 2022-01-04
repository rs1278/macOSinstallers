#!/bin/sh

#Variables
chromeURL="https://dl.google.com/dl/chrome/mac/universal/stable/gcem/GoogleChrome.pkg"
downloadUrl=$(curl "${chromeURL}" -s -L -I -o /dev/null -w '%{url_effective}')
pkgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
pkgPath="/tmp/$pkgName"

#Downloads file
/usr/bin/curl -L -o "$pkgPath" "$downloadUrl"


# Install PKG
sudo installer -pkg "$pkgPath" -target $3


#Remove downloaded PKG
sudo /bin/rm "$pkgPath"


exit 0
