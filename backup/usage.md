# Usage

## Setup

Make the backup script executable:

```bash
chmod +x backup/backup.sh
```

## Configuration

Edit the following variables in `backup.sh`:

```bash
SOURCE="path/to/source"           # Source directory to backup (e.g., /home/username)
DESTINATION="path/to/destination" # Backup destination directory (e.g., /mnt/backup/arch-backup)
```

Customize the exclusions list by editing `exclusions.txt` to add or remove files/directories you want to exclude from the backup.

## Running the Script

```bash
cd backup
sudo ./backup.sh
```

## What it does

Uses rsync to synchronize files from your source directory to the backup destination, excluding items listed in `exclusions.txt`. Creates timestamped logs and calculates the final backup size.

## Output

Backup files are synchronized to your destination directory with timestamped logs showing progress and final size.

## Notes

Runs with sudo to handle system files properly. Original files are never modified. Customize `exclusions.txt` to skip large or unnecessary files.
