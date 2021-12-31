#!/usr/bin/env zsh
set -euo pipefail

# Create tmux session for the javascript project, create the project if requested.
#
# Example:
#   jsp -b DA-JavaScript da-javascript

typeset create
typeset root_dir

usage() {
cat <<END
Usage: $(basename $0) {session-name} {name-or-path}

Positional arguments:
  $1 name of the session
  $2 full path of the project or folder name under `~/Develop/JavaScript`
END
}

# Parse flags 〈
zparseopts -D -E l=create b=create

# $create
if [[ $create = '-l' ]]; then
  create='--lib'
elif [[ $create = '-b' ]]; then
  create='--bin'
fi

# 〉

# Parse positional arguments  〈

if [[ $# -ne 2 ]]; then 
  jack error "Invalid number of positional arguments"
  usage
  exit 1
fi

# ${root_dir}
if [[ -d $2 ]]; then
  root_dir="$2"
else
  root_dir="${HOME}/Develop/JavaScript/$2"
fi

# 〉

# Create project if requested  〈
if [[ ! -d ${root_dir} ]]; then
  jack info 'Create project'

  # create project
  mkdir "${root_dir}" && cd "${root_dir}"
  npm init -y
  sd 'index.js' 'src/index.js' "${root_dir}/package.json"

  # skeleton files
  mkdir 'src' 'test'
  touch "${root_dir}/src/index.js"
  touch "${root_dir}/test/test.js"

  skeleton_dir="${MDX_TMUX_DIR}/sessions/templates/javascript-project"
  
  # ap actions
  cp -r "${skeleton_dir}/ap-actions" "${root_dir}/.ap-actions"

  # git repo
  git init
  gi node >> "${root_dir}/.gitignore"
fi

# 〉

# Creat tmux session  〈
source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

session "$1"

# Window: "Main" 〈
() {
  local window_name="Main"
  local pane_title='Edit'
  local dir="${root_dir}"
  local cmd="nvim ${root_dir}/src/index.js"
  window
}

# Pane: 'Watcher' 〈
() {
  local pane_title='Watcher'
  local dir="${root_dir}"
  local cmd="nodemon --quiet --exec ${root_dir}/.ap-actions/tmux-watch.zsh"
  pane
}
# 〉

# Pane: 'Shell' 〈
() {
  local hv=v
  local window_name='Shell'
  local pane_title='Shell'
  local dir="${root_dir}"
  pane
}
# 〉

# 〉

finish

# 〉

# vim: ft=tmux-session.zsh fdm=marker fmr=〈,〉
