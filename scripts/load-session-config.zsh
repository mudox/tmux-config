#!/usr/bin/env zsh
set -euo pipefail

session_name=$(tmux display-message -p '#{session_name}')

# Session theme 〈

theme_dir="${MDX_TMUX_DIR}/scripts/session-themes"
theme="${config_dir}/${session_name}"

if [[ -f "$theme" ]]; then
	tmux source-file "$theme"
else
	tmux source-file "${theme_dir}/Home"
fi

# 〉

# TODO: load session config
# config_dir="${MDX_TMUX_DIR}/scripts/session-configs"
# config="${config_dir}/${session_name}.zsh"

#  vim: fdm=marker fmr=〈,〉
