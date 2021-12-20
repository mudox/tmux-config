#!/usr/bin/env zsh
set -euo pipefail

# 
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

typeset create

usage() {
cat <<END
Create tmux session for Python project, create project if requested.

Usage: $(basename $0) [-c] {session-name} {path_or_name}

Flags:
  -c: create new project if not exists.
END
}

# Parse flag 〈

zparseopts -D -E c=create

# 〉

# Parse positional arguments 〈

if [[ $# -ne 2 ]]; then
  jack error 'Invalid number of arguments'
  usage
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

if [[ ! -d ${root_dir} ]]; then
  if [[ -n $create ]]; then
    jack info 'Create project'

    # project
    poetry new --src "${root_dir}"
    cd "${root_dir}"

    # git repo
    git init
    gi python >>"${root_dir}/.gitignore"

    # ap actions
    template_dir="${MDX_TMUX_DIR}/sessions/templates/python-project"
    cp -r ${template_dir}/.ap-actions "${root_dir}"
  else
    jack error "Invalid path: ${root_dir}"
    exit 1
  fi
fi

# 〉

# Creat tmux session 〈
source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

session "${1:?need a session name}"

# Window: 'Main' 〈
() {
  local window_name='Main'
  local pane_title='Edit'
  local dir="${root_dir}"
  local cmd="nvim -c 'tabnew ${root_dir}/.ap-actions/tmux-watch.zsh' -c 'tabp'"
  window
}

# Pane: Watcher 〈
() {
  local pane_title='Watcher'
  local dir="${root_dir}"
  pane
}
# 〉

# Pane: Shell 〈
() {
  local hv='v'
  local pane_title='Shell'
  local dir="${root_dir}"
  pane
}
# 〉

# 〉

finish

# 〉

#  vim: ft=tmux-session.zsh fdm=marker fmr=〈,〉

