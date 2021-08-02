#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/OneDrive/Apple/XiangTan"

setup 'XiangTan' "${root}"

# Studio
new_session 'Main' "${root}" "
nvim -o Package.swift
"

clean_up
