# Pearl script for fish shell
# Usage: source pearl.fish
# vim: set ft=fish ts=4 sw=4 noet:

####################### VARIABLES & IMPORTS ############################

set -x PEARL_HOME ~/.config/pearl
set -x PEARL_TEMPORARY $PEARL_HOME/tmp/(tty)
mkdir -p $PEARL_TEMPORARY

if [ -e $PEARL_HOME/.install ]
    eval (cat $PEARL_HOME/.install | grep "export PEARL_ROOT=" | sed -e 's/^export/set -x/' -e 's/=/ /')
else
    echo "Error: Pearl is not installed. Type: 'pearl system install' first."
    exit 1
end
if [ ! -d "$PEARL_ROOT" ]
    echo "Error: Could not set PEARL_ROOT env because $PEARL_ROOT does not exist."
    exit 1
end

set PATH $PEARL_ROOT/bin $PATH
set MANPATH $MANPATH $PEARL_ROOT/man

################################# MAIN ##############################
for category in (ls $PEARL_ROOT/lib/core/mods/)
    for mod in (ls $PEARL_ROOT/lib/core/mods/$category)
        if bash -c "[ \"\$(ls -A $PEARL_ROOT/mods/$category/$mod)\" ]"
            if [ -e $PEARL_ROOT/lib/core/mods/$category/$mod/config.fish ]
                source $PEARL_ROOT/lib/core/mods/$category/$mod/config.fish
            end
        end
    end
end

trap "source $PEARL_ROOT/pearl.fish" USR1

source $PEARL_HOME/pearlrc.fish
