#!/usr/bin/env zsh
set -euo pipefail

nodemon --quiet --ext swift --exec 'clear; swift test 2>&1 | xcbeautify'
