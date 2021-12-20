#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${HOME}/.config/nvim"

session "Neovim"

# Window `Main` 〈
() {
local window_name="Main"
local pane_title="Mode: Default"
local dir="${root_dir}"
local cmd='nvim init.lua'
window

# right pane
local pane_title='Mode: LSP'
local cmd='MDX_NVIM_MODE=lsp nvim init.lua'
pane
}
# 〉

# Window `Log` 〈
() {
local tail=(tail -n 100 -F)

# pane 'Neovim'
local window_name=Log
local pane_title=Neovim
local dir="${HOME}/.cache/nvim"
local cmd="$tail -f log"
window

# pane 'LSP'
local pane_title="LSP"
local cmd="$tail -f lsp.log"
pane

# pane 'LSP Installer'
local pane_title="LSP Installer"
local cmd="$tail -f lsp-installer.log"
pane

# pane 'Packer'
local pane_title="Packer"
local cmd="$tail -f packer.nvim.log"
pane

tmux select-layout -t "$window" -E
}
#  〉

# Window `Pad` 〈
() {
local window_name="LuaPad"
local dir="${HOME}/Develop/Lua"
local cmd="nvim luapad.lua -c 'lua require(\"luapad\").attach()'"
window
}
#  〉

# Window `Snippets` 〈
() {
local window_name="Snippets"
local dir="${HOME}/.local/share/nvim/site/mdx_nvim_mode/default/pack/packer/start/vim-snippets"
local cmd="nvim UltiSnips/all.snippets"
window
}
#  〉

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
