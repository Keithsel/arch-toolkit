#!/bin/bash

set -e

OBSIDIAN_VAULT_PATH="path/to/vault"  # Replace with your actual Obsidian vault path
PACKAGE_LISTS_DIR="$OBSIDIAN_VAULT_PATH/path/to/package-lists"  # Replace with your actual package lists directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$PACKAGE_LISTS_DIR"

DATE=$(date '+%Y-%m-%d %H:%M:%S')

detect_cumulative_changes() {
    local current_file="$1"
    local baseline_file="$2"
    local package_type="$3"
    
    if [[ -f "$baseline_file" ]]; then
        local added=$(comm -13 <(sort "$baseline_file") <(sort "$current_file"))
        local removed=$(comm -23 <(sort "$baseline_file") <(sort "$current_file"))
        
        local added_count=0
        local removed_count=0
        [[ -n "$added" ]] && added_count=$(echo "$added" | wc -l)
        [[ -n "$removed" ]] && removed_count=$(echo "$removed" | wc -l)
        
        if [[ -n "$added" || -n "$removed" ]]; then
            echo "### $package_type Changes (+$added_count/-$removed_count)" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
            echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
            
            if [[ -n "$added" ]]; then
                echo "**Added since baseline:**" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
                echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
                echo "$added" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
                echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
                echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
            fi
            
            if [[ -n "$removed" ]]; then
                echo "**Removed since baseline:**" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
                echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
                echo "$removed" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
                echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
                echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
            fi
        fi
        
        return $((added_count + removed_count))
    else
        echo "### $package_type Changes" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
        echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
        echo "**Initial package list created** ($(wc -l < "$current_file") packages)" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
        echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
        return 1
    fi
}

current_explicitly="$SCRIPT_DIR/.current_explicitly.tmp"
current_native="$SCRIPT_DIR/.current_native.tmp"
current_foreign="$SCRIPT_DIR/.current_foreign.tmp"

pacman -Qqet > "$current_explicitly"
pacman -Qqent > "$current_native"
pacman -Qqemt > "$current_foreign"

baseline_explicitly="$SCRIPT_DIR/.baseline_explicitly.txt"
baseline_native="$SCRIPT_DIR/.baseline_native.txt"
baseline_foreign="$SCRIPT_DIR/.baseline_foreign.txt"

baseline_date="unknown"
if [[ -f "$baseline_explicitly" ]]; then
    baseline_date=$(stat -c %y "$baseline_explicitly" | cut -d' ' -f1)
fi

echo "**Last updated:** $DATE" > "$PACKAGE_LISTS_DIR/Recent Changes.md"
echo "**Baseline date:** $baseline_date" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"

total_changes=0
set +e
detect_cumulative_changes "$current_explicitly" "$baseline_explicitly" "Explicitly Installed Packages"
explicitly_changes=$?
total_changes=$explicitly_changes 
detect_cumulative_changes "$current_native" "$baseline_native" "Native Packages"
detect_cumulative_changes "$current_foreign" "$baseline_foreign" "Foreign Packages"
set -e

if [[ $total_changes -eq 0 ]]; then
    echo "**No package changes detected since baseline ($baseline_date).**" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
fi

if [[ $total_changes -gt 0 ]]; then
    echo "---" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "**Total explicitly installed packages modified:** $total_changes since baseline" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "To commit these changes as a new baseline, run:" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "\`\`\`bash" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "$SCRIPT_DIR/commit-changes.sh" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
    echo "" >> "$PACKAGE_LISTS_DIR/Recent Changes.md"
fi

echo "**Last updated:** $DATE" > "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"
echo "Total packages: $(wc -l < "$current_explicitly")" >> "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"
echo "Note: Excludes packages that are dependencies of other explicitly installed packages." >> "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"
echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"
cat "$current_explicitly" >> "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"
echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Explicitly Installed Packages.md"

echo "**Last updated:** $DATE" > "$PACKAGE_LISTS_DIR/Native Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Native Packages.md"
echo "Total packages: $(wc -l < "$current_native")" >> "$PACKAGE_LISTS_DIR/Native Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Native Packages.md"
echo "Note: Excludes packages that are dependencies of other explicitly installed packages." >> "$PACKAGE_LISTS_DIR/Native Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Native Packages.md"
echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Native Packages.md"
cat "$current_native" >> "$PACKAGE_LISTS_DIR/Native Packages.md"
echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Native Packages.md"

echo "**Last updated:** $DATE" > "$PACKAGE_LISTS_DIR/Foreign Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Foreign Packages.md"
echo "Total packages: $(wc -l < "$current_foreign")" >> "$PACKAGE_LISTS_DIR/Foreign Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Foreign Packages.md"
echo "Note: Excludes packages that are dependencies of other explicitly installed packages." >> "$PACKAGE_LISTS_DIR/Foreign Packages.md"
echo "" >> "$PACKAGE_LISTS_DIR/Foreign Packages.md"
echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Foreign Packages.md"
cat "$current_foreign" >> "$PACKAGE_LISTS_DIR/Foreign Packages.md"
echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Foreign Packages.md"

echo "**Last updated:** $DATE" > "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "## Quick Stats" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "- **Explicitly installed (top-level):** $(wc -l < "$current_explicitly")" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "- **Native packages (top-level):** $(wc -l < "$current_native")" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "- **Foreign packages (top-level):** $(wc -l < "$current_foreign")" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "- **Total installed packages:** $(pacman -Qq | wc -l)" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"

if [[ $total_changes -gt 0 ]]; then
    echo "- **Explicitly installed packages changed since baseline:** $total_changes" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
fi

echo "" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "## Package Lists" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "- [[Recent Changes]] - Cumulative changes since baseline" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "- [[Explicitly Installed Packages]] - Top-level packages you've explicitly installed" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "- [[Native Packages]] - Top-level packages from official Arch repositories" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "- [[Foreign Packages]] - Top-level packages from AUR and other external sources" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "## Usage Commands" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "To restore packages on a new system:" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "\`\`\`bash" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "# Install native packages" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "sudo pacman -S --needed - < native_packages.txt" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "# Install AUR packages (requires yay or another AUR helper)" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "yay -S --needed - < foreign_packages.txt" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"
echo "\`\`\`" >> "$PACKAGE_LISTS_DIR/Package Lists Overview.md"

pacman -Qqent > "$SCRIPT_DIR/native_packages.txt" &
pacman -Qqemt > "$SCRIPT_DIR/foreign_packages.txt" &
pacman -Qqet > "$SCRIPT_DIR/explicitly_installed.txt" &

rm "$current_explicitly" "$current_native" "$current_foreign"

echo "Package lists updated successfully at $(date)"
