: ${TABLE_NAME:?}
: ${TABLE_PREFIX:?}

tmux bind-key -n -N "Key table - ${TABLE_NAME}" "${TABLE_PREFIX}" switch-client -T "${TABLE_NAME}"
bind() {
    tmux bind-key -T "${TABLE_NAME}" "$@"
}

bind '?' list-keys -T "${TABLE_NAME}" -P "${TABLE_PREFIX} " -Na
