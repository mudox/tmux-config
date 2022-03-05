#!/usr/bin/env zsh
set -euo pipefail

tmux clear-history
tmux respawn-pane -k
