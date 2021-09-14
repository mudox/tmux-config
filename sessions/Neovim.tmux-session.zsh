#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root_dir="${HOME}/.config/nvim"

setup 'Neovim' "${root_dir}"

new_session Main "${root_dir}" 'nvim'
title_pane 1 Neovim


path_dir="${HOME}/Develop/Lua"
new_window Pad "$path_dir" "nvim luapad.lua -c 'lua require(\"luapad\").attach()'"
title_pane 1 Pad

snippets_dir="${HOME}/.local/share/nvim/site/pack/packer/start/vim-snippets"
new_window Snippets "$snippets_dir" "nvim"
title_pane 1 Snippets

clean_up
