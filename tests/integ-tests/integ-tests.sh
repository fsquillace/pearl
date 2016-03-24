#!/bin/bash

set -e

unset PEARL_ROOT
unset PEARL_HOME
unset PEARL_TEMPORARY

PEARL_GIT_ROOT="$1"
export HOME=$(TMPDIR=/tmp mktemp -d -t pearl-user-home.XXXXXXX)
export PEARL_HOME="${HOME}/.config/pearl"
export PATH=$PEARL_GIT_ROOT/bin:$PATH

trap "rm -rf ${HOME}/" EXIT QUIT TERM KILL ABRT

function get_all_modules(){
    git submodule status | awk '{print $2}' | sed -e 's/^mods\///'
}

function info(){
    # $@: msg (mandatory) - str: Message to print
    echo -e "\033[1;37m$@\033[0m"
}

[ ! -e $PEARL_HOME ]
pearl install
[ -e $PEARL_HOME/.install ] || echo "$PEARL_HOME/.install does not exist after install"
[ -e $PEARL_HOME/pearlrc ] || echo "$PEARL_HOME/pearlrc does not exist after install"
[ -e $PEARL_HOME/pearlrc.fish ] || echo "$PEARL_HOME/pearl.fish does not exist after install"
[ -e $PEARL_HOME/envs ] || echo "$PEARL_HOME/envs does not exist after install"
[ -e $PEARL_HOME/mans ] || echo "$PEARL_HOME/mans does not exist after install"
[ -e $PEARL_HOME/etc ] || echo "$PEARL_HOME/etc does not exist after install"
[ -e $PEARL_HOME/opt ] || echo "$PEARL_HOME/opt does not exist after install"

source $PEARL_GIT_ROOT/pearl
[ -e "$PEARL_ROOT" ] || echo "$PEARL_ROOT does not exist"
[ -e "$PEARL_HOME" ] || echo "$PEARL_HOME does not exist"
[ -e "$PEARL_TEMPORARY" ] || echo "$PEARL_TEMPORARY does not exist"

info Install ALL pearl modules
for module in $(get_all_modules)
do
    yes "" | pearl install $module
done

info Update ALL Pearl modules
for module in $(get_all_modules)
do
    yes "" | pearl update $module
done

source ./tests/integ-tests/categories/pearl-modules-tests.sh

info Remove ALL pearl modules
for module in $(get_all_modules)
do
    pearl remove $module
done

yes | pearl remove
[ ! -e $PEARL_HOME ] || echo "$PEARL_HOME exists after remove it"
