#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

menu=()

item() {
	menu+=("$1" "$2" "$3")
}

shell-item() {
  item "$1" "$2" "run-shell '$3'"
}

script-item() { 
	shell-item "$1" "$2" "${scripts_dir}/$3"
}

sep() {
	menu+=("-#[align=centre]- $1 -" '-' '-')
}

# sep 'Popup'

script-item 'Respawn' 'r' 'respawn-pane.zsh'
item        'Query'   'q' "display-panes 'respawn-pane -k -t %%'"
script-item 'Choose'  '?' 'respawn-pane-with-ap-t.zsh'
script-item 'Zsh'     'z' 'respawn-pane-with-zsh.zsh'
script-item 'Neovim'  'v' 'respawn-pane-with-neovim.zsh'

tmux display-menu -xP -yP -- "${(@)menu}"
