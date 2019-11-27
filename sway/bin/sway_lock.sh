#!/bin/sh
# grim /tmp/screen_lock.png
# convert /tmp/screen_lock.png -scale 1% -scale 10000% /tmp/screen_lock.png
# swaylock -i /tmp/screen_lock.png


outputs=$(swaymsg -t get_outputs | jq -r .[].name)
image=$(find ~/phippy/ -name '*.png' -or -name '*.jpg' | shuf -n1)
lock_args=""
for output in ${outputs}; do
    lock_args="${lock_args} -i ${output}:${image}"
done
swaylock ${lock_args}
