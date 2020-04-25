# Odrive Sync

sync odrive folders and files at regular intervals. 

## Usage

    $ docker run -v /local/path:/odrive -e AUTH_KEY=yourauthkey -d kunikada/odrive-sync

### INTERVAL

Option `--health-interval` (default 10m)

### ENVIRONMENT

AUTH_KEY: created in odrive
