#!/bin/bash
# This module contains all utility functions for
# operational purposes


alias pgrep2="ps -ef | grep"

function tailf(){
    tail -f $@ | perl -pe 's/(ERROR)/\e[1;31m$1\e[0m/gi;s/(INFO)/\e[1;32m$1\e[0m/gi;s/(DEBUG)/\e[1;32m$1\e[0m/gi;s/(WARN)/\e[1;33m$1\e[0m/gi'
}


function memmost(){
    # $1: number of process to view (default 10).
    local num=$1
    [ "$num" == "" ] && num="10"

    local ps_out=$(ps -auxf)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | sort -nr -k 4 | head -n $num
}


function cpumost(){
    # $1: number of process to view (default 10).

    local num=$1
    [ "$num" == "" ] && num="10"

    local ps_out=$(ps -auxf)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | sort -nr -k 3 | head -n $num
}

function allbusy(){

    local ps_out=$(ps auxf)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | awk '($8~/.*D.*/){print $0}'
}

function allzombies(){

    local ps_out=$(ps auxf)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | awk '($8~/.*Z.*/){print $0}'
}

function allrunning(){

    local ps_out=$(ps auxf)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | awk '($8~/.*R.*/){print $0}'
}

function cpugt(){
    # $1: percentage of cpu. Default 90%

    local perc=$1
    [ "$perc" == "" ] && perc="90"

    local ps_out=$(ps -auxf)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | sort -nr -k 3 | awk -v "q=$perc" '($3>=q){print $0}'
}

function memgt(){
    # $1: percentage of memory. Default 90%

    local perc=$1
    [ "$perc" == "" ] && perc="90"

    local ps_out=$(ps -auxf)
    echo "$ps_out" | head -n 1
    echo "$ps_out" | sort -nr -k 4 | awk -v "q=$perc" '($4>=q){print $0}'
}

function repeat(){
    # $@ the command to be repeated
    while [ 1 ]
    do
        eval $@
        sleep 1
    done
}

function touser(){
    # $1: name of the user
    ps -U $1 -u $1 u
}


function frompid(){
    # $1: PID of the process
    ps -p $1 -o comm=
}


function topid(){
    # $1: name of the process
    ps -C $1 -o pid=
}


function is_file_open() {
    lsof | grep $(readlink -f "$1")
}


function notabs() {
    # Replace tabs by 4 spaces & remove trailing ones & spaces
    for f in $(findTxt "$@"); do
        sed -i -e 's/[	 ]*$//g' "$f"
        sed -i -e 's/	/    /g' "$f"
    done
}


function findTxt() {            # Find only text files
    find "$@" -type f -exec file {} \; | grep text | cut -d':' -f1
}


function kill_cmd(){
    # WIP - Kill every process starting with the pattern passed as a parameter
    while true; do
        pid=$(ps -eo pid,args | egrep -e "[0-9]* /bin/bash $1" | grep -v grep | grep -o '[0-9]*')
        echo "Killing $(ps -eo pid,args | egrep -e "[0-9]* /bin/bash $1" | grep -v grep)"
        if [ -n "$pid" ]; then
            kill "$pid"
        else
            break
        fi
    done
}
