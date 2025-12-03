#!/usr/bin/env nu

def main [] {
  # Check if .2 (pane 2) exists in current window
  let has_right_pane = (
    tmux has-session -t $".{right-of}"
    $env.LAST_EXIT_CODE == 0
  )

  if $has_right_pane {
    tmux break-pane -t $".{right-of}"
  } else {
    # Check if :2 (window 2) exists in session
    let has_next_window = (
      tmux has-session -t $":{next}"
      $env.LAST_EXIT_CODE == 0
    )

    if $has_next_window {
      tmux join-pane -s $":2" -t $"" -h
    } else {
      tmux split-window -h
    }
  }
}





