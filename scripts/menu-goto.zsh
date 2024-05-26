#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"
source "${MDX_TMUX_DIR}/scripts/lib/menu.zsh"

window() {
	shell "$1" "$2" "${scripts_dir}/switch-session.zsh $3"
}

tint=green
sep1 'CONFIG'
window    Neovim         v    'Neovim'
window    Dotfiles       d    'Dotfiles'
window    Tmux           t    'Tmux'
window    Hammerspoon    h    'Hammerspoon'

nl
tint=blue
sep1 'NOTE'
window    Note           n    'Note'

nl
tint=red
sep1 'MONITOR'
window    BTop           X    'Default:Top'
popup     Htop           x    'htop --user mudox'

nl
tint=yellow
sep1 'POPUP'
popup     Ap             a    "${HOME}/.bin/ap"
popup     LuaPad         l    "nvim +Luapad '+wincmd o'"

nl
tint=magenta
sep1 'GIT'
popup     GitUI          g    '/opt/homebrew/bin/gitui'
popup     LazyGit        z    '/opt/homebrew/bin/lazygit'
shell     GitTower       G    '/usr/local/bin/gittower .'

nl
tint=grey
sep1 'DSA'
window    DA-Python      1    DA-Python
window    DA-Swift       2    DA-Swift
window    DA-Rust        3    DA-Rust
window    DA-JavaScript  4    DA-JavaScript

tmux display-menu -T '   GOTO ' -- "${(@)menu}"
