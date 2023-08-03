#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

hook() {
  tmux set-hook -g "$1[100]" "run-shell '${hooks_dir}/$1.zsh'"
}

hook 'client-session-changed'
# hook 'session-window-changed'
hook 'after-split-window'
hook 'after-kill-pane'
hook 'after-resize-pane'
hook 'pane-focus-in'
