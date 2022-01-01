#!/usr/bin/env zsh
set -euo pipefail

usage() {
cat <<\END
Create tmux session for Python project, create project if requested.

Usage: $(basename $0) [-c] session_title project_name_or_path

Flags:
  -c: create new project if not exists.

Positional arguments:
  $1 name of the session
  $2 full path of the project or folder name under `$MDX_DEV_DIR/Python`

Example:
  pyp -c DA-Python da-python
  pyp Try-Python try-python
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

# 〉

# Create project if requested 〈

if [[ ! -d ${root_dir} ]]; then
  if [[ -n $create ]]; then
    jack info 'Create project'

    # project
    poetry new --src "${root_dir}"
    cd "${root_dir}"

    touch "src/$(basename ${root_dir//-/_})/main.py"

    # git repo
    git init
    gi python >>"${root_dir}/.gitignore"

    template_dir="${MDX_TMUX_DIR}/sessions/templates/python-project"
    project_name="${$(basename "${root_dir}")//-/_}"

    # ap actions
    mkdir "${root_dir}/.ap-actions"
    for temp in "${template_dir}"/ap-actions/*; do
      project_name="${project_name}" envsubst < "${temp}" > "${root_dir}/.ap-actions/$(basename ${temp})"
    done
    chmod +x "${root_dir}/.ap-actions/tmux-watch.zsh"
  else
    jack error "Invalid path: ${root_dir}"
    exit 1
  fi
else
  if [[ -n $create ]]; then
    jack error "Path ${root_dir} already exists, skipping creation"
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
  local cmd="nvim"
  window
}

# Pane: Watcher 〈
() {
  local pane_title='Watcher'
  local dir="${root_dir}"
  local cmd="nodemon --quiet --ext py --exec ${root_dir}/.ap-actions/tmux-watch.zsh"
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

