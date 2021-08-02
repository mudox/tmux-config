#!/usr/bin/env zsh

is_pane_dead() {
  tmux display -p '#{pane_dead}'
}

menu_id=$(tmux show-options -p -v '@respawn-menu-id')

menu_bin=${MDX_TMUX_DIR}/scripts/show-watch-pane-respawn-menu.sh

if [[ -z $menu_id ]]; then
  tmux respawn-pane -k
else
  tmux run-shell "$menu_bin $menu_id"
fi
