#!/usr/bin/env zsh
set -euo pipefail

nodemon --quiet --ext py --exec 'clear; poetry run python src/${package_name}/main.py'

#  vim: fdm=marker fmr=〈,〉
