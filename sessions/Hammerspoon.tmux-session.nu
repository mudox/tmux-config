#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = ('~/Git/hs-config' | path expand)

new Hammerspoon
| edit-window --dir $dir
| end
