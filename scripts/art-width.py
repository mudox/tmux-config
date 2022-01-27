#!/Users/mudox/.pyenv/shims/python
# NOTE: /usr/bin/python returns wrong results from `len(line)`

import fileinput

max_width = 0
for line in fileinput.input():
    if max_width < len(line):
        max_width = len(line)

print(max_width)
