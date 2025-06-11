# DesktopCount

A minimal native macOS menu bar app that displays the current desktop (Space) number using yabai.

## Features
- Shows the current Space number (1–9 or 0) in the menu bar
- Updates automatically when you switch desktops
- No extra UI or features

---

## Prerequisites

- **Homebrew** (if not installed, run:)
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- **yabai** (for querying Spaces):
  ```sh
  brew install koekeishiya/formulae/yabai
  ```
- **Permissions:**
  - The first time you run yabai, you may be prompted to grant Accessibility permissions in System Settings > Privacy & Security > Accessibility. Approve if prompted.

---

## Installation (Automated)

1. **Clone this repo and run:**
   ```sh
   ./install.sh
   ```
   This will:
   - Build and install the DesktopCount app to your `~/Applications` folder
   - Set up a LaunchAgent so yabai runs automatically in the background at login

2. **Launch DesktopCount** from your `~/Applications` folder (or via Spotlight).

---

## Uninstallation

1. Delete `~/Applications/DesktopCount.app`.
2. Remove the LaunchAgent:
   ```sh
   launchctl unload ~/Library/LaunchAgents/com.koekeishiya.yabai.plist
   rm ~/Library/LaunchAgents/com.koekeishiya.yabai.plist
   ```

---

## Troubleshooting

- If you see a `?` in the menu bar:
  - Make sure yabai is installed and running: `pgrep yabai` should return a number.
  - Try running `/opt/homebrew/bin/yabai -m query --spaces` in Terminal. You should see a JSON array.
  - If you see permission errors, grant Accessibility permissions to yabai.
  - Check logs: `cat /tmp/yabai.err` and `cat /tmp/yabai.out`.

---

## Notes
- This app only uses yabai for querying the current Space. It does not use any tiling or window management features.
- No Dock icon, no extra UI—just the menu bar number.
- If you want to customize yabai, see the [yabai documentation](https://github.com/koekeishiya/yabai).
