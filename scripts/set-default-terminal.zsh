#!/usr/bin/env zsh

# Determine server

if [[ -n $KITTY_WINDOW_ID ]]; then
    # Kitty
    dt=xterm-kitty
elif [[ -n $ALACRITTY_LOG ]]; then
    # Alacritty
    dt=alacritty
elif [[ -n $ITERM_SESSION_ID ]]; then
    # iTerm
    dt=
elif [[ -n $HYPER ]]; then
    # Hyper
    dt=
elif [[ $TERM_PROGRAM = vscode ]]; then
    # VSCode
    dt=
else
    dt=
fi

tmux set-option -g default-terminal "${dt}"
