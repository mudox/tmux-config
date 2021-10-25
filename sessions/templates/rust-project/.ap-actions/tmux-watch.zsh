#!/usr/bin/env zsh
set -euo pipefail

RUST_BACKTRACE=1 cargo watch -c -x check
