#!/bin/bash

crypted="/media/external/crypted"
target="/media/veracrypt1/sysbackup/"
newdir="${target}$(date +%F)"            # Format YYYY-MM-DD
auto=0

# Check if user wants to auto close container/mount after backup
if [[ $1 == "--auto" ]] || [[ $1 == "--skip" ]] ; then
    auto=1
fi

# Mount external drive
echo "[+] Checking if external drive is mounted"
if ! mount | grep /media/external > /dev/null ; then
    sudo mount /media/external || exit 1
fi

# Mount veracrypt volume
echo "[+] Checking if encrypted container is mounted"
sudo veracrypt --text --non-interactive --list "$crypted" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    read -e -sp "[!] Please enter the password for '$crypted': " enc_pass
    echo ""
    sudo veracrypt --text --non-interactive --password="$enc_pass" --mount $crypted /media/veracrypt1 || exit 1
fi

# If backup directory already exists (from a backup on the same day) abort
# otherwise we will clobber that directory
if [ -d ${newdir} ]; then
    echo "[!] It seems like the backup directory ${newdir} already exists! Exiting now..."
    exit 1
fi

############################
# Finding the oldest backup

ts=$(date +%s)
old=""

for d in ${target}*; do
    dt=$(echo "${d}" | grep -Eo "[0-9]{4}-[0-9]{2}-[0-9]{2}")
    cur_ts=$(date -d "${dt}" +%s)
    if (( $cur_ts < $ts )); then
        ts=$cur_ts
        old="${d}"
    fi
done

echo "[*] Oldest directory is: ${old}"

############################
# Backup system using rsync

# Show user which files have been changed
#echo "[+] These are the files that have been changed:"
#sudo rsync -aAXHivcn --exclude-from="exclude.txt" / "/media/veracrypt1${target_dir}" | egrep '^>' | cut -d' ' -f2

read -p "[!] Do you want to proceed with the backup [Y/n]? " usr
if [ -z $usr ] || [ $usr = "Y" ] || [ "$usr" = "y" ]; then
    # Instruct user to close windows and files
    read -p "[!] Please close open windows and files. Press Enter to continue: " null

    # Rename oldest directory
    echo "[*] Renaming ${old} to ${newdir}"
    mv "${old}" "${newdir}"

    #sudo rsync -aAXHSvc --delete --exclude-from="exclude.txt" / "/media/veracrypt1/sysbackup/${target_dir}"
    sudo rsync -aAXHSvc --delete --exclude-from="exclude.txt" / "${newdir}"
fi

############################

# Ask if user wants to close encrypted container
(( $auto == 1 )) || read -p "[+] Would you like to close the encrypted container [Y/n]? " usr2
if (( $auto == 1 )) || [ -z $usr2 ] || [ $usr2 = "Y" ] || [ $usr2 = "y" ]; then
    sudo veracrypt -d $crypted

    # Ask if user wants to unmount external drive
    (( $auto == 1 )) || read -p "[+] Would you like to unmount the external drive [Y/n]? " usr3
    if (( $auto == 1 )) || [ -z $usr3 ] || [ $usr3 = "Y" ] || [ $usr3 = "y" ]; then
        sudo umount /media/external
    fi
fi
