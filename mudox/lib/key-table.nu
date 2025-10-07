#!/usr/bin/env nu

### usage
# begin with `new`
# middle
# - `item`
# - `run`
# - `swithc-to`
# - `popup`
# end with `commit`

### data syntax
#
# shared
# item:       key  cmd         kt_desc   m_title
# run:        key  cmd     my  kt_desc   m_title
# switch-to:  key  target                m_title
# popup:      key  cmd         kt_name   m_title
# child:      key  name        kt_name   m_title
#
# menu only
# nl:
# tint:       color
# powerline:  title

export def new [name: string prefix: string] {
  let pair = ($prefix | split row ':')
  let parent_kt = $pair.0
  let key = $pair.1

  let switch = [
    -N $'Key table - ($name)'
    -T $parent_kt $key
    switch-client -T $name
  ]

  { name: $name, prefix: $key, cmd: [$switch] }
  | item '?' $"list-keys -N -T '($name)'" 'List keys'
  | run  '-'  --my $"lib/menu.nu '($name)'" 'Show menu'
}

export def item [key: string cmd: string desc: string] {
  let kt = $in
  let call = [-T $kt.name -N $desc $key $cmd]
  $kt | update cmd { $in ++ [$call] }
}

export def run [key: string cmd: string --my desc: string] {
  let kt = $in

  mut cmd = if $my {
    [$env.MDX_TMUX_DIR mudox $cmd] | path join | path expand
  } else {
    $cmd
  }
  $cmd = $'run-shell "($cmd)"'

  $kt | item $key $cmd $desc
}

export def switch-to [key: string target: string] {
  let kt = $in
  let cmd = $"run-shell '($env.MDX_TMUX_DIR)/mudox/switch-to.nu ($target)'"
  let desc = $'Switch to ($target)'
  $kt | item $key $cmd $desc
}

export def popup [key: string name: string cmd: string] {
  let kt = $in
  let cmd = $"display-popup -E -w60% -h80% '($cmd)'"
  let desc = $'Popup ($name)'
  $kt | item $key $cmd $desc
}

export def child [key: string name: string] {
  let kt = $in
  let switch = [
    -N $'Key table - ($name)'
    -T $kt.name $key
    switch-client -T $name
  ]
  $kt | update cmd { $in ++ [$switch] }
}

export def commit [] {
  let kt = $in
  $kt.cmd | each { tmux bind-key ...$in } | ignore
}

export def main [name: string] {
  use mod.nu load-data
  let data = (load-data $name)

  let kt = (new $data.kt_name $data.prefix)
  $data.items | reduce --fold $kt {|item, kt|
    match $item.type {
      item      => { $kt | item       $item.key $item.cmd                  $item.kt_desc },
      run       => { $kt | run        $item.key $item.cmd    --my=$item.my $item.kt_desc },
      switch-to => { $kt | switch-to  $item.key $item.target                             },
      popup     => { $kt | popup      $item.key $item.cmd                  $item.kt_name },
      child     => { $kt | child      $item.key $item.name                               },

      _         => { $kt                                                                 }
    }
  } | commit
}
