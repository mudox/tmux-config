#!/usr/bin/env zsh
set -euo pipefail

# Create tmux session for the rust project, create the project is requested.
#
# Flags:
#   -l: create library project
#   -b: create binary executable project
#
# Positional arguments:
#   $1: session (project) name, usually capitalized from crate name
#   $2: project path or name (under ~/Develop/Rust), usually fully lowercase
#
# Example:
#   rsp -b tav Tav
#   rsp -l ap Ap

typeset create
typeset root_dir

usage() {
cat <<END
Usage: $(basename $0) [-b|-l] {session-name} {name-or-path}

Flags:
  -l create library project
  -b create executable project

Positional arguments:
  $1 name of the session
  $2 full path of the project or folder name under `~/Develop/Rust`
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

# $root_dir
if [[ -d $2 ]]; then
  root_dir="$2"
else
  root_dir="${HOME}/Develop/Rust/$2"
fi

# $project_name
project_name=$(basename $root_dir)

# 〉

# Create project if requested  〈
if [[ ! -d $root_dir ]]; then
  if [[ -n $create ]]; then
    jack info 'Create project'

    # create project
    cargo new "$root_dir" "$create"

    cd "$root_dir"

    # skeleton files
    skeleton_dir="${MDX_TMUX_DIR}/sessions/templates/rust-project"
    for temp in ${skeleton_dir}/*.rs; do
      temp_name="${$(basename "$temp")//-/_}"
      crate="${project_name}" envsubst < "${temp}" > "${root_dir}/src/${temp_name}"
    done

    # ap actions
    cp -r "${skeleton_dir}/.ap-actions" "${root_dir}"

    # dependency crates
    cat "${skeleton_dir}/deps.toml" >> "${root_dir}/Cargo.toml"

    # git repo
    gi rust >> "${root_dir}/.gitignore"
  else
    jack error "Invalid path: $root_dir"
    exit 1
  fi
fi

# 〉

# Creat tmux session  〈
source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

session "$1"

# Window: "Main" 〈
() {
  if [[ -f "${root_dir}/src/main.rs" ]]; then
    file='src/main.rs'
  else
    file='src/lib.rs'
  fi

  local window_name="Main"
  local pane_title='Edit'
  local dir="${root_dir}"
  local cmd="nvim -p ${root_dir}/${file} ${root_dir}/.ap-actions/tmux-watch.zsh"
  window
}

# Pane: 'Watcher' 〈
() {
  local pane_title='Watcher'
  local dir="$root_dir"
  local cmd="${MDX_DOT_DIR}/zsh/scripts/rust/watch.zsh"
  pane
}
# 〉

# Pane: 'Shell' 〈
() {
  local hv=v
  local window_name='Shell'
  local pane_title='Shell'
  local dir="$root_dir"
  pane
}
# 〉

# 〉

finish

# 〉

# vim: ft=tmux-session.zsh fdm=marker fmr=〈,〉
