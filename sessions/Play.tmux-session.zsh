#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/OneDrive/Play"

setup 'Play' "${root}"

new_session 'Play' "$root"

# new_window 'Python' "${root}/Python/Play" "
# ipython
# "

# new_window 'Ruby' "${HOME}/Ruby/Play" "
# pry
# "

play_window() {
  name=$1
  dir=$2
  file=$3

  new_window "$name" "$dir" "
  v $3
  "

  tmux split-window -dh -t "${window}" -c "$dir" sh tmux-test

  tmux set-option -w -t "${window}" remain-on-exit
}

play_window 'Swift' "${root}/swift" main.swift
play_window 'Lua51' "${root}/lua/5.1" main.lua
play_window 'Lua53' "${root}/lua/5.3" main.lua

clean_up
