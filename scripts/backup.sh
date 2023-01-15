#!/bin/bash

crypted="/media/external/crypted"
backup_dir="/media/veracrypt1/important"
targets=("/home/mike/.keepass/passwords.kdbx" "/home/mike/pwn/nightmare" "/home/mike/notes" "/home/mike/Desktop/important-docs")
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

############################
# Backup files using rsync

# Show user which files have been changed
echo "[+] These are the files that have been changed:"
for file in "${targets[@]}"; do
    leaf="$( echo ${file} | rev | cut -d'/' -f1 | rev )"
    sudo rsync -aAXHivcn "${file}" "${backup_dir}"
done

read -p "[!] Do you want to proceed with the backup [Y/n]? " usr
if [ -z $usr ] || [ $usr = "Y" ] || [ "$usr" = "y" ]; then
    for file in "${targets[@]}"; do
        leaf="$( echo ${file} | rev | cut -d'/' -f1 | rev )"
        sudo rsync -aAXHSvc "${file}" "${backup_dir}"
    done
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
