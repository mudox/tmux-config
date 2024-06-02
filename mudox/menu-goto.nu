#!/usr/bin/env nu

use lib/menu.nu *

new '   GOTO ' 
# CONFIG
| tint green
| powerline CONFIG
| goto      Neovim         v    Neovim
| goto      Dotfiles       d    Dotfiles
| goto      Tmux           t    Tmux
| goto      Hammerspoon    h    Hammerspoon
# NOTE
# | nl
# | tint=blue
# | powerline NOTE
# | goto      Note           n    Note
# MONITOR
| nl
| tint red
| powerline MONITOR
| goto      BTop           X    'Default:Top'
| popup     Htop           x    'htop --user mudox'
# POPUP
| nl
| tint yellow
| powerline POPUP
| popup     Ap             a    $'($env.HOME)/.bin/ap'
| popup     LuaPad         l    "nvim +Luapad '+wincmd o'"
# GIT
| nl
| tint magenta
| powerline GIT
| popup     GitUI          g    '/opt/homebrew/bin/gitui'
| popup     LazyGit        z    '/opt/homebrew/bin/lazygit'
| run       GitTower       G    '/usr/local/bin/gittower .'
# DSA
| nl
| tint grey
| powerline DSA
| goto      DA-Python      1    DA-Python
| goto      DA-Swift       2    DA-Swift
| goto      DA-Rust        3    DA-Rust
| goto      DA-JavaScript  4    DA-JavaScript
| show
