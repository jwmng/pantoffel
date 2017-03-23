#!/bin/sh
# Usage: `replace.sh file1 keyword replacement [-flags]`
# Replaces matches of `keyword` in `file1` with `replacement`
# Use `flags` for additional sed flags
sed $4 -e "s|$2|$3|g" $1
