#!/usr/bin/env nu

# update pane border
run-external $'($env.MDX_TMUX_DIR)/mudox/update-pane-border.nu'

# reveal pane border 
tmux set-option -w pane-border-status top
