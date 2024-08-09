#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = ('~/Develop/Try/nushell' | path expand)

new Try-Nushell
| window Main -d $dir $'nvim ([$dir inbox.nu] | path join)'
| end 

