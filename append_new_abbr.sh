#!/usr/bin/env bash
abbr_file="${1:-abbr.csv}"
echo 'Avoid a comma sign'
echo 'Press Ctrl+D to stop'
while read -e -p 'ABBR: ' abbr
do
    read -e -p 'EXPLANATION: ' explanation
    previous="$(sed -n -e "/^${abbr^^},/p" "$abbr_file")"
    if [ "x$previous" = "x" ]
    then
        echo "${abbr^^},${explanation,,}" >> "$abbr_file"
    else
        echo "Previous entry found:"
        echo "OLD: ${previous%%,*} = ${previous#*,}"
        echo "NEW: ${abbr^^} = ${explanation,,}"
        read -e -p "Update? [Y/n]: " upd
        case "$upd" in
        n|N|no|No|NO)
            echo "Saved old: ${previous%%,*} = ${previous#*,}"
            ;;
        *)
            sed -i -e "s/^${abbr^^},.*$/${abbr^^},${explanation,,}/" "$abbr_file"
            echo "Saved new: ${abbr^^} = ${explanation,,}"
        esac
    fi
done
