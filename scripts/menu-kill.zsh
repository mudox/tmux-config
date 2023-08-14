#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"
source "${MDX_TMUX_DIR}/scripts/lib/menu.zsh"

nl
tint='green'
item 'Pane'     '%'  'kill-pane'
item 'Window'   '@'  'kill-window'
item 'Session'  '$'  'kill-session'
item 'Server'   '!'  'kill-server'

nl
tint='red'
sep1 'WINDOW'
item 'Right'    'n'  'kill-window -t :+'
item 'Left'     'p'  'kill-window -t :-'
# TODO: select and kill
# script '...'  '/' 'choose-tree ...'

nl
tint='yellow'
sep1 'PANE'
item 'Right'    'l'  "kill-pane -t   '{right-of}'"
item 'Left'     'h'  "kill-pane -t   '{left-of}'"
item 'Up'       'k'  "kill-pane -t   '{up-of}'"
item 'Down'     'j'  "kill-pane -t   '{down-of}'"
item 'On...'    '/'  "display-panes  'kill-pane -t %%'"

tmux display-menu -T ' 󱓇  KILL ' -- "${(@)menu}"
