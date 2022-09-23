#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/Develop/Apple/HuiLong"

setup 'HuiLong' "${root}"

new_session 'Main' "${root}/" "
nvim -p Project.swift
"

clean_up
