#!/usr/bin/env zsh
set -euo pipefail

scripts_dir="${MDX_TMUX_DIR}/scripts"
hooks_dir="${scripts_dir}/hooks"

hook() {
  tmux set-hook -g "$1[100]" "run-shell '${hooks_dir}/$1.zsh'"
}

hook 'client-session-changed'
hook 'session-window-changed'
hook 'after-split-window'
hook 'after-kill-pane'
