export def iprefix [
  type: string # one of `session`, `window`, `pane`
  name: string
  --icon(-i): string
] {
  if $name =~ '^[^a-zA-Z]' { return $name }

  mut icon = $icon
  if $icon == null {
    $icon = open ($env.MDX_TMUX_DIR + '/data/icons.toml') | get -i $type | get -i $name | default (match $type {
      'session' => ' ',
      'window'  => ' ',
      'pane'    => '󱓼 ',
      _         => '❗'
    })
  }

  return $'($icon) ($name)'
}

export def istrip [] {
  str replace -r '^[^a-zA-Z]*' ''
}

def test [] {
  iprefix -i '󰉊 ' session Flower | print

  iprefix session Neovim | print
  iprefix session Dotfiles | print
  iprefix session Tmux | print
  iprefix session HammerSpoon | print

  iprefix session Session | print
  iprefix window Window | print
  iprefix pane Pane | print

  iprefix server Server | print

  iprefix session '  Home'
}
