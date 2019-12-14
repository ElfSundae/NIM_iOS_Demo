#!/bin/bash
set -euo pipefail

# Show the difference between two projects.

cd "$(dirname "$0")/.."

PROJECT1=working/NIM_iOS_Demo_v7.0.3/NIMDemo/NIM.xcodeproj
PROJECT2=NIM.xcodeproj

WORKING=working/diff
mkdir -p "$WORKING"

dump_project()
{
    originalFile="${1%/}"
    if [[ $originalFile != *.xcodeproj ]]; then
        echo "Source path is not a Xcode project file."
        exit 1
    fi

    if [[ ! -d "$originalFile"  ]]; then
        echo "$originalFile does not exist."
        exit 1
    fi

    backupFile="$originalFile.bak"
    rsync -a --delete "$originalFile/" "$backupFile"

    xcodeproj sort "$originalFile" > /dev/null
    xcodeproj show "$originalFile" > "$WORKING/$2"

    rsync -a --delete "$backupFile/" "$originalFile"
    rm -rf "$backupFile"

    echo "$WORKING/$2"
}

dump1=$(dump_project "$PROJECT1" "1_$(basename "$PROJECT1").dump")
dump2=$(dump_project "$PROJECT2" "2_$(basename "$PROJECT2").dump")

diff -u "$dump1" "$dump2" > "$WORKING/diff.patch" || true

opendiff "$dump1" "$dump2"
