#!/usr/bin/env nu

rsp open Try-Rust try-rust
tmux split-pane -dh -c ~/Develop/Rust/try-rust mise watch watch-run-main
