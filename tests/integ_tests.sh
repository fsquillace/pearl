#!/bin/bash

set -eux

PEARL_GIT_ROOT="$1"
PEARL_HOME="~/.config/pearl"

PATH=$PEARL_GIT_ROOT/bin:$PATH

[ ! -e $PEARL_HOME ]
pearl system install
[ -e $PEARL_HOME/.install ] || echo "$PEARL_HOME/.install does not exist after install"
[ -e $PEARL_HOME/pearlrc ] || echo "$PEARL_HOME/pearlrc does not exist after install"
[ -e $PEARL_HOME/pearlrc.fish ] || echo "$PEARL_HOME/pearl.fish does not exist after install"
[ -e $PEARL_HOME/envs ] || echo "$PEARL_HOME/envs does not exist after install"
[ -e $PEARL_HOME/mans ] || echo "$PEARL_HOME/mans does not exist after install"
[ -e $PEARL_HOME/etc ] || echo "$PEARL_HOME/etc does not exist after install"
[ -e $PEARL_HOME/opt ] || echo "$PEARL_HOME/opt does not exist after install"

bash --rcfile "$PEARL_GIT_ROOT/pearl" -c "[ -e \$PEARL_ROOT ] && [ -e \$PEARL_HOME ]"
zsh --version
zsh -c "source $PEARL_GIT_ROOT/pearl && [ -e \$PEARL_ROOT ] && [ -e \$PEARL_HOME ]"
fish --version
# This will not work since travis has a old version of fish (1.23.1) and
# source command does not work
fish -c "source $PEARL_GIT_ROOT/pearl.fish; and [ -e \$PEARL_ROOT ]; and [ -e \$PEARL_HOME ]"

yes | pearl system uninstall
[ ! -e $PEARL_HOME ] || echo "$PEARL_HOME exists after uninstall"
