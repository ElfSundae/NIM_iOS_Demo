#!/bin/bash
set -euo pipefail

if ! [[ -x "$(command -v xcodegen)" ]]; then
    echo 'Error: XcodeGen is not installed, see https://github.com/yonaskolb/XcodeGen'
    echo 'You may install XcodeGen by running `brew install xcodegen`'
    exit 1
fi

cd "$(dirname "$0")/.."

xcodegen

pod install
