#!/usr/bin/fish

set PEARL_GIT_ROOT $argv[1]
set -x HOME (mktemp -d -t pearl-user-home.XXXXXXX)
set -x PEARL_HOME "$HOME/.config/pearl"
set -x PATH $PEARL_GIT_ROOT/bin $PATH

function pearl_remove_home --on-process-exit %self
    rm -fr $HOME
end

function get_all_modules
    git submodule status | awk '{print $2}' | sed -e 's/^mods\///'
end

function info
    set_color white
    echo $argv
    set_color normal
end

function die
    set_color red
    echo $argv
    set_color normal
    exit 1
end

[ ! -e $PEARL_HOME ]; or die "$PEARL_HOME exists"
pearl install; or die "Error on pearl install"
[ -e $PEARL_HOME/.install ]; or die "$PEARL_HOME/.install does not exist after install"
[ -e $PEARL_HOME/pearlrc ]; or die "$PEARL_HOME/pearlrc does not exist after install"
[ -e $PEARL_HOME/pearlrc.fish ]; or die "$PEARL_HOME/pearl.fish does not exist after install"
[ -e $PEARL_HOME/envs ]; or die "$PEARL_HOME/envs does not exist after install"
[ -e $PEARL_HOME/mans ]; or die "$PEARL_HOME/mans does not exist after install"
[ -e $PEARL_HOME/etc ]; or die "$PEARL_HOME/etc does not exist after install"
[ -e $PEARL_HOME/opt ]; or die "$PEARL_HOME/opt does not exist after install"

source $PEARL_GIT_ROOT/pearl.fish; or die "Error on sourcing pearl.fish"
[ -e $PEARL_ROOT ]; or die "$PEARL_ROOT does not exist"
[ -e $PEARL_HOME ]; or die "$PEARL_HOME does not exist"
[ -e $PEARL_TEMPORARY ]; or die "$PEARL_TEMPORARY does not exist"

info Install ALL pearl modules
for module in (get_all_modules)
    yes "" | pearl install $module; or die "Error on pearl install $module"
end

info Update ALL Pearl modules
for module in (get_all_modules)
    yes "" | pearl update $module; or die "Error on pearl update $module"
end

info Remove ALL pearl modules
for module in (get_all_modules)
    pearl remove $module; or die "Error on pearl remove $module"
end

yes | pearl remove; or die "Error on pearl remove"
[ ! -e $PEARL_HOME ]; or echo "$PEARL_HOME exists after remove it"
