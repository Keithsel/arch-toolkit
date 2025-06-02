# Usage

## Setup

1. Make all scripts executable:

   ```bash
   chmod +x package-tracker/*.sh
   ```

2. Install the package tracker hooks:

   ```bash
   cd package-tracker
   sudo ./install.sh
   ```

## Configuration

Edit the following variables in `update-package-lists.sh` and `commit-changes.sh`:

```bash
OBSIDIAN_VAULT_PATH="path/to/vault"                            # Your Obsidian vault directory
PACKAGE_LISTS_DIR="$OBSIDIAN_VAULT_PATH/path/to/package-lists" # Package list directory within vault
```

Note: These directories will automatically be created if they do not exist.

## Running the Scripts

1. Create the initial baseline:

   ```bash
   ./commit-changes.sh
   ```

2. The package tracker will now automatically run whenever you install or remove packages.

3. To commit current package state as a new baseline (after making package changes):

   ```bash
   ./commit-changes.sh
   ```

## What it does

Installs pacman hooks that automatically trigger when you install, remove, or upgrade packages. Creates baseline files to track changes and generates markdown reports showing what packages have been added or removed since your last baseline. All output goes to your Obsidian vault for easy browsing.

## Output

Package lists and change reports are saved to your specified Obsidian directory. The "Recent Changes" file shows differences from your current baseline, while individual package list files contain the full current state.

## Uninstall

To remove the package tracker hooks and stop automatic tracking:

```bash
cd package-tracker
sudo ./uninstall.sh
```

## Notes

The uninstall only removes pacman hooks - your existing package list files are preserved. Use `commit-changes.sh` to create/update baseline files. Works only with Arch Linux's pacman.
