#!/usr/bin/env zsh
set -euo pipefail

clear

# watch & run
ts-node-dev --respawn --transpile-only src/index.ts

# watch & test
# jest --watchAll
