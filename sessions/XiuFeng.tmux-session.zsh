#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/Develop/Apple/XiuFeng"

setup 'XiuFeng' "${root}"

new_session 'Main' "${root}/" "
nvim -p Podfile Project.swift
"

clean_up
