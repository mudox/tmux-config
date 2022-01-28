#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

set-title() {
  : ${1:?}

	local label=$(get_pane_label "$1")

  if [[ $label != '' ]]; then
    return
  fi

	local cmd=$(get_pane_command "$1")

  case $cmd in
  *zsh*)
    suffix='  Shell'
    ;;
  *nvim*)
    suffix='  Edit'
    ;;
  *)
    suffix="  ${cmd}"
    ;;
  esac

	set_pane_label_suffix "$1" "${suffix}"
}

for id in $(tmux list-panes -a -F '#D'); do
  set-title "${id}"
done
