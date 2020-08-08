#!/bin/bash

# A simple bash script to backup files and folders that I deem important
# Target format: .tar.gz

FILES=(~/notes)
DEST=/external/backup/

RED='\033[0;31m'
GRE='\033[0;32m'
NC='\033[0m'

# Check destination exists
if [ ! -d "$DEST" ]; then
        echo -e "${RED}[-]${NC} Backup destination '$DEST' does not exist. Aborting...."
        exit 1
fi

# Checking that all files/folders exist
for file in "${FILES[@]}"; do 
    if [ ! -f "$file" ] && [ ! -d "$file" ]; then
        echo -e "${RED}[-]${NC} File $file does not exist. Aborting...."
        exit 1
    fi
done

echo -e "${GRE}[+]${NC} Backup destination and all files listed exist"

# Copy files/folders to temp directory
tmp=$(mktemp -d)
echo -e "${GRE}[+]${NC} Copying all files/directories to $tmp"
for file in "${FILES[@]}"; do
        cp -r $file $tmp
done

# Create compressed archive
compressed="$(date +"%Y-%m-%d")-backup.tar.gz"
tar czf $compressed -C $tmp .
echo -e "${GRE}[+]${NC} Created compressed archive: $compressed"

# Move compressed archive
mv $compressed $DEST
echo -e "${GRE}[+]${NC} Successfully moved $compressed to $DEST"
