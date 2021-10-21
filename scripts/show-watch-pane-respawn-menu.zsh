#!/usr/bin/env zsh

cmd() {
 echo -n  "select-pane -T \"Watch + $1\"; respawn-pane -k $2"
}

case $1 in
rust)
  title='[Rust] Watch'
  menu=(
    Check c "$(cmd 'Check' 'cargo watch -c -x check')"
    Build b "$(cmd 'Build' 'cargo watch -c -x build')"
    Run r "$(cmd 'Run' 'cargo watch -c -x run')"
    Test t "$(cmd 'Test' 'cargo watch -c -x test')"
    'Bench (nightly)' m "$(cmd 'Benchmark' 'cargo +nightly watch -c -x bench')"
  )
  ;;
swift)
  title='[Swift] Watch'
  menu=(
    Build c "$(cmd 'Build' 'swiftwatch b')"
    Run r "$(cmd 'Build' 'swiftwatch r')"
    Test t "$(cmd 'Build' 'swiftwatch t')"
  )
  ;;
*)
  title='Error'
  menu=(
    "Unkwon argument: '$1'" '' ''
    'Available arguments:' '' ''
    ''
    '-- swift' '' ''
    '-- rust' '' ''
  )
  ;;
esac

tmux display-menu -x P -y P -T "$title" "${menu[@]}"
