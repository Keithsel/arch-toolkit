#!/bin/bash

set -e

OBSIDIAN_VAULT_PATH="path/to/vault"  # Replace with your actual Obsidian vault path
SERVICE_MAPS_DIR="$OBSIDIAN_VAULT_PATH/path/to/service-maps"  # Replace with your actual service maps directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$OBSIDIAN_VAULT_PATH" == "path/to/vault" ]]; then
    echo "Error: Please set your Obsidian vault path in the script."
    echo "Edit the OBSIDIAN_VAULT_PATH variable in $SCRIPT_DIR/map-services.sh"
    exit 1
fi

if [[ "$SERVICE_MAPS_DIR" == "$OBSIDIAN_VAULT_PATH/path/to/service-maps" ]]; then
    echo "Error: Please set your service maps directory in the script."
    echo "Edit the SERVICE_MAPS_DIR variable in $SCRIPT_DIR/map-services.sh"
    exit 1
fi

mkdir -p "$OBSIDIAN_VAULT_PATH"
mkdir -p "$SERVICE_MAPS_DIR"

DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "Mapping services to packages..."

echo "**Last updated:** $DATE" > "$SERVICE_MAPS_DIR/Services List.md"
echo "" >> "$SERVICE_MAPS_DIR/Services List.md"

pacman -Qqet | while read -r package; do
    services=$(pacman -Ql "$package" 2>/dev/null | grep -E '\.service$' | awk '{print $2}' | xargs -I {} basename {} .service 2>/dev/null || true)
    
    if [[ -n "$services" ]]; then
        echo "**$package:**" >> "$SERVICE_MAPS_DIR/Services List.md"
        while IFS= read -r service; do
            if [[ -n "$service" ]]; then
                echo "- $service" >> "$SERVICE_MAPS_DIR/Services List.md"
            fi
        done <<< "$services"
        echo "" >> "$SERVICE_MAPS_DIR/Services List.md"
    fi
done

echo "Service mapping completed successfully at $(date)"
