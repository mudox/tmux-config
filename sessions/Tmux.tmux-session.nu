#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = $env.MDX_TMUX_DIR

new Tmux
| edit-window --dir $dir
| window --dir $dir Help 'man tmux'
| end
