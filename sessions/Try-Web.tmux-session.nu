#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = ('~/Develop/Web/try-web/' | path expand)

new Try-Web
| edit-window --dir $dir
| end
