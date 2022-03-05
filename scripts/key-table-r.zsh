#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

name='respawn'
tmux bind-key 'r' switch-client -T "$name"

bind() {
  tmux bind-key -T "$name" "$@"
}

# respawn with current command
bind 'r' run-shell "${MDX_TMUX_DIR}/scripts/respawn-pane.zsh"

# respawn current pane with `ap` actions list
bind '?' respawn-pane -k "${scripts_dir}/respawn-pane-with-ap-t.zsh"

# respawn current pane with `zsh`
bind 'z' respawn-pane -k "${scripts_dir}/respawn-pane-with-zsh.zsh"

# respawn current pane with `neovim`
bind 'v' respawn-pane -k "${scripts_dir}/respawn-pane-with-neovim.zsh"
