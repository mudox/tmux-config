#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = $env.MDX_TMUX_DIR

new Tmux
| window Main nvim -d $dir 
| end
