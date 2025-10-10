#!/usr/bin/env nu

use lib/ has-session

# `target` may have icon or not
def main [target: string] {
  let components = $target | split row ':'
  let session = $components.0
  let window = if $components.1? != null { $components.1 }
  let target = if $window != null {
    $session + ':' + $window
  } else {
    $session
  }

  let exists = (has-session $session)

  if not $exists {
    let session_file = $'($env.MDX_TMUX_DIR)/sessions/($session).tmux-session.nu'
    # print $'create session: ($session_file)'
    run-external $session_file
    tmux switch-client -t $target
    # tmux set-option -t $session '@mdx-session-file' $session_file
  } else {
    # print $'create session: ($session_file)'
    if ':' in $target {
      tmux switch-client -t $target
    } else {
      tmux switch-client -t ($target + ':1')
    }
  }
}
