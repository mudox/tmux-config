#!/usr/bin/env zsh
set -euo pipefail

usage() {
cat <<\END
Create tmux session for the Web project, create the project if requested.

Usage: $(basename $0) session_title project_name_or_path

Positional arguments:
  $1 title of the session
  $2 full path of the project or folder name under `$MDX_DEV_DIR/Rust`

Example:
  wbp -c Grid grid
  wbp Try-Web try-web
END
}

# Parse flags 〈
typeset create
zparseopts -D -E c=create
# 〉

# Parse positional arguments 〈
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
  prefix="${MDX_DEV_DIR:-${HOME}/Develop}/Web"
  if [[ ! -d $prefix ]]; then
    mkdir -pv "$prefix"
  fi
  root_dir="${prefix}/$2"
fi
# 〉

# Create project if requested 〈
if [[ ! -d ${root_dir} ]]; then
  if [[ -n $create ]]; then
    jack info 'Create project'

    # create project
    mkdir -p "${root_dir}"
    cd "${root_dir}"

    # copy template files
    template_dir="${MDX_TMUX_DIR}/sessions/templates/web-project"
    cp -a "${template_dir}"/* "${root_dir}"

    # ap actions
    mv "${root_dir}/ap-actions" "${root_dir}/.ap-actions"

    # git repo
    gi web >> .gitignore

  else
    jack error "Invalid path: ${root_dir}, specifying `-b | -l` to create project"
    exit 1
  fi
else
  if [[ -n $create ]]; then
    jack error "Path ${root_dir} already exists, skipping creation"
    exit 1
  fi
fi

# 〉

# Create tmux session 〈
source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

session "$1"

# Window: "Main" 〈
() {
  local window_name="Main"
  local pane_title=' Edit'
  local dir="${root_dir}"
  local cmd="nvim ${root_dir}/index.css ${root_dir}/index.html"
  window
}

# Pane: Watcher 〈
() {
  local pane_title='  Watch'
  local dir="${root_dir}"
  local cmd=".ap-actions/default-watch-action.zsh"
  pane
}
# 〉

# Pane: Shell 〈
() {
  local hv='v'
  local pane_title='  Watch'
  local dir="${root_dir}"
  pane
}
# 〉

# 〉

finish

# 〉

#  vim: fdm=marker fmr=〈,〉
