

function pearl_man_config(){
    PATH=$PATH:$PEARL_ROOT/mods/pearl-man/bin
    MANPATH=$MANPATH:$PEARL_ROOT/mods/pearl-man/man
    return 0
}

[ "$(ls -A "$PEARL_ROOT/mods/pearl-man")" ] && pearl_man_config


unset pearl_man_config
