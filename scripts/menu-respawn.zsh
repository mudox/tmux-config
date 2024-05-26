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
script 'Zsh'      'z'  'respawn-pane-with.zsh zsh'
script 'Nushell'  'n'  'respawn-pane-with.zsh nu'
script 'Neovim'   'v'  'respawn-pane-with.zsh nvim'
script '...'      '?'  'respawn-pane-with-ap-t.zsh'

nl
tint='yellow'
sep1 'OTHER PANE'
item   'Right'    'l'  "respawn-pane -k -t '{right-of}'"
item   'Left'     'h'  "respawn-pane -k -t '{left-of}'"
item   'Up'       'u'  "respawn-pane -k -t '{up-of}'"
item   'Down'     'd'  "respawn-pane -k -t '{down-of}'"
item   'On...'    '/'  "display-panes 'respawn-pane -k -t %%'"

tmux display-menu -x P -y P -T '   RESPAWN ' -- "${(@)menu}"
