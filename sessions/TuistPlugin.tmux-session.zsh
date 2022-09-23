#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/Develop/Apple/TuistPlugin"

setup 'TuistPlugin' "${root}"

new_session 'Main' "${root}/" "
nvim Plugin.swift
"

clean_up
