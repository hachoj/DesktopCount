# DesktopCount

DesktopCount is a tiny menu bar application for macOS that shows the index of the currently active desktop (Space).  It relies on the [yabai](https://github.com/koekeishiya/yabai) window manager to determine the focused space and updates automatically whenever you switch.

## Installation

```bash
git clone <repo-url>
cd DesktopCount
./install.sh
```

The script builds the Xcode project using `xcodebuild` and installs `DesktopCount.app` into `~/Applications` by default.  Set the `DEST_DIR` environment variable if you wish to install elsewhere.  Xcode command line tools must be installed.

## Usage

After installation launch **DesktopCount.app** from Finder or Spotlight.  The menu bar icon displays the number of your active desktop and updates whenever you change spaces.

No additional interface is provided—quit the app from its menu bar icon if needed.
