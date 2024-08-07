#!/bin/bash

copy_latest_file() {
    local host="$1"
    local source_directory="$2"
    local destination_directory="$3"

    # Find the latest file in the source directory on the remote host
    latest_file=$(ssh "$host" ls -t "$source_directory" | head -n 1)

    if [ -n "$latest_file" ]; then
        # Check if the file already exists and is not a directory
        if [ -e "$destination_directory/$latest_file" ]; then
            echo "File '$latest_file' already exists in '$destination_directory'. Not copying."
        else
            # Copy the latest file from the remote host to the local destination directory
            scp "$host:$source_directory/$latest_file" "$destination_directory"
            echo "Latest file '$latest_file' copied from '$host:$source_directory' to '$destination_directory'."
        fi
    else
        echo "No files found in '$host:$source_directory'."
    fi
}

copy_directory() {
    local host="$1"
    local source_directory="$2"
    local destination_directory="$3"

    # Copy the entire directory from the remote host to the local destination directory
    rsync -r --delete "$host:$source_directory/" "$destination_directory"
    echo "Directory copied from '$host:$source_directory' to '$destination_directory'."
}

#copy_latest_file jport /valheim/backups /mnt/d/SynologyDrive/Games/ValheimWords/JamHeim/backups
copy_directory jport /gickup/backup /mnt/d/SynologyDrive/Repos
#copy_directory jport /actual-data/server-files /mnt/d/SynologyDrive/ActualBackup/server-files
#copy_directory jport /actual-data/user-files /mnt/d/SynologyDrive/ActualBackup/user-files
#copy_directory jport /jamleaf/sharelatex_data /mnt/d/SynologyDrive/Homelab/OverLeafBackup/sharelatex_data
#ssh jport 'cd /home/jamfox/overleaf_dump && mongodump --archive="$(date +%Y-%m-%d)_mongo.dump" --db=sharelatex --host=127.0.0.1 --port=27017'
#copy_latest_file jport /home/jamfox/overleaf_dump /mnt/d/SynologyDrive/Homelab/OverLeafBackup/mongo_data
copy_directory jport /itzg-minecraft/data/world '/mnt/d/SynologyDrive/Games/MinecraftWorlds/Better-Beta-3.2/multiplayer-world'
