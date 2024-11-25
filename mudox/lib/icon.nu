#!/usr/bin/env nu

export def icon-for [
  type: string # one of `session`, `window`, `pane`, `item`
  name: string
] {
    let cp = [$type $name] | into cell-path
    open ($env.MDX_TMUX_DIR + '/data/icons.toml') | get -i $cp
    # | default (match $type {
    #     'session' => null,
    #     'window'  => ' ',
    #     'pane'    => '󱂬 ',
    #     'item'    => '  ',
    #     _         => '❗'
    #   })
}

export def iprefix [
  type: string # one of `session`, `window`, `pane`, `item`
  name: string
  --icon: string
  --padding
] {
  if $name =~ '^[^a-zA-Z]' { 
    return $name 
  } else {
    let i = $icon | default (icon-for $type $name)
    if $i == null {
      if $padding {
        return $'   ($name)'
      } else {
        return $name
      }
    } else {
      return $'($i) ($name)'
    }
  }
}

export def istrip [] {
  str replace -r '^[^a-zA-Z]*' ''
}

def test [] {
  iprefix --icon '󰉊 ' session Flower | print

  iprefix session Neovim | print
  iprefix session Dotfiles --padding | print
  iprefix session Tmux | print
  iprefix session HammerSpoon | print
  
  iprefix session Session --padding | print
  iprefix window Window | print
  iprefix pane Pane | print

  iprefix server Server | print

  iprefix session '  Home'
}

def main [
  type: string 
  name: string
] {
  print (iprefix $type $name)
}
