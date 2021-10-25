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

# Parse flags {{{1

zparseopts -D -E l=lib b=bin

# $create
create=''
if [[ -n $lib ]]; then
  create='--lib'
elif [[ -n $bin ]]; then
  create='--bin'
fi

# $root_dir
if [[ -d $2 ]]; then
  root_dir="$2"
else
  root_dir="${HOME}/Develop/Rust/$2"
fi

# $project_name
project_name=$(basename $root_dir)

# }}}1

# Parse positional arguments {{{1

if [[ $# -ne 2 ]]; then
  jack error 'Invalid number of arguments'

  print "\
  Usage: $(basename $0) [-b | -l] session-name name-or-path

  Flags:
    -l create library project
    -b create executable project
  "

  exit 1
fi
# }}}1

# Create project if requested {{{1

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

# }}}1

# Creat tmux session {{{1

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh


jack info "Create tmux session [$1]"

setup "$1"

# Editor
if [[ -f "${root_dir}/src/main.rs" ]]; then
  file='src/main.rs'
else
  file='src/lib.rs'
fi
new_session Main "${root_dir}" "nvim -p ${root_dir}/$file ${root_dir}/.ap-actions/tmux-watch.zsh"
title_pane 1 Edit

# Watcher
tmux split-window \
  -t "${window}.1" \
  -h \
  -c "${root_dir}" \
  -d -- \
  ${MDX_DOT_DIR}/zsh/scripts/rust/watch.zsh

title_pane 2 Watcher
# tmux set-option -p -t "${window}.2" "@respawn-menu-id" rust

# Shell
tmux split-window \
  -t "${window}.2" \
  -v \
  -c "${root_dir}" \
  -d
title_pane 3 Shell

# Window: Git

clean_up

# }}}1

# vim: fdm=marker
