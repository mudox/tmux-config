#!/usr/bin/env zsh
set -euo pipefail

clear

# test
# poetry run pytest --pdb

# run
poetry run python src/${project_name}/main.py

#  vim: fdm=marker fmr=〈,〉
