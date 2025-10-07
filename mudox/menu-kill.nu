#!/usr/bin/env nu

use lib/menu.nu *

new ' 󱓇  KILL '
# CURRENT
| nl
| tint      green
| item      Pane    '%'  kill-pane
| item      Window  '@'  kill-window
| run       Session '$'  "/Users/mudox/Git/tmux-config/plugins/tmux-sessionist/scripts/kill_session.sh #{session_name} #{session_id}"
| item      Server  '!'  kill-server
# WINDOWS
| nl
| tint      red
| powerline WINDOW
| item      Right    n   'kill-window -t :+'
| item      Left     p   'kill-window -t :-'
# PANES
| nl
| tint      yellow
| powerline PANE
| item      Right    l   "kill-pane -t '{right-of}'"
| item      Left     h   "kill-pane -t '{left-of}'"
| item      Up       u   "kill-pane -t '{up-of}'"
| item      Down     d   "kill-pane -t '{down-of}'"
| item      'On...' '/'  "display-panes 'kill-pane -t %%'"
| show --pane
