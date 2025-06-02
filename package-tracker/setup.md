# Setup

- Make all scripts executable:

    ```bash
    chmod +x package-tracker/*.sh
    ```

- Change OBSIDIAN_VAULT_PATH and PACKAGE_LIST_DIR variables in `update-package-list.sh` and `commit-changes.sh` to your Obsidian vault path and package list directory, respectively. They will automatically be created if they do not exist.
- Run `install.sh` to install the hooks:

  ```bash
  sudo ./install.sh
  ```

- Run `commit-changes.sh` to create the baseline and commit the changes:

  ```bash
  ./commit-changes.sh
  ```

- Every time you install or remove a package, the `package-tracker` will automatically update the package list and show the changes in the `Recent Changes` note in your Obsidian vault. If you want to commit the changes, run `commit-changes.sh` again.

## Uninstall

To remove the package tracker hooks and stop automatic tracking:

```bash
sudo ./uninstall.sh
```

**Note:** This only removes the pacman hooks. Your existing package list files in Obsidian will be preserved.
