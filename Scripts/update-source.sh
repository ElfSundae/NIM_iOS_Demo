#!/bin/bash
set -euo pipefail

URL='https://yx-web-nosdn.netease.im/package/1575456096/NIM_iOS_Demo_v7.0.3.zip?download=NIM_iOS_Demo_v7.0.3.zip'

# @args: url path Enterprise|Professional
download()
{
    if [[ -f $2 ]] && ! check_version_in_zip $2 $3; then
        rm -f $2
    fi

    if [[ ! -f $2 ]]; then
        wget $1 -c -O $2.tmp && mv $2.tmp $2 || rm -f $2.tmp

        if [[ ! -f $2 ]]; then
            exit 404
        fi
    fi

    if ! check_version_in_zip $2 $3; then
        rootInZip=$(root_dir_in_zip $2)
        echo "Error: SDK version in the zip file ($rootInZip) is not equal to $SDK_VERSION"
        exit 1
    fi
}

Remove:
NIMDemo/Supporting%20Files/NIMKitEmoticon.bundle
NIMDemo/Supporting%20Files/NIMKitResource.bundle
NIMDemo/Vendors/NIMAVChat
NIMDemo/Vendors/NIMSDK

mv:
Settings.bundle to NIMDemo/Supporting Files

Run xcodegen, remove xcworkspace, pod update,

Show diff patch:

cd official
xcodeproj sort ~/Downloads/NIM_iOS_Demo_v7.0.3/NIMDemo/NIM.xcodeproj
xcodeproj show ~/Downloads/NIM_iOS_Demo_v7.0.3/NIMDemo/NIM.xcodeproj > ~/Desktop/official

xcodeproj sort ~/working/NIM_iOS_Demo/NIMDemo.xcodeproj
xcodeproj show ~/working/NIM_iOS_Demo/NIMDemo.xcodeproj > ~/Desktop/my

diff -u ~/Desktop/official ~/Desktop/my > ~/Desktop/diff.patch
