#!/bin/bash

# if we get an error bail
set -euxo pipefail

if [ -z "$1" ]; then
    echo Usage ${0}: version
    echo       for example:
    echo
    echo       ${0} 2.0.0000-beta0
    echo
    exit
fi

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${1}" ./Sources/EpaySDK/Info.plist

/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ./Sources/EpaySDK/Info.plist