export def tmux-query [--target(-t): string = '.' format: string] {
  tmux display-message -p -t $target $format
}

export def has-session [session: string] {
  (tmux has-session -t ('=' + $session) | complete).exit_code == 0
}

export def session-name [target: string = '.'] {
  tmux-query -t $target '#{session_name}'
}

export def pane-command [target: string = '.'] {
  tmux-query -t $target '#{pane_current_command}'
}

export def pane-label [target: string = '.'] {
  tmux show-options -pv -t $target pane-border-format
}

export def window-panes [] {
  tmux-query '#{window_panes}' | into int
}

export def zoomed [] {
  (tmux-query '#{window_zoomed_flag}') == '1'
}
