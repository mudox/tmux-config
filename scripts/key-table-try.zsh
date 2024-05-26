#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

TABLE_NAME='try'
TABLE_PREFIX=']'
source "${MDX_TMUX_DIR}/scripts/lib/key-table.zsh"

typeset -A map

# Config
map+=(
    'v'     Neovim
    'd'     Dotfiles
    't'     Tmux
    'h'     Hammerspoon
)

# Note
map+=(
    'e'     Neorg:1
    'j'     Neorg:Journal
)

# Monitor
map+=(
    'X'     Default:Top
)

# Default
map+=(
    'y'     Default:Main
    'Space' Default:Main
)

for key target in "${(@kv)map}"; do
    bind -N "Open ${target}" \
        "$key" run-shell "${scripts_dir}/switch-session.zsh ${target}"
done

popup=(display-popup -E -w60% -h80%)

# Ap
bind -N 'Open `ap` in popup' \
    'a' $popup 'ap'

# Htop
bind -N 'Open `htop` in popup' \
    'x' $popup 'htop --user mudox'

# Git
bind -N 'Open `lazygit` in popup' \
    'z' $popup lazygit
bind -N 'Open `gitui` in popup' \
    'g' $popup gitui
bind -N 'Launch GitTower' \
    'G' run-shell '/usr/local/bin/gittower .'

# Session navigation
bind -N 'Goto last session'       '/' switch-client -l
bind -N 'Goto previous session'   '[' switch-client -p
bind -N 'Goto next session'       ']' switch-client -n

# Menu
bind -N 'Show menu' \
    '-' run-shell "${MDX_TMUX_DIR}/scripts/menu-goto.zsh"

# Tav
bind -N 'Run Tav' 'M-y' run-shell tav
