#!/bin/sh
grim /tmp/screen_lock.png
convert /tmp/screen_lock.png -scale 1% -scale 10000% /tmp/screen_lock.png
swaylock -i /tmp/screen_lock.png
