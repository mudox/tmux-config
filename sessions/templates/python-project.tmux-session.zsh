#!/usr/bin/env zsh
set -euo pipefail

# Create tmux session for Python project, create project if requested.
#
# Flags:
#   -c: create new project if not exists
#
# Positional arguments:
#   $1: tmux session name, usually capitalized
#   $2: project path or name (under ~/Develop/Python), usually fully lowercase
#
# Example:
#   pyp DA-Python da-python

# Parse flag 〈

create=''
zparseopts -D -E c=create

# 〉

# Parse positional arguments 〈

if [[ $# -ne 2 ]]; then
  jack error 'Invalid number of arguments'

  print -- "\
  Usage: $(basename $0) [-c] session-name name-or-path
  
  Flags:
    -c: create new project if not exists
  "

  exit 1
fi

# $root_dir
if [[ -d $2 ]]; then
  root_dir="$2"
else
  root_dir="${HOME}/Develop/Python/$2"
fi

# $project_name
project_name=$(basename $root_dir)

# 〉

# Create project if requested 〈

if [[ ! -d $root_dir ]]; then
  set +u
  if [[ -n $create ]]; then
    jack info 'Create project'

    # project
    poetry new --src "$root_dir"
    cd "$root_dir"

    # git repo
    git init
    gi python >>"${root_dir}/.gitignore"

    # ap actions
    template_dir="${MDX_TMUX_DIR}/sessions/templates/python-project"
    cp -r ${template_dir}/.ap-actions "${root_dir}"
  else
    jack error "Invalid path: $root_dir"
    exit 1
  fi
  set -u
fi

# 〉

# Creat tmux session 〈

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
  "${MDX_DOT_DIR}/zsh/scripts/python/watch.zsh"

title_pane 2 'Watch + Test'

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
