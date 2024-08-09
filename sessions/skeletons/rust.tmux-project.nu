#!/usr/bin/env nu

use ../../mudox/lib/session.nu
use std [assert log]

def main [] {
'usage:
    $0 create {type} {path} [--name(-n) {project_name}]
    $0 open {session_name} {path} [--cmd(-c) {command}]
'
}

def 'main create' [
  type: string         # project type, [bin|lib]
  path: string         # project path or part under $MDX_DEV_DIR/Rust
  --name(-n): string   # project name, snake_case, if missing derive from basename of `path`
] {
  let rootdir = (rootdir $path)
  if ($rootdir | path exists) {
    error make {msg: $'path already exists, abort project creation'}
  }

  if not ($type == 'bin' or $type == 'lib') {
    error make {msg: $'invalid value for parameter `type`: ($type | to nuon), should be [bin|lib]'}
  } 

  # temp dir
  cd (mktemp -d)
  let tmpdir = (pwd)
  log debug $'temp dir: ($tmpdir)'

  let name = if $name != null {
    $name
  } else {
    ($path | path basename | str replace -a '-' '_')
  }

  # create project
  cargo init $'--($type)' --name $name --verbose

  # .gitignore
  gi rust out>> .gitignore

  let skeleton_dir = $'$($env.MDX_TMUX_DIR)/sessions/skeletons/rust/simple'

  # skeleton files
  # glob $'($skeleton_dir)/*.rs' | each { |src| 
  #   let dst = $'src/($src | path basename)'
  #   open $src | crate=$name envsubst | save $dst
  # }

  # ap actions
  # cp -r $'($skeleton_dir)/ap-actions' $'($rootdir)/.ap-actions'

  # cargo.toml
  # open $'($skeleton_dir)/deps.toml' | save -a $'($rootdir)/Cargo.toml'

  # install
  cp -r $tmpdir $rootdir

  # clean
  cd $rootdir
  rm -rf $tmpdir
}

def 'main open' [
  sname: string              # session name
  path: string               # project path or part under $MDX_DEV_DIR/Rust
  --cmd(-c): string = 'nvim' # command
] {
  use ../../mudox/lib/session.nu *
  
  let rootdir = (rootdir $path)
  if not ($rootdir | path exists) {
    error make {msg: $'path "($rootdir)" does not exists, abort opening'}
  }

  new $sname
  | window Main $cmd -d $rootdir
  | end
}

def rootdir [path: string] {
  mut dir = if ($path | path exists) {
    if ($path | path type) != 'dir' {
      error make {msg: $'($path) exists, but is not a directory, abort'}
    }
    $path
  } else {
    let prefix = $'($env.MDX_DEV_DIR)/Rust'
    mkdir $prefix
    $'($prefix)/($path)'
  }
  
  $dir = ($dir | path expand)

  log debug $'root path resolved to: ($dir)'
  $dir
}
