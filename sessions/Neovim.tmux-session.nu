#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = ('~/.config/nvim' | path expand)

new Neovim
| edit-window --dir $dir
| end
