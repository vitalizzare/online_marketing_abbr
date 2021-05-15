#!/bin/sh
abbr_file="${1:-abbr.csv}"
sed -i -e 's/\ *$//' "$abbr_file"
