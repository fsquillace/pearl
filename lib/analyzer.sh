#!/bin/sh

function preexec(){
# Analyze the command first
# $@: command

    if [[ -n "$COMP_LINE" ]]
    then
        # We're in the middle of a completer.  This obviously can't be
        # an interactively issued command.
        return
    fi

    # don't cause a preexec for $PROMPT_COMMAND
    if [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ]
    then
        return
    fi

    # Prevent non-interactive shell
    [ -z "$PS1" ] && return
    [[ $- != *i* ]] && return
    # Prevent the case a source command is executed
    [ "$BASH_ARGV" != "" ] && return

    if echo "$@" | grep --color=auto -f $PEARL_ROOT/etc/regex
    then
        read -p "Be aware that Pearl detected the command as dangerous. Type enter to execute it."
    fi
}

function pearl_analyzer_switch(){
# $1: can be "on" or "off" (default "on")

    if [ "$1" == "on" ]
    then
        trap 'preexec $BASH_COMMAND' DEBUG
    elif [ "$1" == "off" ]
    then
        trap - DEBUG
    fi
}

pearl_analyzer_switch "on"

