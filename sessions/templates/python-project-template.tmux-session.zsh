#!/usr/bin/env zsh
set -euo pipefail

# flags:
#   -c: create new project if not exists
#
# positional arguments:
#   $1: tmux session name, usually capitalized
#   $2: project path or name (under ~/Develop/Python), usually fully lowercase
#
# example:
#   pyp DA-Python da-python

# parse flag 〈

zparseopts -D -E c=create

# 〉

# parse positional arguments 〈

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 SESSION_NAME ROOT_DIR_OR_NAME"
  exit 1
fi

if [[ -d $2 ]]; then
  root_dir="$2"
else
  root_dir="${HOME}/Develop/Python/$2"
fi
project_name=$(basename $root_dir)

# 〉

# create project if requested 〈

if [[ ! -d $root_dir ]]; then
  set +u
  if [[ -n $create ]]; then
    jack info 'Create project ...'

    poetry new "$root_dir"
    cd "$root_dir"

    git init
    gi python >> "${root_dir}/.gitignore"
  else
    jack error "Invalid path: $root_dir"
    exit 1
  fi
  set -u
fi

# 〉

# creat tmux session 〈

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

jack info "Create tmux session [$1]"

setup "$1"

# Editor
new_session Main "${root_dir}" nvim
title_pane 1 Edit

# Watcher
tmux split-window \
  -t "${window}.1" \
  -h \
  -c "${root_dir}" \
  -d -- \
  zsh # todo
  
title_pane 2 'Watch + Test'
tmux set-option -p -t "${window}.2" "@respawn-menu-id" python

# Shell
tmux split-window \
  -t "${window}.2" \
  -v \
  -c "${root_dir}" \
  -d
title_pane 3 Shell

# Window: Git

clean_up

# 〉

# vim: fdm=marker fmr=〈,〉
