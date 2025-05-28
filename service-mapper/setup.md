# Setup

- Make the script executable:

    ```bash
    chmod +x service-mapper/map-services.sh
    ```

- Change `OBSIDIAN_VAULT_PATH` and `SERVICE_MAPS_DIR` variables in `map-services.sh` to your Obsidian vault path and service maps directory, respectively. They will automatically be created if they do not exist.

- Run the service mapper:

  ```bash
  ./service-mapper/map-services.sh
  ```

This creates a simple markdown file with the date and a list showing which services each **explicitly installed** package provides.
