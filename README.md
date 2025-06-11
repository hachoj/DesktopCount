# DesktopCount

DesktopCount is a minimal menu bar application that displays the number of the current macOS desktop (Space). The icon updates automatically whenever you switch spaces.

## Installation

```bash
git clone <repo-url>
cd DesktopCount
./install.sh
```

The script builds the app with `swiftc` (requires the Xcode command line tools) and installs it to `/Applications/DesktopCount.app`.

## Usage

After installation the app launches automatically. The menu bar will show a number representing your active desktop. Switch spaces as usual and the number updates immediately.

No additional UI is provided – simply quit the app from the menu bar if needed.
