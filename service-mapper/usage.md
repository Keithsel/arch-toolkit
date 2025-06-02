# Usage

## Setup

Make the script executable:

```bash
chmod +x service-mapper/map-services.sh
```

## Configuration

Edit the following variables in `map-services.sh`:

```bash
OBSIDIAN_VAULT_PATH="path/to/vault"                          # Your Obsidian vault directory
SERVICE_MAPS_DIR="$OBSIDIAN_VAULT_PATH/path/to/service-maps" # Service maps directory within vault
```

Note: These directories will automatically be created if they do not exist.

## Running the Script

```bash
cd service-mapper
./map-services.sh
```

## What it does

Scans all explicitly installed packages and identifies which systemd services each one provides. Creates a markdown file mapping packages to their services, helping you understand what services might be affected when removing packages.

## Output

Creates `Services List.md` in your Obsidian vault showing which services each package provides. Only packages that actually provide services are included in the output.

## Notes

Only analyzes explicitly installed packages (not dependencies). The script creates necessary directories automatically. Useful for understanding system dependencies before removing packages.
