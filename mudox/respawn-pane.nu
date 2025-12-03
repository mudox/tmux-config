#!/usr/bin/env nu

use update-pane-border.nu

export def main [cmd?: string --target(-t): string = '.' --focus] {
  tmux clear-history -t $target
  if $cmd != null {
    tmux respawn-pane -k -t $target $cmd
  } else {
    tmux respawn-pane -k -t $target
  }

  if $focus {
    tmux select-pane -t $target
  }
}
