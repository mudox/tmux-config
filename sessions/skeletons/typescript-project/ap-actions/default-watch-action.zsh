#!/usr/bin/env zsh
set -euo pipefail

pnpm exec ts-node-dev --clear --respawn --transpile-only src/index.ts
