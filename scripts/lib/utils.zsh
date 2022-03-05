#  vim: fdm=marker fmr=〈,〉

readonly sessions_dir="${MDX_TMUX_DIR}/sessions"
readonly themes_dir="${MDX_TMUX_DIR}/themes"
readonly resources_dir="${MDX_TMUX_DIR}/resources"

readonly scripts_dir="${MDX_TMUX_DIR}/scripts"
readonly hooks_dir="${scripts_dir}/hooks"
readonly session_themes_dir="${scripts_dir}/session-themes"
readonly session_configs_dir="${scripts_dir}/session-configs"

get_session_name() {
  tmux display-message -p '#{session_name}'
}

get_session_theme_name() {
  tmux show-option -gv @mdx-tmux-theme
}

get_pane_command() {
  tmux display-message -t "${1:?}" -p '#{pane_current_command}'
}

get_pane_label() {
  : ${1:?pane id}

  if [[ $1 = current ]]; then
    tmux show-options -p pane-border-format
  else
    tmux show-options -p -t "$1" pane-border-format
  fi
}

set_pane_label_suffix() {
  : ${1:?pane id}
  : ${2:?label}

	local format=" [#{pane_index}] $2 "
  if [[ $1 = current ]]; then
    tmux set-option -p pane-border-format "${format}"
  else
    tmux set-option -p -t "$1" pane-border-format "${format}"
  fi
}
