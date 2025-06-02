# Usage

## Prerequisites

- `fontforge`: Font editing software.
- `fontconfig`: Font configuration tools.

Install dependencies:

```bash
sudo pacman -S fontforge fontconfig
```

## Setup

1. Download the Nerd Fonts font-patcher from [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts):

   ```bash
   git clone https://github.com/ryanoasis/nerd-fonts.git
   ```

2. Create the backup directory for patched fonts:

   ```bash
   mkdir -p /path/to/your/backup/directory
   ```

3. Make the script executable:

   ```bash
   chmod +x nerd-font-patch/nerd_font_patch.sh
   ```

## Configuration

Edit the following variables in `nerd_font_patch.sh`:

```bash
INPUT_FOLDER="path/to/input"                     # Source font directory
OUTPUT_FOLDER="$HOME/.local/share/fonts"        # Font installation directory
FONT_PATCHER_FOLDER="path/to/font-patcher"      # Nerd Fonts font-patcher directory
BACKUP_FOLDER="path/to/backup"                  # Backup directory for patched fonts
FONT_TYPE="otf"                                 # Font file extension (otf, ttf, etc.)
```

## Running the Script

```bash
cd nerd-font-patch
./nerd_font_patch.sh
```

## What it does

Patches font files with Nerd Fonts icons and glyphs using FontForge. Installs patched fonts to your system, creates backup copies, and refreshes the font cache after each font for immediate availability.

## Output

Patched fonts are installed to `$HOME/.local/share/fonts` and backed up to your specified directory. Font cache is refreshed after each font processing.

## Notes

Original fonts are not modified. Use `fc-list` to verify fonts are installed correctly. The script processes all font files of the specified type in the input directory.
