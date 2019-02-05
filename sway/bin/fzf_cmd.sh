#!/bin/bash
CMD=$(compgen -ac | sort -u | fzf --prompt 'exec > ')
swaymsg -t command exec -- bash -c "$CMD"
