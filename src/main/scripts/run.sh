#!/bin/sh

set -e # exit on failed command
set -u # don't allow undefined variables.

#
# Make a long string to consume lots of memory.
#
# $1-value  Final string-length (100*($1))
# --------  -------------------
# 1         200
# 5         3200
# 10        102400
# 20        104857600
# 25        3355443200
# 30        107374182400

A="0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
for power in $(seq $1); do
  A="${A}${A}"
  echo "At power $power"
done

sleep 20

echo `free -t -m`