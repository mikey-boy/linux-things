#!/bin/bash

# A script to setup my config files

CONFIGS=".tmux.conf .bash_aliases .bash_fncs .bashrc .gdbinit"
RED='\033[0;31m';GRE='\033[0;32m';YEL='\033[1;33m';NC='\033[0m';

if [ ! -d ~/linux-things/configs ]; then
	echo -e "${RED}Missing config files, install linux-things in home directory"
	exit 1
fi

mkdir /tmp/confs
for conf in $CONFIGS; do
	if [ -f ~/$conf ]; then
		echo -e "${YEL}Found existing conf: $conf. Moving to /tmp/confs${NC}"
		mv ~/$conf /tmp/confs
	fi

	mv ~/linux-things/configs/$conf ~/		&& \
	ln ~/$conf ~/linux-things/configs/$conf 	&& \
	echo -e "${GRE}Successfully copied $conf${NC}"
done
