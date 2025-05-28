#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="/etc/pacman.d/hooks"
HOOK_FILE="$HOOKS_DIR/obsidian-package-tracker.hook"
UPDATE_SCRIPT="$SCRIPT_DIR/update-package-lists.sh"
SU="$(which su)"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   echo "Usage: sudo $0"
   exit 1
fi

if [[ ! -f "$HOOK_FILE" ]]; then
    echo "Error: Hook file not found at $HOOK_FILE"
    exit 1
fi

if [[ ! -f "$UPDATE_SCRIPT" ]]; then
    echo "Error: Update script not found at $UPDATE_SCRIPT"
    exit 1
fi

echo "Creating hooks directory..."
mkdir -p "$HOOKS_DIR"

echo "Creating hook file..."
echo "[Trigger]
Operation = Install
Operation = Remove
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Updating package lists for Obsidian...
When = PostTransaction
Exec = "$SU $SUDO_USER -c $UPDATE_SCRIPT"
Depends = pacman
" > "$HOOK_FILE"

echo "Setting permissions..."
chmod +x "$UPDATE_SCRIPT"

echo "The pacman hook has been installed to: $HOOK_FILE"
echo "Update script location: $UPDATE_SCRIPT"
echo ""
echo "IMPORTANT: Edit the update script to set your Obsidian vault path!"
echo ""
echo "To edit the path, run:"
echo "vim (or your preferred editor) $UPDATE_SCRIPT"
echo ""
echo "Look for the line: OBSIDIAN_VAULT_PATH="
echo "And change it to your actual Obsidian vault path."
echo ""
echo "After setting the correct path, test the script manually:"
echo "$UPDATE_SCRIPT"
echo ""
echo "From now on, your package lists will be automatically updated whenever"
echo "you install, remove, or upgrade packages with pacman!"
