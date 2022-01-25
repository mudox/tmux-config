#!/usr/bin/env zsh
set -euo pipefail

name='respawn'
tmux bind-key 'r' switch-client -T "$name"

bind() {
  tmux bind-key -T "$name" "$@"
}

# respawn with current command
bind 'r' respawn-pane -k

# respawn current pane with `ap` actions list
bind '?' respawn-pane -k 'ap -t'

# respawn current pane with `zsh`
bind 'z' respawn-pane -k 'zsh'

# respawn current pane with `neovim`
bind 'v' respawn-pane -k 'nvim'
