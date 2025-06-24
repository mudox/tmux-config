#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let rootdir = ('~/Develop/CangJie/try-cangjie' | path expand)

new Try-CangJie
| window Main 'nvim src/main.cj' -d $rootdir
| end

tmux split-pane -t Try-CangJie:1 -dh -c $rootdir -- watchexec -e cj -r -c -q -- cjpm run
