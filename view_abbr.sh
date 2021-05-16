#!/usr/bin/env bash
abbr_file="${1:-abbr.csv}"
echo 'Press Ctrl+C to exit'
while read -e -p 'ABBR: ' abbr
do
    entry=$(sed -n -e "/^${abbr^^},/p" "$abbr_file")
    if [ "x$entry" = "x" ]
    then
        echo "Nothing found"
    else
        echo "${entry%%,*} = ${entry#*,}"
    fi
done
