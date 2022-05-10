#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"
source "${MDX_TMUX_DIR}/scripts/lib/menu.zsh"

tint='green'
script   'Respawn'   'r'   'respawn-pane.zsh'
item     'Query'     'q'   "display-panes 'respawn-pane -k -t %%'"

nl
tint='yellow'
script   'Choose'    '?'   'respawn-pane-with-ap-t.zsh'

nl
tint='red'
script   'Zsh'       'z'   'respawn-pane-with-zsh.zsh'
script   'Neovim'    'v'   'respawn-pane-with-neovim.zsh'

tmux display-menu -xP -yP -- "${(@)menu}"
