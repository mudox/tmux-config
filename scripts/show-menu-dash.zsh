#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"
source "${MDX_TMUX_DIR}/scripts/lib/menu.zsh"

window() {
	shell "$1" "$2" "${scripts_dir}/switch-session.zsh $3"
}

tint='green'
sep1 'Config'
window    Neovim         v    'Neovim'
window    Dotfiles       d    'Dotfiles'
window    Tmux           t    'Tmux'
window    Hammerspoon    h    'Hammerspoon'

nl
tint=blue
sep1 'Note'
window    Note           e    'Neorg:1'
window    Journal        o    'Neorg:Journal'


nl
tint=brown
sep1 'Monitor'
window    BTop           X    'Default:Top'
popup     Htop           x    'htop --user mudox'

nl
tint=yellow
sep1 'Popup'
popup     Ap             a    "${HOME}/.bin/ap"
popup     GitUI          g    '/opt/homebrew/bin/gitui'

nl
tint=colour17
sep1 'DSA'
window    DA-Python      1    DA-Python
window    DA-Swift       2    DA-Swift
window    DA-Rust        3    DA-Rust
window    DA-JavaScript  4    DA-JavaScript

tmux display-menu -- "${(@)menu}"
