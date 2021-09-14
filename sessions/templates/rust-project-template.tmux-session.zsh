#!/usr/bin/env zsh

# option -l: create lib project
# option -b: create binary execution project
#
# $1: session (project) name, usually capitalized from crate name
# $2: project path or name (under ~/Develop/Rust), usually fully lowercase
# $3: one of [c|b|r|t]
#
# example:
#   rsp -b tav Tav r
#   rsp -l ap Ap c

set -euo pipefail

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

#
# parse options
#

zparseopts -D -E l=lib b=bin
if [[ -n $lib ]]; then
  create='--lib'
elif [[ -n $bin ]]; then
  create='--bin'
fi

if [[ -d $2 ]]; then
  root_dir="$2"
else
  root_dir="${HOME}/Develop/Rust/$2"
fi
project_name=$(basename $root_dir)

#
# parse positional arguments
#

if [[ $# -ne 3 || ! $3 =~ [cbrt] ]]; then
  echo "Usage: $0 {SESSION_NAME} {ROOT_DIR} {ACTION}"
  exit 1
fi

typeset -A titles
titles=(
  c 'Watch + Check'
  b 'Watch + Build'
  r 'Watch + Run'
  t 'Watch + Test'
)

#
# create project if requested
#

if [[ ! -d $root_dir ]]; then
  set +u
  if [[ -n $create ]]; then
    jack info 'Create project ...'

    cargo new "$root_dir" "$create"

    cd "$root_dir"

    temp_dir="${MDX_TMUX_DIR}/sessions/templates/rust-project-template"
    for temp in ${temp_dir}/*.rs; do
      temp_name="${$(basename "$temp")//-/_}"
      crate="$project_name" envsubst < "${temp}" > "${root_dir}/src/${temp_name}"
    done

    cat "${temp_dir}/deps.toml" >> "${root_dir}/Cargo.toml"

    gi rust >> "${root_dir}/.gitignore"
  else
    jack error "Invalid path: $root_dir"
    exit 1
  fi
  set -u
fi

#
# creat tmux session
#

jack info "Create tmux session [$1]"

setup "$1"

# Editor
if [[ -f "${root_dir}/src/main.rs" ]]; then
  file='src/main.rs'
else
  file='src/lib.rs'
fi
new_session Main "${root_dir}" "nvim $root_dir/$file"
title_pane 1 Edit

# Watcher
tmux split-window \
  -t "${window}.1" \
  -h \
  -c "${root_dir}" \
  -d -- \
  cargo watch -c -x "$3"
title_pane 2 "${titles[$3]}"
tmux set-option -p -t "${window}.2" "@respawn-menu-id" rust

# Shell
tmux split-window \
  -t "${window}.2" \
  -v \
  -c "${root_dir}" \
  -d
title_pane 3 Console

# Window: Git

clean_up
