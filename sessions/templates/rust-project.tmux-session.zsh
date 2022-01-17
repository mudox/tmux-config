#!/usr/bin/env zsh
set -euo pipefail

usage() {
cat <<-\END
Create tmux session for the Rust project, create the project if requested.

Usage: $(basename $0) [-b|-l] session_title project_name_or_path

Flags:
  -l create library project
  -b create executable project

Positional arguments:
  $1 name of the session
  $2 full path of the project or folder name under `$MDX_DEV_DIR/Rust`

Example:
  rsp -b Tav tav
  rsp -l TmuxKit tmux-kit
END
}

# Parse flags 〈
typeset create
zparseopts -D -E l=create b=create

# $create
if [[ $create = '-l' ]]; then
  create='--lib'
elif [[ $create = '-b' ]]; then
  create='--bin'
fi
# 〉

# Parse positional arguments 〈
if [[ $# -ne 2 ]]; then 
  jack error "Invalid number of positional arguments"
  usage
  exit 1
fi

# ${root_dir}
typeset root_dir
if [[ -d $2 ]]; then
  root_dir="$2"
else
  prefix="${MDX_DEV_DIR:-${HOME}/Develop}/Rust"
  if [[ ! -d $prefix ]]; then
    mkdir -pv "$prefix"
  fi
  root_dir="${prefix}/$2"
fi
# 〉

# Create project if requested  〈
if [[ ! -d ${root_dir} ]]; then
  if [[ -n $create ]]; then
    jack info 'Create project'

    # create project
    cargo new "${root_dir}" "$create"
    cd "${root_dir}"

    skeleton_dir="${MDX_TMUX_DIR}/sessions/templates/rust-project"
    crate_name="${$(basename "${root_dir}")//-/_}"

    # skeleton files
    for temp in "${skeleton_dir}"/*.rs; do
      temp_name="$(basename $temp)"
      crate="${crate_name}" envsubst < "${temp}" > "${root_dir}/src/${temp_name}"
    done

    # ap actions
    cp -r "${skeleton_dir}/ap-actions" "${root_dir}/.ap-actions"

    # dependency crates
    cat "${skeleton_dir}/deps.toml" >> "${root_dir}/Cargo.toml"

    # git repo
    gi rust >> "${root_dir}/.gitignore"
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
  local pane_title=' Edit'
  local dir="${root_dir}"
  local cmd="nvim -p ${root_dir}/${file} ${root_dir}/.ap-actions/tmux-watch.zsh"
  window
}

# Pane: 'Watcher' 〈
() {
  local pane_title='  Watch'
  local dir="${root_dir}"
  local cmd="cargo watch -- ${root_dir}/.ap-actions/tmux-watch.zsh"
  pane
}
# 〉

# Pane: 'Shell' 〈
() {
  local hv=v
  local window_name='Shell'
  local pane_title='  Shell'
  local dir="${root_dir}"
  pane
}
# 〉

# 〉

finish
# 〉

# vim: ft=tmux-session.zsh fdm=marker fmr=〈,〉
