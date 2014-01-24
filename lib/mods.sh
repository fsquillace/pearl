

function pearl_man_config(){
    PATH=$PATH:$PEARL_ROOT/mods/pearl-man/bin
    MANPATH=$MANPATH:$PEARL_ROOT/mods/pearl-man/man
    return 0
}

function powerline_config(){
    return 0
}

[ "$(ls -A "${PEARL_ROOT}/mods/pearl-man")" ] && pearl_man_config
[ "$(ls -A "${PEARL_ROOT}/mods/powerline")" ] && powerline_config


unset pearl_man_config
unset powerline_config
