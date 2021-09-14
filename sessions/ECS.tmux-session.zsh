#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup ECS

root="${HOME}"

new_session SSH "${root}" 'ssh -i ~/.ssh/ecs root@120.24.177.88'
title_pane 1 '120.24.177.88'

clean_up
