#!/usr/bin/env zsh
set -euo pipefail

# Create tmux session for Swift project, create the project if requested
#
# Example:
#   swp -b Try-Swift try-swift

# Parse flags 〈

zparseopts -D -E l=lib b=bin
create=""
if [[ -n $lib ]]; then
  create='library'
elif [[ -n $bin ]]; then
  create='executable'
fi

# 〉

# Parse positional arguments 〈

if [[ $# -ne 2 ]]; then
  jack error 'Invalid number of arguments'

  print -- "\
  Usage: $(basename $0) [-b | -l] session-name path_or_name

  Flags:
    -b: create executable project
    -l: create library project
  "
  exit 1
fi

# 〉

# Create project if requested 〈

if [[ -d $2 ]]; then
  root_dir="$2"
else
  root_dir="${HOME}/Develop/Swift/$2"
fi

if [[ ! -d ${root_dir} ]]; then
  if [[ -n $create ]]; then
    jack info 'Create project'

    # create project
    mkdir -p "${root_dir}"
    cd "${root_dir}"
    swift package init --type "$create"

    # git repo
    gi swift >> .gitignore

    template_dir="${MDX_TMUX_DIR}/sessions/templates/swift-project"

    # ap actions
    cp -vr ${template_dir}/ap-actions "${root_dir}/.ap-actions"
  else
    jack error "Invalid path: ${root_dir}, specifying `-b | -l` to create project"
    exit 1
  fi
else
  jack error "Path ${root_dir} already exists, skipping creation"
  exit 1
fi

# 〉

# Create tmux session 〈
source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

session "$1"

# Window: "Main" 〈
() {
  local window_name="Main"
  local pane_title="Edit"
  local dir="${root_dir}"
  local cmd="nvim ${root_dir}/package.swift"
  window
}

# Pane: Watcher 〈
() {
  local pane_title='Watcher'
  local dir="${root_dir}"
  local cmd="nodemon --quiet --ext swift --exec ${root_dir}/.ap-actions/tmux-watch.zsh"
  pane
}
# 〉

# Pane: Shell 〈
() {
  local hv='v'
  local pane_title='Watcher'
  local dir="${root_dir}"
  pane
}
# 〉

# 〉

finish

# 〉

#  vim: ft=tmux-session.zsh fdm=marker fmr=〈,〉
