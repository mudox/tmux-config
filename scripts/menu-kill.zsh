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

nl
tint='yellow'
sep1 'PANE'
item 'Right'    'l'  "kill-pane -t   '{right-of}'"
item 'Left'     'h'  "kill-pane -t   '{left-of}'"
item 'Up'       'u'  "kill-pane -t   '{up-of}'"
item 'Down'     'd'  "kill-pane -t   '{down-of}'"
item 'On...'    '/'  "display-panes  'kill-pane -t %%'"

tmux display-menu -x P -y P -T ' 󱓇  KILL ' -- "${(@)menu}"
