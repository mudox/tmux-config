#!/usr/bin/env zsh

# Tmux binary
cmd=("/opt/homebrew/bin/tmux")

# Determine server
if [[ -n $KITTY_WINDOW_ID ]]; then
  server=kitty
elif [[ -n $ITERM_SESSION_ID ]]; then
  server=iterm
elif [[ -n $ALACRITTY_LOG ]]; then
  server=alacritty
elif [[ -n $HYPER ]]; then
  server=hyper
elif [[ $TERM_PROGRAM = vscode ]]; then
  server=vscode
else
  server=default
fi
cmd+=(-L $server)

if (($# > 0)); then
  if [[ $1 = which-server ]]; then
    echo "$server"
  else
    exec $cmd $@
  fi
else
  eval "$("${MDX_GIT_DIR}/base16-shell/profile_helper.sh")"
  exec $cmd attach >/dev/null 2>&1
fi
