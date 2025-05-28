#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OBSIDIAN_VAULT_PATH="path/to/vault"  # Replace with your actual Obsidian vault path
PACKAGE_LISTS_DIR="$OBSIDIAN_VAULT_PATH/path/to/package-lists"  # Replace with your actual package lists directory

DATE=$(date '+%Y-%m-%d %H:%M:%S')

baseline_explicitly="$SCRIPT_DIR/.baseline_explicitly.txt"
baseline_native="$SCRIPT_DIR/.baseline_native.txt"
baseline_foreign="$SCRIPT_DIR/.baseline_foreign.txt"

baseline_exists=false
if [[ -f "$baseline_explicitly" ]] || [[ -f "$baseline_native" ]] || [[ -f "$baseline_foreign" ]]; then
    baseline_exists=true
fi

if [[ "$baseline_exists" == "true" ]]; then
    echo "Current baseline files found. This will replace them with the current package state."
    echo ""
    
    current_explicitly="$(mktemp)"
    current_native="$(mktemp)"
    current_foreign="$(mktemp)"
    
    pacman -Qqet > "$current_explicitly"
    pacman -Qqent > "$current_native"
    pacman -Qqemt > "$current_foreign"
    
    echo "Changes since current baseline:"
    
    if [[ -f "$baseline_explicitly" ]]; then
        explicitly_added=$(comm -13 <(sort "$baseline_explicitly") <(sort "$current_explicitly") | wc -l)
        explicitly_removed=$(comm -23 <(sort "$baseline_explicitly") <(sort "$current_explicitly") | wc -l)
        echo "  - Explicitly installed: +$explicitly_added/-$explicitly_removed"
    fi
    
    if [[ -f "$baseline_native" ]]; then
        native_added=$(comm -13 <(sort "$baseline_native") <(sort "$current_native") | wc -l)
        native_removed=$(comm -23 <(sort "$baseline_native") <(sort "$current_native") | wc -l)
        echo "  - Native packages: +$native_added/-$native_removed"
    fi
    
    if [[ -f "$baseline_foreign" ]]; then
        foreign_added=$(comm -13 <(sort "$baseline_foreign") <(sort "$current_foreign") | wc -l)
        foreign_removed=$(comm -23 <(sort "$baseline_foreign") <(sort "$current_foreign") | wc -l)
        echo "  - Foreign packages: +$foreign_added/-$foreign_removed"
    fi
    
    rm -f "$current_explicitly" "$current_native" "$current_foreign"
    echo ""
else
    echo "No baseline files found. This will create the initial baseline."
    echo ""
fi

read -p "Do you want to commit the current package state as the new baseline? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo ""
echo "Creating new baseline..."

pacman -Qqet > "$baseline_explicitly"
pacman -Qqent > "$baseline_native"
pacman -Qqemt > "$baseline_foreign"

echo "✓ Created baseline_explicitly.txt ($(wc -l < "$baseline_explicitly") packages)"
echo "✓ Created baseline_native.txt ($(wc -l < "$baseline_native") packages)"
echo "✓ Created baseline_foreign.txt ($(wc -l < "$baseline_foreign") packages)"

if [[ -d "$PACKAGE_LISTS_DIR" ]]; then
    echo "**Last updated:** $DATE" > "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "**Baseline date:** $(date '+%Y-%m-%d')" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "**New baseline established.** No changes to track." >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "Future package installations, removals, and upgrades will be tracked against this baseline." >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    
    echo "✓ Updated Recent Changes.md"
fi

echo ""
echo "New baseline established successfully!"
echo "Future changes will be tracked against this state."
