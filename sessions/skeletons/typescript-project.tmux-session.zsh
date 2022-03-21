#!/usr/bin/env zsh
set -euo pipefail

usage() {
cat <<\END
Create tmux session for the typescript project, create the project if requested.

Usage: $(basename $0) [-c] session_title project_name_or_path

Flags:
  -c create the project

Arguments:
  $1 name of the session
  $2 full path of the project or folder name under `$MDX_DEV_DIR/typescript`

Examples:
  tsp -c Try-typescript try-typescript
  tsp DA-typescript da-typescript
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
  prefix="${MDX_DEV_DIR:-${HOME}/Develop}/Typescript"
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
    pnpm init -y
    sd 'index.ts' 'src/index.ts' "${root_dir}/package.json"

    # skeleton files
    skeleton_dir="${MDX_TMUX_DIR}/sessions/skeletons/typescript-project"
    cp -a "${skeleton_dir}"/* "${root_dir}"
    
    # ap actions
    mv "${skeleton_dir}/ap-actions" "${root_dir}/.ap-actions"

    # git repo
    git init
    gi node >> "${root_dir}/.gitignore"

    # typescript compiler
    jack info 'Prepare TypeScript compiler'
    pnpm i -D typescript
    npx tsc --init
    sd '.*outDir.*' '    "outDir": "dist",' tsconfig.json

    # watcher
    pnpm i -D ts-node-dev

    # test
    jack info 'Prepare Jest'
    pnpm install -D jest ts-jest @types/jest
    pnpm exec ts-jest config:init
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
  local pane_title='  Edit'
  local dir="${root_dir}"
  local cmd="nvim ${root_dir}/src/index.ts"
  window
}

# Pane: 'Watcher' 〈
() {
  local pane_title='  Watch'
  local dir="${root_dir}"
  local cmd="${root_dir}/.ap-actions/default-watch-action.zsh"
  pane
}
# 〉

# 〉

finish

# 〉

# vim: fdm=marker fmr=〈,〉
