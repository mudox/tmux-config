#!/usr/bin/env nu

use ../mudox/lib/session.nu *

let dir = ('~/Develop/rust/leetcode' | path expand)

new LeetCode
| window Main 'nvim leetcode' -d $dir 
| end
