#!/usr/bin/env nu

use lib/key-table.nu *

new goto M-y
# menu
| run             '-'         'Display goto menu'      --my 'menu-goto.nu'
# main
| switch-to       y           'Default:Main'
| switch-to       Enter       'Default:Main'
# config
| switch-to       v           Neovim
| switch-to       Space       Neovim
| switch-to       d           Dotfiles
| switch-to       t           Tmux
| switch-to       h           Hammerspoon
# monitor
| switch-to       X           'Default:Top'
# popup
| popup           a           Ap                            ap
| popup           x           HTop                          'htop --user mudox'
| popup           z           LazyGit                       lazygit
| popup           g           GitUI                         gitui
# session navigation
| item            '/'         'Goto last session'           'switch-client -l'
| item            '['         'Goto previous session'       'switch-client -p'
| item            ']'         'Goto next session'           'switch-client -n'
| commit
