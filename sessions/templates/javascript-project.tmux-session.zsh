#!/usr/bin/env zsh
set -euo pipefail

usage() {
cat <<END
Create tmux session for the javascript project, create the project if requested.

Usage: $(basename $0) [-c] session_title project_name_or_path

Flags:
  -c create the project

Arguments:
  $1 name of the session
  $2 full path of the project or folder name under `$MDX_DEV_DIR/JavaScript`

Examples:
  jsp -c Try-JavaScript try-javascript
  jsp DA-JavaScript da-javascript
END
}

# Parse flags 〈
typeset create
zparseopts -D -E c=create
# 〉

# Parse positional arguments  〈
if [[ $# -ne 2 ]]; then 
  jack error "Invalid number of positional arguments"
  usage
  exit 1
fi

# $root_dir
typeset root_dir
if [[ -d $2 ]]; then
  root_dir="$2"
else
  prefix="${MDX_DEV_DIR:-${HOME}/Develop}/JavaScript"
  if [[ ! -d $prefix ]]; then
    mkdir -pv "$prefix"
  fi
  root_dir="${prefix}/$2"
fi
# 〉

# Create project if requested  〈
if [[ ! -d ${root_dir} ]]; then
  if [[ -n ${create} ]]; then
    jack info 'Create project'

    # create project
    mkdir -p "${root_dir}" && cd "${root_dir}"
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
  else
    jack error "Invalid path: ${root_dir}"
    exit 1
  fi
else
  if [[ -n ${create} ]]; then
    jack error "Path ${root_dir} already exists, skipping creation"
    exit 1
  fi
fi
# 〉

# Creat tmux session  〈
source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

session "$1"

# Window: "Main" 〈
() {
  local window_name="Main"
  local pane_title=' Edit'
  local dir="${root_dir}"
  local cmd="nvim ${root_dir}/src/index.js"
  window
}

# Pane: 'Watcher' 〈
() {
  local pane_title='  Watch'
  local dir="${root_dir}"
  local cmd="nodemon --quiet --exec ${root_dir}/.ap-actions/tmux-watch.zsh"
  pane
}
# 〉

# Pane: 'Shell' 〈
() {
  local hv=v
  local pane_title='  Shell'
  local dir="${root_dir}"
  pane
}
# 〉

# 〉

finish

# 〉

# vim: ft=tmux-session.zsh fdm=marker fmr=〈,〉
