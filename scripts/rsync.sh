#!/bin/bash

target="/external/sys-backup"
target_dir="/2021-02-17"

# Check if external drive is mounted
echo "[+] Checking if external drive is mounted"
if [ ! $( mount | grep rpi2:/external > /dev/null ) ]; then
    sudo mount /external || exit 1
fi

# Mount veracrypt volume
echo "[+] Checking if encrypted container is mounted"
veracrypt --text --non-interactive --list "$target" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    read -e -sp "[!] Please enter the password for '$target': " enc_pass
    echo ""
    veracrypt --text --non-interactive --password="$enc_pass" --mount $target /media/veracrypt1 || exit 1
fi

############################
# Backup system using rsync

# Show user which files have been changed
#echo "[+] These are the files that have been changed:"
#sudo rsync -aAXHivcn --exclude-from="exclude.txt" / "/media/veracrypt1${target_dir}" | egrep '^>' | cut -d' ' -f2

read -p "[!] Do you want to proceed with the backup [Y/n]? " usr
if [ -z $usr ] || [ $usr = "Y" ] || [ "$usr" = "y" ]; then
    # Instruct user to close windows and files
    read -p "[!] Please close open windows and files. Press Enter to continue: " null

    sudo rsync -aAXHSvc --delete --exclude-from="exclude.txt" / "/media/veracrypt1${target_dir}"
fi

############################

# Ask if user wants to close encrypted container
read -p "[+] Would you like to close the encrypted container [Y/n]? " usr2
if [ -z $usr2 ] || [ $usr2 = "Y" ] || [ $usr2 = "y" ]; then
    veracrypt -d $target
fi

# Ask if user wants to unmount external drive
read -p "[+] Would you like to unmount the external drive [Y/n]? " usr3
if [ -z $usr3 ] || [ $usr3 = "Y" ] || [ $usr3 = "y" ]; then
    sudo umount /external
fi
