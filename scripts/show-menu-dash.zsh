#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"
source "${MDX_TMUX_DIR}/scripts/lib/menu.zsh"

window() {
	shell "$1" "$2" "${scripts_dir}/switch-session.zsh $3"
}

sep       ' '
window    Neovim         v    'Neovim'
window    Dotfiles       d    'Dotfiles'
window    Tmux           t    'Tmux'
window    Hammerspoon    h    'Hammerspoon'

nl
sep       ' '
window    Note           e    'Neorg:1'
window    Journal        j    'Neorg:Journal'


nl
sep       ' '
window    BTop           X    'Default:Top'
popup     Htop           x    'htop --user mudox'

nl
sep       ' '
popup     Ap             a    "${HOME}/.bin/ap"
popup     GitUI          g    '/opt/homebrew/bin/gitui'

tmux display-menu -- "${(@)menu}"
