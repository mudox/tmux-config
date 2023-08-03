#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"
source "${MDX_TMUX_DIR}/scripts/lib/menu.zsh"

nl
tint='green'
script   'Pane'      '%'   'respawn-pane.zsh'
# script   'Session'   '$'   'respawn-session.zsh'

nl
tint='red'
script   'Zsh'       'z'   'respawn-pane-with-zsh.zsh'
script   'Neovim'    'v'   'respawn-pane-with-neovim.zsh'

nl
tint='yellow'
item     'On...'     'q'   "display-panes 'respawn-pane -k -t %%'"
script   'More...'    '?'  'respawn-pane-with-ap-t.zsh'

tmux display-menu -T ' RESPAWN ' -xP -yP -- "${(@)menu}"
