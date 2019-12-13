#!/bin/sh
# grim /tmp/screen_lock.png
# convert /tmp/screen_lock.png -scale 1% -scale 10000% /tmp/screen_lock.png
# swaylock -i /tmp/screen_lock.png

outputs=$(swaymsg -t get_outputs | jq -r .[].name)

# Expects the phippy (https://www.cncf.io/phippy-goes-to-the-zoo-book/) images
# in ~/phippy/ with the images in pairs with:
# phippy-1-<num>.(png|jpg) for the picture
# phippy-2-<num>.(png|jpg) for the description
img_num=$(find ~/phippy/ -name '*.png' -or -name '*.jpg' | sed -E 's/.*phippy-[[:digit:]]+-(.*).(png|jpg)/\1/' | sort | uniq | shuf -n1)
img_pic=$(ls ~/phippy/phippy-1-${img_num}.*)
img_desc=$(ls ~/phippy/phippy-2-${img_num}.*)
lock_args=""
count=1
for output in ${outputs}; do
    if (( count == 1 )); then
        # The first screen is usually the (smaller) laptop screen
        # Put the slightly more boring description here
        lock_args="${lock_args} -i ${output}:${img_desc}"
    else
        # Show the nice picture on all other (larger) screens
        lock_args="${lock_args} -i ${output}:${img_pic}"
    fi
    (( count = count + 1 ))
done
swaylock --color 000000 --scaling fit ${lock_args}
