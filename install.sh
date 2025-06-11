#!/bin/bash
set -e
APP="DesktopCount"

rm -rf "$APP.app"
mkdir -p "$APP.app/Contents/MacOS"
cp Info.plist "$APP.app/Contents/Info.plist"

swiftc Sources/DesktopCount.swift \
    -framework Cocoa \
    -framework ApplicationServices \
    -o "$APP.app/Contents/MacOS/$APP"

cp -R "$APP.app" "/Applications/$APP.app"

echo "Installed to /Applications/$APP.app"
open "/Applications/$APP.app"
