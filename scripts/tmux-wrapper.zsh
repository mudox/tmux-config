#!/usr/bin/env zsh

# Tmux binary
cmd=("/opt/homebrew/bin/tmux")

# Determine server
if [[ -n $KITTY_WINDOW_ID ]]; then
	server=kitty
elif [[ -n $ALACRITTY_WINDOW_ID ]]; then
	server=alacritty
elif [[ -n $WEZTERM_PANE ]]; then
	server=wezterm
elif [[ $TERM_PROGRAM = vscode ]]; then
	server=vscode
elif [[ -n $ITERM_SESSION_ID ]]; then
	server=iterm
else
	server=default
fi
cmd+=(-L $server)

if (($# > 0)); then
	if [[ $1 = which-server ]]; then
		echo "$server"
	else
		exec $cmd $@
	fi
else
	# source "${MDX_GIT_DIR}/base16-shell/profile_helper.sh"
	exec $cmd attach &>/dev/null
fi
