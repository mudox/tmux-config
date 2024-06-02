#!/usr/bin/env nu

use lib has-session

def main [target: string] {
  let session = $target | str replace ':.*$' ''
  let exists = (has-session $session)

  if not $exists {
    let session_file = $'($env.MDX_TMUX_DIR)/sessions/($session).tmux-session.nu'
    run-external $session_file
    tmux switch-client -t $target
    # tmux set-option -t $session '@mdx-session-file' $session_file
  } else {
    if ':' in $target {
      tmux switch-client -t $target
    } else {
      tmux switch-client -t ($target + ':1')
    }
  }
}
