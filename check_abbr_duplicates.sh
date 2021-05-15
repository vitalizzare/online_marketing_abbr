#!/usr/bin/env sh
abbr_file="${1:-abbr.csv}"
cut -d, -f1 "$abbr_file" | sort | uniq -d | xargs -l -Ientry grep "entry" "$abbr_file"

