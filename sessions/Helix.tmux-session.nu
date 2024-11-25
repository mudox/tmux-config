#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = ('~/.dotfiles/helix' | path expand)

new Helix
| window Edit hx --dir $dir
| end
