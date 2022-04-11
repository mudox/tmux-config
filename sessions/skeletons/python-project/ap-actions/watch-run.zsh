#!/usr/bin/env zsh
set -euo pipefail

nodemon --quiet --ext py --exec 'clear; poetry run python src/${project_name}/main.py'

#  vim: fdm=marker fmr=〈,〉
