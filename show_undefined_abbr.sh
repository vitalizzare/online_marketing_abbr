#!/bin/sh
abbr_file="${1:-abbr.csv}"
sed -n -e '/^.\+,$/p' "$abbr_file" | cut -d, -f1 | sort | uniq
