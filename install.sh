#!/bin/bash
set -e

APP_NAME="DesktopCount"
PROJECT_DIR="$(dirname "$0")/DesktopCount"
BUILD_DIR="$PROJECT_DIR/build"
DEST_DIR="$HOME/Applications"

# Build the app
xcodebuild -project "$PROJECT_DIR/$APP_NAME.xcodeproj" -scheme "$APP_NAME" -configuration Release -derivedDataPath "$BUILD_DIR" build

# Find the built app
APP_PATH=$(find "$BUILD_DIR" -name "$APP_NAME.app" -type d | head -n 1)
if [ ! -d "$APP_PATH" ]; then
  echo "Build failed: $APP_NAME.app not found."
  exit 1
fi

# Create destination folder if needed
mkdir -p "$DEST_DIR"

# Copy the app
cp -R "$APP_PATH" "$DEST_DIR/"

if [ -d "$DEST_DIR/$APP_NAME.app" ]; then
  echo "Installed $APP_NAME to $DEST_DIR."
  echo "You can now launch it from Finder or Spotlight."
else
  echo "Failed to install $APP_NAME."
  exit 1
fi
