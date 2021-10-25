#!/usr/bin/env zsh
set -euo pipefail

# Create tmux session for Swift project, create the project is requested
#
# Flags:
#   -l: create lib project
#   -b: create binary execution project
#
# Positional arguments:
#   $1: session name
#   $2: project path or name (under ~/Develop/Swift)
#   $3: one of (b)uild,(r)un,(t)test

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

if [[ ! -d $root_dir ]]; then
  if [[ -n $create ]]; then
    jack info 'Create project'

    # create project
    mkdir -p "$root_dir"
    cd "$root_dir"
    swift package init --type "$create"

    # git repo
    gi >> .gitignore

    # ap actions
    template_dir="${MDX_TMUX_DIR}/sessions/templates/swift-project"
    cp -r ${template_dir}/.ap-actions "${root_dir}"
  else
    jack error "Invalid path: $root_dir, specifying `-b | -l` to create project"
    exit 1
  fi
fi

# 〉

# Create tmux session 〈

jack info "Craete tmux session [$1]"

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup "$1"

# Editor
new_session Main "${root_dir}" "nvim ${root_dir}/package.swift ${root_dir}/.ap-actions/tmux-watch.zsh"
title_pane 1 'Edit'

# Watcher
tmux split-window \
  -t "${window}.1" \
  -h \
  -c "${root_dir}" \
  -d \
  -- \
  "${MDX_DOT_DIR}/zsh/scripts/swift/watch.zsh"
title_pane 2 Watcher

# Shell
tmux split-window \
  -t "${window}.2" \
  -v \
  -c "${root_dir}" \
  -d
title_pane 3 Shell

clean_up

# 〉

# vim: fdm=marker fmr=〈,〉
