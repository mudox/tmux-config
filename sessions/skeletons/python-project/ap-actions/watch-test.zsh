#!/usr/bin/env zsh
set -euo pipefail

nodemon --quiet --ext py --exec 'clear; poetry run pytest --pdb'

#  vim: fdm=marker fmr=〈,〉
