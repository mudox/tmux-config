#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

menu=()

item() {
	menu+=("$1" "$2" "$3")
}

popup-item() {
	item "$1" "$2" "display-popup -E -w70% -h80% \"$3\""
}

shell-item() {
  item "$1" "$2" "run-shell '$3'"
}

sep() { 
	# menu+=('')
	menu+=("-#[align=centre]- $1 -" '-' '-')
}

typeset -A sessions=(
  d Dotfiles
  h Hammerspoon
  v Neovim
  t Tmux
	e Neorg:1
	j Neorg:Journal
	X Default:Top
)

sep ' '

for key session in "${(@kv)sessions}"; do
	shell-item "$session" "$key" "${scripts_dir}/switch-session.zsh ${session}"
done

sep ' '

# popup-item Tip   q "${scripts_dir}/display-session-tip.zsh 3"
popup-item Ap    a ~/.bin/ap
popup-item Htop  x 'htop --user mudox'
popup-item GitUI g /opt/homebrew/bin/gitui

tmux display-menu -- "${(@)menu}"
