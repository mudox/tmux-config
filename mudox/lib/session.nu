use mod.nu tmux-query

export def new [name: string] {
  try { tmux kill-session -t $'=($name)' o+e>| ignore }
  {name: $name}
}

export def window [
  name: string 
  cmd: string = 'zsh' 
  --dir(-d): string
  --pane-title(-p): string 
] {
  let session = $in

  let dir = $dir | default $session.dir? | default '~'
  let format = "#{session_id}\t#{window_id}\t#{pane_id}"
  
  let ids = (if $session.id? == null {
    (tmux new-session
      -s $session.name -n $name
      -x (tmux-query '#{client_width}') -y (tmux-query '#{client_height}')
      -c $dir
      -d
      -PF $format
      -- $cmd
    )
  } else {
    (tmux new-window
      -n $name
      -t $'($session.id):{end}' -a
      -c $dir
      -d
      -PF $format
      -- $cmd
    )
  } | split row "\t")

  # TODO: pane title

  $session 
  | upsert dir $dir
  | upsert id $ids.0
  | upsert window_id $ids.1
  | upsert pane_id $ids.2
}

export def pane [
  position: string # one of `h`, `v` `fh` `fv`
  cmd: string = 'zsh'
  --dir(-d): string
  --size(-s): string = '50%'
  --title(-t): string
] {
  let session = $in

  let dir = $dir | default $session.dir? | default '~'

  let pane_id = (tmux split-window
    -t $session.pane_id
    $'-($position)' -l $size
    -c $dir
    -d
    -PF '#{pane_id}'
    -- $cmd
  )

  # TODO: pane title

  $session | upsert pane_id $pane_id
}

export def end [] {
  let session = $in
  tmux select-window -t $'($session.id):1.1'
}

# test
# new TestNu
# | window Main -d ('~/Git/tmux-config' | path expand)
# | pane h 
# | window Edit -d ('~/Git/neovim-config' | path expand) nvim
