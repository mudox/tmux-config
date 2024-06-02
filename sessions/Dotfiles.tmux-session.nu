#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = ('~/.dotfiles' | path expand)

new Dotfiles
| window Main    nvim -d $dir
| window Nushell nu
| pane  h       nvim
| end 
