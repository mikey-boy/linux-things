#!/bin/sh

SPEAKER=08:EF:3B:C5:BA:0A

echo -e "default-agent\npower on\npair $SPEAKER\n connect $SPEAKER\n" | bluetoothctl
