# Pearl script for fish shell
# Usage: source pearl.fish
# vim: set ft=fish ts=4 sw=4 noet:

####################### VARIABLES & IMPORTS ############################

set PEARL_HOME ~/.config/pearl
set PEARL_TEMPORARY $PEARL_HOME/tmp/(tty)
mkdir -p $PEARL_TEMPORARY

source $PEARL_HOME/.install

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

trap "source $PEARL_ROOT/pearl" USR1

source $PEARL_HOME/pearlrc.fish
