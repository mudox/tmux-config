#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

set-title() {
  title=$(tmux display-message -t "$1" -p '#T')
  default_title=$(tmux display-message -p '#{host}')

  if [[ $title != $default_title ]]; then
    return
  fi

  cmd=$(tmux display-message -t "$1" -p '#{pane_current_command}')

  case $cmd in
  *zsh*)
    title='  Shell'
    ;;
  *nvim*)
    title='  Edit'
    ;;
  *)
    title="  ${cmd}"
    ;;
  esac

  tmux select-pane -t "$1" -T "${title}"
}

for id in $(tmux list-panes -F '#D'); do
  set-title "${id}"
done
