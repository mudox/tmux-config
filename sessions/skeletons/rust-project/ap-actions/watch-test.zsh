#!/usr/bin/env zsh
set -euo pipefail

cargo watch --clear --shell '.ap-actions/script/test.zsh'
