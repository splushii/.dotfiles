[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.work_profile ]] && . ~/.work_profile

# Seamless security
eval $(/usr/bin/gpg-agent --daemon --enable-ssh-support)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY=$(tty)
echo UPDATESTARTUPTTY | gpg-connect-agent

# Emacs daemon
emacs --daemon || true
# Soundz
pulseaudio --kill
pulseaudio --start

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ]; then
    if [ "$XDG_VTNR" -eq 2 ]; then
        exec startx
    elif [ "$XDG_VTNR" -eq 1 ]; then
        # Set wayland stuff
        export GDK_BACKEND=wayland
        export CLUTTER_BACKEND=wayland
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_FORCE_DPI=physical
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        exec sway
    fi
fi
