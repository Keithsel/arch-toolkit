#!/bin/bash

set -e

INPUT_FOLDER="path/to/input"  # Replace with your actual font source directory
OUTPUT_FOLDER="$HOME/.local/share/fonts"  # Font installation directory
FONT_PATCHER_FOLDER="path/to/font-patcher"  # Replace with your actual font-patcher directory
BACKUP_FOLDER="path/to/backup"  # Replace with your actual backup directory
FONT_TYPE="otf"  # Font file extension (otf, ttf, etc.)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$INPUT_FOLDER" == "path/to/input" ]]; then
    echo "Error: Please set your input folder in the script."
    echo "Edit the INPUT_FOLDER variable in $SCRIPT_DIR/nerd_font_patch.sh"
    exit 1
fi

if [[ "$FONT_PATCHER_FOLDER" == "path/to/font-patcher" ]]; then
    echo "Error: Please set your font patcher folder in the script."
    echo "Edit the FONT_PATCHER_FOLDER variable in $SCRIPT_DIR/nerd_font_patch.sh"
    exit 1
fi

if [[ "$BACKUP_FOLDER" == "path/to/backup" ]]; then
    echo "Error: Please set your backup folder in the script."
    echo "Edit the BACKUP_FOLDER variable in $SCRIPT_DIR/nerd_font_patch.sh"
    exit 1
fi

if [[ ! -d "$INPUT_FOLDER" ]]; then
    echo "Error: Input folder does not exist: $INPUT_FOLDER"
    exit 1
fi

if [[ ! -d "$FONT_PATCHER_FOLDER" ]]; then
    echo "Error: Font patcher folder does not exist: $FONT_PATCHER_FOLDER"
    exit 1
fi

if [[ ! -f "$FONT_PATCHER_FOLDER/font-patcher" ]]; then
    echo "Error: font-patcher script not found in: $FONT_PATCHER_FOLDER"
    echo "Make sure you have cloned the Nerd Fonts repository and set the correct path."
    exit 1
fi

if [[ ! -d "$BACKUP_FOLDER" ]]; then
    echo "Error: Backup folder does not exist: $BACKUP_FOLDER"
    exit 1
fi

mkdir -p "$OUTPUT_FOLDER"

find "$INPUT_FOLDER" -type f -iname "*.$FONT_TYPE" | while read -r font_file; do
  echo "Processing: $font_file"

  font_filename=$(basename "$font_file")
  font_basename="${font_filename%.*}"

  echo "Using FontForge to patch font: $font_basename"
  fontforge -script "$FONT_PATCHER_FOLDER/font-patcher" "$font_file" -c --complete -out "$OUTPUT_FOLDER"

  # Find the most recently font installed as the patched font
  patched_font=$(find "$OUTPUT_FOLDER" -type f -iname "*.$FONT_TYPE" -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)

  if [[ -f "$patched_font" ]]; then
    echo "Copying patched font to backup: $BACKUP_FOLDER/$(basename "$patched_font")"
    cp "$patched_font" "$BACKUP_FOLDER/"
  else
    echo "Error: Patched font not found. Skipping backup."
    continue
  fi

  echo "Refreshing font cache..."
  fc-cache -fv

  echo "Font $font_basename processed successfully."
done

echo "All fonts processed."