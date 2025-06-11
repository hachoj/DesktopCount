#!/bin/bash
set -e

APP_NAME="DesktopCount"
PROJECT_DIR="$(dirname "$0")/DesktopCount"
BUILD_DIR="$PROJECT_DIR/build"
DEST_DIR="$HOME/Applications"
YABAI_PATH="/opt/homebrew/bin/yabai"
PLIST="$HOME/Library/LaunchAgents/com.koekeishiya.yabai.plist"

if ! command -v xcodebuild >/dev/null; then
  echo "xcodebuild not found. Please install Xcode command line tools." >&2
  exit 1
fi

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
else
  echo "Failed to install $APP_NAME."
  exit 1
fi

# Set up yabai LaunchAgent
if [ -x "$YABAI_PATH" ]; then
  echo "yabai found at $YABAI_PATH. Setting up LaunchAgent..."
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.koekeishiya.yabai</string>
    <key>ProgramArguments</key>
    <array>
        <string>$YABAI_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/yabai.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/yabai.out</string>
</dict>
</plist>
EOF
  launchctl unload "$PLIST" 2>/dev/null || true
  launchctl load "$PLIST"
  echo "yabai LaunchAgent loaded. yabai will run in the background at login."
else
  echo "yabai not found at $YABAI_PATH. Please install yabai with Homebrew: brew install koekeishiya/formulae/yabai"
fi

echo "You can now launch DesktopCount from Finder or Spotlight."
