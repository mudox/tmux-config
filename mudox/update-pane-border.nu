#!/usr/bin/env nu

use lib/ [tmux-query pane-command window-panes zoomed]

export def label [target: string = '.'] {
  let cmd = (pane-command $target)

  if $cmd starts-with zsh {
    '  Zsh'
  } else if $cmd starts-with 'nu' {
    '  Nushell'
  } else if $cmd =~ 'nvim' {
    '  Neovim'
  } else if $cmd == `''` {
    ' '
  } else {
    '  ' + $cmd
  }
}

export def update-border-visibility [] {
  if (zoomed) {
    tmux set-option -w status off
    tmux set-option -w pane-border-status off
  } else {
    tmux set-option -w status on
    tmux set-option -w pane-border-status (if (window-panes) == 1 { 'off' } else { 'top' })
  }
}

# usage:
# `main`                update current pane with default label
# `main 'Custom Label'` with custom label
# `main -t :`           for all panes of current window
export def main [
  label?: string 
  --target(-t): string = '.' # `:` to update for all panes of current window
] {
  update-border-visibility

  let targets = if $target == ':' {
    tmux list-panes -F '#{pane_id}' | lines
  } else {
    [ $target ]
  }

  for target in $targets {
    let label = $label | default (label $target) 
    tmux set-option -p -t $target pane-border-format $' ($label) '
  }
}
