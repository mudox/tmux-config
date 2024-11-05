#!/usr/bin/env nu

use lib/ session-name
use lib/icon.nu istrip

let session = (session-name) | istrip
let themes_dir = $'($env.MDX_TMUX_DIR)/scripts/session-themes'

mut path = $'($themes_dir)/($session)'
print $path
if not ($path | path exists) {
  $path = $'($themes_dir)/Home'
} 

print $path
tmux source-file $path
