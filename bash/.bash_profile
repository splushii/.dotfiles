[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.work_profile ]] && . ~/.work_profile

# Seamless security
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)
eval $(/usr/bin/gpg-agent --daemon)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Emacs daemon
emacs --daemon || true

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec startx
fi
