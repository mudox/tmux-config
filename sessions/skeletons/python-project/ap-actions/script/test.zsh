#!/usr/bin/env zsh
set -euo pipefail

clear
# tmux clear-history -t '.2'

pattern='valid_bst'

# Run given test
# poetry run pytest --pdb -v -k "${pattern}"

# Run all tests
poetry run pytest --pdb -v

# Run tests marked by ``@pytest.marker.x`
# poetry run pytest --pdb -v -m x
