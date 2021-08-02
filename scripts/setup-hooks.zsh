scripts_dir="${MDX_TMUX_DIR}/scripts"

run_on() {
  tmux set-hook -g "$1" "run-shell '${scripts_dir}/$2'"
}

# show pane border if number of panes > 1
tmux set-hook -g 'after-split-window[100]' 'set-option -w pane-border-status top'
# hide pane border if there is only 1 pane in a window
run_on 'after-kill-pane[100]' 'hide-pane-border.zsh'

# display pane tip on window changed
run_on 'client-session-changed[100]' 'display-pane-tip.zsh'
run_on 'session-window-changed[100]' 'display-pane-tip.zsh'
