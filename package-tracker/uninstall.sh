#!/bin/bash

set -e

HOOKS_DIR="/etc/pacman.d/hooks"
HOOK_FILE="$HOOKS_DIR/obsidian-package-tracker.hook"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   echo "Usage: sudo $0"
   exit 1
fi

if [[ ! -f "$HOOK_FILE" ]]; then
    echo "Hook file not found at $HOOK_FILE"
    echo "It may already be uninstalled or was installed in a different location."
    exit 1
fi

echo "Removing pacman hook..."
rm "$HOOK_FILE"

echo "The pacman hook has been removed."
echo "Your existing package list files in Obsidian have been left untouched."
echo ""
echo "Package lists will no longer be automatically updated when you"
echo "install, remove, or upgrade packages."
