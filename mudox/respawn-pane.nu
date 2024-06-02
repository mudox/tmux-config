#!/usr/bin/env nu

use update-pane-border.nu

export def main [cmd?: string --target(-t): string = '.'] {
  tmux clear-history -t $target
  if $cmd != null {
    tmux respawn-pane -k -t $target $cmd
  } else {
    tmux respawn-pane -k -t $target
  }
  update-pane-border
}
