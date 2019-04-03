#!/bin/bash
mkdir -p $HOME/bin
mkdir -p $HOME/.config
mkdir -p -m 0700 $HOME/.gnupg
stow bash emacs git gpg sway termite
