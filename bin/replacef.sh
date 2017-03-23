#!/bin/sh
# Usage: `replacef.sh file1 keyword file2 [-flags]`
# Replaces matches of `keyword` in `file1` with the content of `file2`
# Use `flags` for additional sed flags
sed $4 -e "/$2/ {
 r $3
 d
}" $1
