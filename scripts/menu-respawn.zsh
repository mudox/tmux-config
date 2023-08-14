#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"
source "${MDX_TMUX_DIR}/scripts/lib/menu.zsh"

nl
tint='green'
item   'Pane'     '%'  'respawn-pane -k'
item   'Window'   '@'  'respawn-window -k'

nl
tint='red'
sep1 'CURRENT PANE'
script 'Shell'    's'  'respawn-pane-with-zsh.zsh'
script 'Editor'   'e'  'respawn-pane-with-neovim.zsh'
script 'More...'  '?'  'respawn-pane-with-ap-t.zsh'

nl
tint='yellow'
sep1 'OTHER PANE'
item   'Right'  'l'  "respawn-pane -k -t '{right-of}'"
item   'Left'   'h'  "respawn-pane -k -t '{left-of}'"
item   'Up'     'k'  "respawn-pane -k -t '{up-of}'"
item   'Down'   'j'  "respawn-pane -k -t '{down-of}'"
item   'On...'  '/'  "display-panes 'respawn-pane -k -t %%'"

tmux display-menu -T '   RESPAWN ' -- "${(@)menu}"
