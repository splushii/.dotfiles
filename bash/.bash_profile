[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.work_profile ]] && . ~/.work_profile

# Seamless security
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)
eval $(/usr/bin/gpg-agent --daemon)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Emacs daemon
emacs --daemon || true

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ]; then
    if [ "$XDG_VTNR" -eq 1 ]; then
        exec startx
    elif [ "$XDG_VTNR" -eq 2 ]; then
        # Set wayland stuff
        export GDK_BACKEND=wayland
        export CLUTTER_BACKEND=wayland
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_FORCE_DPI=physical
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        pulseaudio --start
        exec sway
    fi
fi
