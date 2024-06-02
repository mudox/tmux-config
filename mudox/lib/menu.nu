# vim: fdm=marker fmr=〈,〉

const default_tint = terminal

export def new [title: string] {
  {title: $title, body: [], tint: $default_tint}
}

export def tint [v: string] {
  update tint $v
}

export def item [title: string, key: string, cmd: string] {
  let menu = $in
  let title = $'#[fg=($menu.tint)]($title)'
  let body = $menu.body ++ [$title, $key, $cmd]
  $menu | update body $body
}

export def show [--pane] {
  let menu = $in
  let opts = if $pane { [-x P -y P] } else { [] }
  tmux display-menu ...($opts) -T $menu.title -- ...($menu.body)
}

export def popup [title: string, key: string, cmd: string] {
  let menu = $in
  let cmd = $'display-popup -E -w70% -h80% "($cmd)"'
  $menu | item $title $key $cmd
}

export def run [title: string, key: string, path: string, --my] {
  let menu = $in
  let path = if $my {
    [$env.MDX_TMUX_DIR mudox $path] | path join | path expand 
  } else {
    $path
  }
  
  let cmd = $'run-shell "($path)"'
  $menu | item $title $key $cmd
}

export def goto [title: string, key: string, session_name: string] {
	run $title $key --my $"switch-session.zsh ($session_name)"
}

export def nl [] {
  let menu = $in
  let body = $menu.body ++ ['- ', '-', '-']
  
  $menu | update body $body
}

export def powerline [title: string] {
  let menu = $in
  const menu_width = 22
  let padding = ' ' | fill -w ($menu_width - ($title | str length --grapheme-clusters))
  let title = $'-($padding)#[fg=($menu.tint),bg=default,nodim]#[fg=black,bg=($menu.tint),nodim] ($title) '
  let body = $menu.body ++ [$title, '-', '-']
  $menu | update body $body
}

def test [] {
  new '   Test '
  | tint  green
  | item  Print  a 'display-message -p hi'
  | nl
  | powerline NOTE
  | tint  red
  | item  Item  b cmd
  | popup Popup c nu
  | tint  yellow
  | run   Run   d --my test.nu
  | show
}
