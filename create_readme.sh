#!/bin/sh
case "$1" in
-h|--help)
    {
    echo "$0 -h | --help"
    echo "$0 [readme_file [abbr_file]]"
    echo "    Read and sort acronyms from abbr_file."
    echo "    Then write them as a markdown table to readme_file."
    echo "    By default use abbr_file=abbr.csv readme_file=README.md"
    } >&2
    ;;
*)
    readme_file="${1:-README.md}"
    abbr_file="${2:-abbr.csv}"
    sort \
        --ignore-leading-blanks \
        --ignore-case \
        --field-separator=, \
        --key=1,1 "$abbr_file" \
    | tr ',' '|' \
    | sed -e '1iABBR|DEFINITION\n:---|:---' >"$readme_file"
esac
