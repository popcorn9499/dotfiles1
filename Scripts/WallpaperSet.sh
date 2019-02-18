#!/usr/bin/bash
while [ 1 -le 5 ]; do
    feh --recursive --randomize --bg-fill /mnt/MyMediaShare/User/Pictures/Wallpapers/*
    echo "cycled"
    sleep 500
done
