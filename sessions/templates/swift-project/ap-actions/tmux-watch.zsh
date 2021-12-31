#!/usr/bin/env zsh
set -euo pipefail

swift test |& xcpretty
