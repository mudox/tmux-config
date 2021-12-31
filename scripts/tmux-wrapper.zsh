#!/usr/bin/env zsh

# Tmux binary
# wait for tmux 3.3 to release
# cmd=("${HOME}/Git/tmux/tmux") # compiled from source
cmd=("/opt/homebrew/bin/tmux") # HEAD

# Determine server
server=default
if [[ -n $ITERM_SESSION_ID ]]; then
  server=iterm
elif [[ -n $KITTY_WINDOW_ID ]]; then
  server=kitty
elif [[ -n $ALACRITTY_LOG ]]; then
  server=alacritty
elif [[ -n $HYPER ]]; then
  server=hyper
elif [[ $TERM_PROGRAM = vscode ]]; then
  server=vscode
fi
cmd+=(-L $server)

if (($# > 0)); then
  if [[ $1 = which-server ]]; then
    echo "$server"
  else
    exec $cmd $@
  fi
else
  # Attach or launch
  $cmd attach >/dev/null 2>&1
  if (($? != 0)); then
    echo 'creating intial session ...'
    exec $cmd new-session -s Default -n Main
  fi
fi