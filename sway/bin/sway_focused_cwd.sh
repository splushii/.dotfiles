#!/bin/bash
W_PID=$(swaymsg -t get_tree | jq '.. | select(.focused? == true) | .pid')
W_CPID=$(pgrep --parent $W_PID)
readlink /proc/$W_CPID/cwd
