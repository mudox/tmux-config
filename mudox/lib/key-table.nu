#!/usr/bin/env nu

export def new [name: string prefix: string] {
  let switch = [-N $'Key table - ($name)' -n $prefix switch-client -T $name]
  let list = [-T $name -N $'List keys' '?' list-keys -T $name -P $prefix]
  { name: $name, prefix: $prefix, cmd: [$switch $list] }
}

export def item [key: string desc: string ...cmd: string] {
  let kt = $in
  $kt | update cmd { $in ++ [[-T $kt.name -N $"'($desc)'" $key ...$cmd]] }
}

export def switch-to [key: string target: string] {
  item $key $'Open ($target)' run-shell $'($env.MDX_TMUX_DIR)/mudox/switch-to.nu ($target)'
}

export def popup [key: string name: string cmd: string] {
  item $key $'Popup ($name)' display-popup '-E' '-w60%' '-h80%' $"'($cmd)'"
}

export def run [key: string desc: string cmd: string --my] {
  let kt = $in
  let cmd = if $my {
    [$env.MDX_TMUX_DIR mudox $cmd] | path join | path expand 
  } else {
    $cmd
  }

  $kt | item $key $desc run-shell $cmd
} 

export def commit [] {
  let kt = $in
  $kt.cmd | each { tmux bind-key ...$in } | ignore
}

