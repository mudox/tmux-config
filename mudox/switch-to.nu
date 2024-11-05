#!/usr/bin/env nu

use lib/ has-session
use lib/icon.nu [iprefix, istrip]

# `target` may have icon or not
def main [target: string] {
  let components = $target | split row ':'
  let session = $components.0
  let isession = iprefix session $session
  let iwindow = if $components.1? != null { (iprefix window $components.1) }
  let itarget = if $iwindow != null {
    $isession + ':' + $iwindow
  } else {
    $isession
  }
  # print -e $isession $iwindow $itarget

  let exists = (has-session $isession)
  
  if not $exists {
    let session_file = $'($env.MDX_TMUX_DIR)/sessions/($session).tmux-session.nu'
    # print $'create session: ($session_file)'
    run-external $session_file
    tmux switch-client -t $itarget
    # tmux set-option -t $session '@mdx-session-file' $session_file
  } else {
    # print $'create session: ($session_file)'
    if ':' in $itarget {
      tmux switch-client -t $itarget
    } else {
      tmux switch-client -t ($itarget + ':1')
    }
  }
}
