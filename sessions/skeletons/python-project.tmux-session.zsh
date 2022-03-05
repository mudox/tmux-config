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
  # equivalent to `pyp Project-Name project-name`
	pyp Project-Name 

  # create the project
  pyp -c Project-Name project-name

  # create session for existing project
  pyp Project-Name project-name
END
}

# Parse flag 〈
typeset create
zparseopts -D -E c=create
# 〉

# Parse positional arguments 〈

if (( $# < 1 )); then
  jack error 'Invalid number of arguments'
  usage
  exit 1
fi

root_dir="${2:-${1:l}}"

# $root_dir
if [[ ! -d $root_dir ]]; then
  prefix="${MDX_DEV_DIR:-${HOME}/Develop}/Python"
	
  if [[ ! -d $prefix ]]; then
    mkdir -pv "$prefix"
  fi
  root_dir="${prefix}/${root_dir}"
fi

# 〉

# Create project if requested 〈

if [[ ! -d ${root_dir} ]]; then
  if [[ -n $create ]]; then
    jack info 'Create project'

    # project
		cd "${MDX_DEV_DIR}" # NOTE: $pwd must be parent of $root_dir or poetry will panic
    poetry new --src "${root_dir}"
    cd "${root_dir}"

		# main.py
		package_name="${$(basename ${root_dir})//-/_}"
		main_file="${root_dir}/src/${package_name}/main.py"
		print -- "print('Hello \"${package_name}\"')" > "${main_file}"

    # git repo
    git init
    gi python >>"${root_dir}/.gitignore"

    template_dir="${MDX_TMUX_DIR}/sessions/skeletons/python-project"

    # ap actions
    mkdir "${root_dir}/.ap-actions"
    for skeleton in "${template_dir}"/ap-actions/*; do
      package_name="${package_name}" \
				envsubst \
				< "${skeleton}" \
				> "${root_dir}/.ap-actions/$(basename ${skeleton})"
    done
    chmod +x "${root_dir}"/.ap-actions/*.zsh
  else
    jack error "Directory not exists: ${root_dir}"
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
  local pane_title='  Edit'
  local dir="${root_dir}"
  local cmd="nvim"
  window
}

# Pane: Watcher 〈
() {
  local pane_title='  Watch'
  local dir="${root_dir}"
  local cmd="${root_dir}/.ap-actions/default-watch-action.zsh"
  pane
}
# 〉

# Pane: Shell 〈
() {
  local hv='v'
  local pane_title='  Shell'
  local dir="${root_dir}"
  pane
}
# 〉

# 〉

finish

# 〉

#  vim: fdm=marker fmr=〈,〉

