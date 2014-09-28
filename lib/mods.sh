
function pearl_ssh_config(){
    MANPATH=$MANPATH:$PEARL_ROOT/mods/pearl-ssh/man
    PEARL_SSH_ROOT="${PEARL_ROOT}/mods/pearl-ssh"
    source ${PEARL_ROOT}/mods/pearl-ssh/lib/ssh.sh
    return 0
}

function pearl_man_config(){
    PATH=$PATH:$PEARL_ROOT/mods/pearl-man/bin
    MANPATH=$MANPATH:$PEARL_ROOT/mods/pearl-man/man
    PEARL_MAN_ROOT="${PEARL_ROOT}/mods/pearl-man"
    source ${PEARL_ROOT}/mods/pearl-man/pearl-man
    return 0
}

function powerline_config(){
    return 0
}

function ls_colors_config(){
    eval $(dircolors -b $PEARL_ROOT/mods/ls-colors/LS_COLORS)
    return 0
}

[ "$(ls -A "${PEARL_ROOT}/mods/pearl-man")" ] && pearl_man_config
[ "$(ls -A "${PEARL_ROOT}/mods/pearl-ssh")" ] && pearl_ssh_config
[ "$(ls -A "${PEARL_ROOT}/mods/powerline")" ] && powerline_config
[ "$(ls -A "${PEARL_ROOT}/mods/ls-colors")" ] && ls_colors_config


unset pearl_man_config
unset pearl_ssh_config
unset powerline_config
unset ls_colors_config
