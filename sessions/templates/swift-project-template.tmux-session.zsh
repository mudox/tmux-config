#!/usr/bin/env zsh

# option -l: create lib project
# option -b: create binary execution project
# $1: session name
# $2: project path or name (under ~/Develop/Swift)
# $3: one of [b|r|t]

set -euo pipefail

source ~/.dotfiles/scripts/lib/jack.zsh

#
# parse options
#

zparseopts -D -E l=lib b=bin
if [[ -n $lib ]]; then
  create='library'
elif [[ -n $bin ]]; then
  create='executable'
fi

#
# parse positional arguments
#

if [[ $# -ne 3 || ! $3 =~ [brt] ]]; then
  echo "Usage: $0 {SESSION_NAME} {ROOT_DIR} {ACTION}"
  exit 1
fi

typeset -A titles
titles=(
  b 'Watch + Build'
  r 'Watch + Run'
  t 'Watch + Test'
)

#
# create project if requested
#

if [[ -d $2 ]]; then
  root="$2"
else
  root="${HOME}/Develop/Swift/$2"
fi

if [[ ! -d $root ]]; then
  set +u
  if [[ -n $create ]]; then
    jackInfo 'Create project ...'

    mkdir -p "$root"
    cd "$root"
    swift package init --type "$create"
    gi >> .gitignore

    echo ''
  else
    jackError "Invalid path: $root"
    exit 1
  fi
  set -u
fi

#
# creat tmux session
#

jackInfo "Craete tmux session [$1]"

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup "$1"

# Editor
new_session Main "${root}" nvim
title_pane 1 'Edit'

# Watcher
tmux split-window \
  -t "${window}.1" \
  -h \
  -c "${root}" \
  -d -- \
  swift-watch "$3"
title_pane 2 "${titles[$3]}"
tmux set-option -p -t "${window}.2" "@respawn-menu-id" swift

# Shell
tmux split-window \
  -t "${window}.2" \
  -v \
  -c "${root}" \
  -d
title_pane 3 'Console'

clean_up
