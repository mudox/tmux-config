#!/usr/bin/env nu

use lib/menu.nu *

def main [--current] {
  new '   RESPAWN ' 
  | if not $current {
    # CURRENT
    $in
    | nl
    | tint green
    | run       Pane    '%' --my 'respawn-pane.nu'
    | run       Window  '@' --my 'respawn-window.nu'
    | nl
    | tint red
    | powerline 'CURRENT PANE'
  } else { $in }
  # CURRENT PANE
  | run       Zsh     z   --my 'respawn-pane.nu zsh'
  | run       Nushell n   --my 'respawn-pane.nu nu'
  | run       Neovim  v   --my 'respawn-pane.nu nvim'
  | run       'On...'   '?' --my 'respawn-pane.nu "ap t"'
  | if not $current {
    # OTHER PANE  
    $in
    | nl
    | tint yellow
    | powerline 'OTHER PANE'
    | run       Right   l   --my "respawn-pane.nu -t '.{right-of}'"
    | run       Left    h   --my "respawn-pane.nu -t '.{left-of}'"
    | run       Up      u   --my "respawn-pane.nu -t '.{up-of}'"
    | run       Down    d   --my "respawn-pane.nu -t '.{down-of}'"
    | item      'On...' '/' "display-panes 'respawn-pane -k -t %%'"
  } else { $in }
  | if $current { show --pane } else { show }
}
