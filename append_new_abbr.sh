#!/usr/bin/env bash

abbr_file="${1:-abbr.csv}"
readme_file="${2:-README.md}"

update_readme() {
    echo " Getting out..."
    read -e -p "Update $readme_file before exit? [Y/n] " answer
    case "$answer" in
    n|N|no|No|NO)
        echo "$readme_file remained intact"
        ;;
    *)
        error_msg=$(./create_readme.py "$readme_file" "$abbr_file" 2>&1 1>/dev/null)
        error_code=$?
        if [ $error_code -eq 0 ] 
        then 
            echo "$readme_file is updated" 
        else
            echo ERROR $error_code: $error_msg >&2
        fi
    esac
}

trap "update_readme" EXIT

duplicates="$(./check_abbr_duplicates.sh "$abbr_file")"
[ "x$duplicates" = "x" ] || \
{
    echo -e "Resolve duplicate before continue:\n$duplicates" 
    exit 1
}

echo 'Press Ctrl+C to stop'

while read -e -p 'ABBR: ' abbr
do
    if ! expr "$abbr" : "^[[:alnum:]]\+\$">/dev/null; then continue; fi
    # abbr to upper case
    abbr="${abbr^^}"
    read -e -p 'EXPLANATION: ' explanation
    # delete any possible comma in explanation
    explanation="${explanation//,}"
    previous="$(grep "^$abbr," "$abbr_file")"
    if [ "x$previous" = "x" ]
    then
        echo "${abbr},${explanation}" >> "$abbr_file"
    else
        echo "Previous entry found:"
        echo "OLD: ${previous%%,*} = ${previous#*,}"
        echo "NEW: ${abbr} = ${explanation}"
        read -e -p "Update? [Y/n]: " upd
        case "$upd" in
        n|N|no|No|NO)
            echo "Saved old: ${previous%%,*} = ${previous#*,}"
            ;;
        *)
            echo "Saved new: ${abbr} = ${explanation}"
            # mask some chars with a backslash sign
            explanation="$(echo $explanation | sed -e 's/[/\]/\\&/g')"
            sed -i -e "s/^${abbr},.*$/${abbr},${explanation}/" "$abbr_file"
        esac
    fi
done
