[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.work_profile ]] && . ~/.work_profile

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ]; then
    if [ "$XDG_VTNR" -eq 2 ]; then
        exec startx
    elif [ "$XDG_VTNR" -eq 1 ]; then
        # Set wayland stuff
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export MOZ_ENABLE_WAYLAND=1
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_FORCE_DPI=physical
        export CLUTTER_BACKEND=wayland
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        exec sway 2>&1 >> ${HOME}/.sway.log
    fi
fi
