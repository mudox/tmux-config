#!/usr/bin/env nu

def hook [event: string] {
  let hook_file = [$env.MDX_TMUX_DIR mudox hook $'($event).nu'] | path join
	tmux set-hook -g $'($event)[100]' $"run-shell '($hook_file)'"
}

# hook client-session-changed
# hook after-split-window
# hook after-kill-pane
# hook pane-focus-in
# hook after-resize-pane
