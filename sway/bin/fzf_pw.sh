#!/bin/bash
cd ~/.password-store
PW=$(find . -name '*.gpg' | sed -r 's|\./(.*)\.gpg|\1|' | fzf --prompt='pw > ')
if [ -z "$PW" ]; then
    exit 0
fi
bash -c "pw $PW"
sleep 2
