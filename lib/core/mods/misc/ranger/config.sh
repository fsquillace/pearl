#!/bin/bash
# Compatible with ranger 1.4.2 through 1.6.*
#
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

export PATH=$PATH:$PEARL_ROOT/mods/misc/ranger/scripts

# cd to last path after exit
# This functionallows to change the directory 
# to the last visited one after ranger quits.
# You can always type "cd -" to go back
# to the original one.
function ranger-cd(){
    local ranger_command="python ${PEARL_ROOT}/mods/misc/ranger/scripts/ranger"

    # Checks out into the jobs if the user pressed the C-z key
    local id=$(jobs | grep ranger | awk -F "[][]" '{print $2}')
    if [ "$id" != "" ]
    then
        fg $id
        return
    fi

    # Checks out if the user pressed S key
    if [ "$RANGER_LEVEL" != "" ]
    then
        exit
        return # Ensures that it returns anyway if there are jobs stopped
    fi

    local tempfile='/tmp/chosendir'
    $ranger_command --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        echo $(cat "$tempfile")
        builtin cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# This binds Ctrl-O to ranger-cd:
[ -z "$BASH" ] || bind '"\C-o":"\C-u\C-k ranger-cd\C-m"'


[ -n "$RANGER_LEVEL" ] && PS1='(in ranger)'"$PS1"
