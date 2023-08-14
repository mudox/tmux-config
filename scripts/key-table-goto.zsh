#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

table_name='meta-y'
tmux bind-key -n -N 'Key table - meta y' 'M-y' switch-client -T "${table_name}"
bind() {
    tmux bind-key -T "${table_name}" "$@"
}

bind '?' list-keys -T "${table_name}" -P 'M-y ' -Na

# Goto
typeset -A goto

# Config
goto+=(
    'v'     Neovim
    'd'     Dotfiles
    't'     Tmux
    'h'     Hammerspoon
)

# Note
goto+=(
    'e'     Neorg:1
    'j'     Neorg:Journal
)

# Monitor
goto+=(
    'X'     Default:Top
)

# Default
goto+=(
    'y'     Default:Main
    'Space' Default:Main
)

for key target in "${(@kv)goto}"; do
    bind -N "Open ${target}" \
        "$key" run-shell "${scripts_dir}/switch-session.zsh ${target}"
done

# Ap
bind -N 'Open `ap` in popup' \
    'a' display-popup -E -w60% -h80% 'ap'

# Htop
bind -N 'Open `htop` in popup' \
    'x' display-popup -E -w70% -h80% 'htop --user mudox'

# Git
bind -N 'Open `lazygit` in popup' \
    'z' display-popup -E -w70% -h80% lazygit
bind -N 'Open `gitui` in popup' \
    'g' display-popup -E -w70% -h80% gitui

# Session navigation
bind -N 'Goto last session'       '/' switch-client -l
bind -N 'Goto previous session'   '[' switch-client -p
bind -N 'Goto next session'       ']' switch-client -n

# Menu
bind -N 'Show menu' \
    '-' run-shell "${MDX_TMUX_DIR}/scripts/menu-goto.zsh"

# Tav
bind -N 'Run Tav' 'M-y' run-shell tav
