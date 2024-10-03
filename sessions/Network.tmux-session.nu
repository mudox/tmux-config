#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = ('~/Library/Application Support/Surge/Profiles/' | path expand)

new Network
| window Surge nvim -d $dir 
| end
