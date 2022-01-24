#!/usr/bin/env zsh
set -euo pipefail

mid='eight'
tmux bind-key 8 switch-client -T "$mid"

# respawn current pane with `zsh`
tmux bind-key -T"$mid" z respawn-pane -k zsh

