#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

theme_path="${session_themes_dir}/$(get_session_name)"

if [[ -f $theme_path ]]; then
  tmux source-file "${theme_path}"
else
  tmux source-file "${session_themes_dir}/Default"
fi
