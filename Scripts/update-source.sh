#!/bin/bash
set -euo pipefail

# Update source code from Netease official project:
# https://yunxin.163.com/im-sdk-demo
URL='https://yx-web-nosdn.netease.im/package/1589359721/NIM_iOS_Demo_v7.6.0.zip?download=NIM_iOS_Demo_v7.6.0.zip'

WORKING=working

download()
{
    destFile="$WORKING/$(basename "${1%\?*}")"
    tempFile="$destFile.tmp"

    if [[ ! -f "$destFile" ]]; then
        wget "$1" -c -O "$tempFile" && mv "$tempFile" "$destFile" \
            || rm -f "$tempFile"
    fi

    if [[ -f "$destFile" ]]; then
        echo "$destFile"
    fi
}

cd "$(dirname "$0")/.."
mkdir -p "$WORKING"

downloadedFile=$(download "$URL")
[ -z "$downloadedFile" ] && exit 4

srcRoot=${downloadedFile%.zip}
rm -rf "$srcRoot"
unzip -q "$downloadedFile" -d "$srcRoot"

rsync -a --delete "$srcRoot/NIMDemo/NIMDemo" .
rsync -a --delete "$srcRoot/NIMDemo/NotificationScene" .
rsync -a --delete "$srcRoot/NIMDemo/NotificationService" .
rsync -a --delete "$srcRoot/NIMDemo/Settings.bundle" "NIMDemo/Supporting Files"

rm -rf "NIMDemo/Supporting Files/NIMKitEmoticon.bundle"
rm -rf "NIMDemo/Supporting Files/NIMKitResource.bundle"
rm -rf "NIMDemo/Supporting Files/NIMLanguage.bundle"
rm -rf "NIMDemo/Vendors/NIMAVChat"
rm -rf "NIMDemo/Vendors/NIMSDK"

echo "Updated official source code."

if ! [[ -x "$(command -v xcodegen)" ]]; then
    echo 'Error: XcodeGen is not installed, see https://github.com/yonaskolb/XcodeGen'
    echo 'You may install XcodeGen by running `brew install xcodegen`'
    exit 1
fi

xcodegen

pod update
