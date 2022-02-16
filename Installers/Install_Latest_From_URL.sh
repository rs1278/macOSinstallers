#!/bin/sh

####################################################################################################
#
# macOS Download & Install Script
#
####################################################################################################
#
# DESCRIPTION
#
# Download and install a DMG containing a .app or .pkg file, or stanadlone .pkg hosted on the web
#
####################################################################################################
#
# HISTORY
#
#
#Created 6-2-2020 by Shaquir Tannis
#Influenced by https://www.jamf.com/jamf-nation/discussions/35211/updates-to-google-chrome-deployment-for-macos#responseChild200000
#Script source: https://community.jamf.com/t5/jamf-pro/latest-firefox-now-available-as-pkg/m-p/228261/highlight/true#M216508
# Filename Helper Code from: https://stackoverflow.com/questions/6881034/curl-to-grab-remote-filename-after-following-location
#
# Generalized by Roman Sammartino

print_usage() {
  printf "Usage: \n macOSinstallers -d -u https://somesite.com/dmgURLcontainingAPP \n macOSinstallers -p -u https://somesite.com/pkgURL \n macOSinstallers -pd -u https://somesite.com/dmgURLcontainingPKG"
  exit 1
}

option=''
URL=''

while getopts ':dpu' flag; do
  case "${flag}" in
    d) option+="dmg" ;;
    p) option+="pkg" ;;
    u) regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
        if [[ "${OPTARG}" =~ $regex ]]; then;
        URL="${OPTARG}"
        else
        echo "${OPTARG} is NOT a valid URL"
        print_usage
        fi;;
    *) print_usage;;
  esac
done

#Variables
downloadUrl=$(curl "${URL}" -s -L -I -o /dev/null -w '%{url_effective}')
running=0

case "option" in

    dmg)
        # Grab the file name out of the URL
        dmgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
        # Path to save the DMG
        dmgPath="/tmp/$dmgName"

        #Download file
        sudo /usr/bin/curl -L -o "$dmgPath" "$downloadUrl"

        # Attach DMG and Retain Mount Location Path
        location=${$(sudo hdiutil attach -nobrowse "$dmgPath" -quiet -verbose | grep "/Volumes/")#*HFS}
        location=${location#*disk}
        location=${location#*Volumes}
        location=${location/#/"/Volumes"}
        
        # Find App Name
        name=$(ls $location | grep .app)
        
        # Quit a running App
        [ $(ps aux | grep -v grep | grep -ci ${name/.app}) != 0 ] && sudo killall ${name/.app} && running=1

        # Remove a previous installation (increases reliability)
        [ -d /Applications/$name ] && sudo rm -rf /Applications/$name

        # Move App to /Applications/
        sudo cp -RL $location/$name /Applications/

        # Restore if running
        if [ "$running" -eq 1 ]; then
        open -a /Applications/$name
        fi

        # Detach DMG
        sudo hdiutil detach $location

        #Remove downloaded DMG
        sudo /bin/rm "$dmgPath"
        ;;
    
    pkg)
        
        # Modify file extension. Sometimes, vendor's URLs work for both, but just need a tweak. Thunderbird is one example. This line should not hurt URLs already pointing to a .pkg
        downloadUrl=${downloadUrl/dmg/pkg}
        # Grab the file name out of the URL
        pkgName=$(printf "%s" "${downloadUrl[@]}" | sed 's@.*/@@' | sed 's/%20/-/g')
        # Location to save the PKG
        pkgPath="/tmp/$pkgName"

        #Downloads file
        /usr/bin/curl -L -o "$pkgPath" "$downloadUrl"


        # Install PKG
        sudo installer -pkg "$pkgPath" -target /


        #Remove downloaded PKG
        sudo /bin/rm "$pkgPath"
    
        ;;
    
    pkgdmg)
    
        ;;
    
esac

exit 0
    
