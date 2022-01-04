# macOSinstallers
This project is for sharing simple .sh scripts to automatically download and install the latest macOS installers for various software.

They have been conveniantly put into in to .pkg form (via the postinstall script) for easy deployment using a macOS MDM tool such as JAMF. These pakages are UNSIGNED, but they only contain the .sh to install the specified software so they are safe to run.



# Sources
This project is an extension of others' work. Code for this project has been borrowed from or was inspiried by:
* https://www.jamf.com/jamf-nation/discussions/35211/updates-to-google-chrome-deployment-for-macos#responseChild200000
* https://community.jamf.com/t5/jamf-pro/latest-firefox-now-available-as-pkg/m-p/228261/highlight/true#M216508
* https://stackoverflow.com/questions/6881034/curl-to-grab-remote-filename-after-following-location
