#!/usr/bin/env zsh
set -euo pipefail

mid='comma'
tmux bind-key ',' switch-client -T "$mid"

bind() {
  tmux bind-key -T "$mid" "$@"
}

# respawn current pane with `ap` actions list
bind 'r' respawn-pane -k 'ap -t'

# respawn current pane with `zsh`
bind 't' respawn-pane -k 'zsh'

# respawn current pane with `neovim`
bind 'v' respawn-pane -k 'nvim'
