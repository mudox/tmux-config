#!/usr/bin/env nu

use update-pane-border.nu

tmux clear-history
tmux respawn-window -k
# update-pane-border
