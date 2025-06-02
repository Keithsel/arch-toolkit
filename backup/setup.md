# Setup

- Make the backup script executable:

    ```bash
    chmod +x backup/backup.sh
    ```

- Edit the `backup.sh` script to configure your backup paths:
    - Change `SOURCE` variable to your actual source directory path (e.g., `/home/username`)
    - Change `DESTINATION` variable to your actual backup destination path (e.g., `/mnt/backup/arch-backup`)

- Customize the exclusions list by editing `exclusions.txt` to add or remove files/directories you want to exclude from the backup.

- Run the backup:

    ```bash
    sudo ./backup/backup.sh
    ```

The backup tool will:

- Create timestamped backup logs in the destination directory
- Use rsync with archive mode preserving permissions, timestamps, and extended attributes
- Show progress information during the backup process
- Calculate and log the final backup size
- Exclude files/directories listed in `exclusions.txt`

**Note:** The script uses `sudo` for rsync and logging operations to ensure proper permissions when backing up system files.
