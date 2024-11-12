#!/usr/bin/env nu

### usage
# begin with `new`
#
# middle filled with
# - menu items
#   - `item`
#   - `run`
#   - `swithc-to`
#   - `popup`
#
# - style & deocration
#   - `tint`
#   - `nl`
#   - `powerline`
#
# end with `show`

use icon.nu *

const default_tint = "terminal"
const menu_width = 25 # magic number

export def new [title: string] {
  {title: $title, body: [], tint: $default_tint}
}

export def item [title: string, key: string, cmd: string] {
  let menu = $in
  mut title = $title
  if $title !~ '^[^a-zA-Z]' {
    $title = iprefix item $title
  }
  $title = $'#[fg=($menu.tint)]($title | fill -w ($menu_width - 3))'
  let body = $menu.body ++ [$title, $key, $cmd]
  $menu | update body $body
}

export def run [title: string, key: string, --my, cmd: string] {
  let menu = $in

  mut cmd = if $my {
    [$env.MDX_TMUX_DIR mudox $cmd] | path join | path expand 
  } else {
    $cmd
  }
  $cmd = $'run-shell "($cmd)"'

  $menu | item $title $key $cmd
}

export def switch-to [title: string, key: string, target: string] {
  let menu = $in
  mut title = $title
  let session = $target | split row ':' | get 0
  if $session == $title {
    $title = iprefix session $session
  }
  let cmd = $"switch-to.nu '($target)'"
	$menu | run $title $key --my $cmd
}

export def popup [title: string, key: string, cmd: string] {
  let menu = $in
  let cmd = $'display-popup -E -w70% -h80% "($cmd)"'
  $menu | item $title $key $cmd
}

export def child [title: string, key: string, name: string] {
  let menu = $in 
  let cmd = $'lib/menu.nu ($name)'
  $menu | run $title $key --my $cmd
}

export def tint [v: string] {
  let menu = $in 
  $menu | update tint $v
}

export def nl [] {
  let menu = $in
  let body = $menu.body ++ ['- ', '-', '-']
  $menu | update body $body
}

export def powerline [title: string] {
  let menu = $in
  let padding = ' ' | fill -w ($menu_width - ($title | str length --grapheme-clusters))
  let title = $'-($padding)#[fg=($menu.tint),bg=default,nodim]#[fg=black,bg=($menu.tint),nodim] ($title) '
  let body = $menu.body ++ [$title, '-', '-']
  $menu | update body $body
}

export def show [--pane] {
  let menu = $in
  let opts = if $pane { [-x P -y P] } else { [] }
  tmux display-menu ...($opts) -T $menu.title -- ...($menu.body)
}

# unused
export def dump [name?: string --pane] {
  let menu = $in
  let opts = if $pane { [-x P -y P] } else { [] }
  let items = ($menu.body | group 3 | each { 
    let item = $in
    let text = $"'($item.0)'" | fill -c ' ' -w 90
    let key = $"'($item.1)'"
    let cmd = $'"($item.2)"' | fill -c ' ' -w 40
    $"\\\n  ($text) ($key) ($cmd)"
  })

  mut text = "# vim: ft=tmux\n\n"
  $text += ([display-menu ...($opts) -T $"'($menu.title)'" -- ...($items)] | str join ' ')
  if $name != null {
    $text | save -f $'($env.MDX_TMUX_DIR)/tmux/($name).conf'
  } else {
    $text
  }
}

# show menu from definition file
# usage: menu.nu goto
# it will read `data/goto.nuon` to show the menu
export def main [
  name: string # name from `data/<name>.nuon` which defines the menu to show
] {
  use mod.nu load-data
  let data = (load-data $name)

  let menu = (new $data.m_title)
  $data.items | reduce --fold $menu {|item, menu|
    # ui items
    match $item.type {
      tint      => { return ($menu | tint $item.color)      }
      nl        => { return ($menu | nl)                    }
      powerline => { return ($menu | powerline $item.title) }
    }

    # data items
    if $item.m_title? == null { return $menu }
    match $item.type {
      item      => { $menu | item      $item.m_title $item.key $item.cmd               }
      run       => { $menu | run       $item.m_title $item.key $item.cmd --my=$item.my }
      switch-to => { $menu | switch-to $item.m_title $item.key $item.target            }
      popup     => { $menu | popup     $item.m_title $item.key $item.cmd               }
      child     => { $menu | child     $item.m_title $item.key $item.name              }

      _         => { $menu                                                             }
    }
  } | show
}
