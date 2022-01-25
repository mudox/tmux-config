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
