#!/usr/bin/env nu

# NOTE: currently rest parameter does not work like zsh `$@`

def --wrapped wrapper [...args] {
  let bin = '/opt/homebrew/bin/tmux'

  mut server = if 'KITTY_WINDOW_ID' in $env {
    'kitty'
  } else if 'ALACRITTY_WINDOW_ID' in $env {
    'alacritty'
  } else if 'WEZTERM_PANE' in $env {
    'wezterm'
  } else if $env.TERM_PROGRAM? == 'vscode' {
    'vscode'
  } else if 'ITERM_SESSION_ID' in $env {
    'iterm'
  } else {
    'default'
  } 
  if $env.NVIM? != null { $server += '-nvim-term' }

  if ($args | is-not-empty)  {
    if $args.0 == 'which-server' {
      return $server
    } else {
      exec $bin -L $server ...($args)
    }
  } else {
    exec $bin -L $server attach
  }
}

def --wrapped main [...args] {
  wrapper ...($args)
  # test_wrapper
}

use std assert

#[test]
def test_inside_nvim [] {
  $env.NVIM = foo
  let r = (wrapper which-server)
  assert ($r ends-with '-nvim-term')
}

#[test]
def test_outside_nvim [] {
  $env.NVIM = null
  let r = (wrapper which-server)
  assert not ($r ends-with '-nvim-term')
}
