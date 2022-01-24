scripts_dir="${MDX_TMUX_DIR}/scripts"

hook() {
  tmux set-hook -g "$1" "run-shell '${scripts_dir}/$2'"
}

# show pane border if number of panes > 1
tmux set-hook -g 'after-split-window[100]' 'set-option -w pane-border-status top'
# hide pane border if there is only 1 pane in a window
hook 'after-kill-pane[100]' 'hide-pane-border.zsh'

# display pane tip on window changed
hook 'client-session-changed[200]' 'display-session-tip.zsh'
hook 'client-session-changed[210]' 'display-pane-tip.zsh'
hook 'session-window-changed[100]' 'display-pane-tip.zsh'

# load session specific settings
# NOTE: small index load first
hook 'client-session-changed[100]' 'load-session-config.zsh'
