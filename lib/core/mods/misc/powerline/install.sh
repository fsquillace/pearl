
function post_install(){
    mkdir -p ${HOME}/.fonts
    mkdir -p ${HOME}/.fonts.conf.d/
    ln -s ${PEARL_ROOT}/mods/misc/powerline/font/PowerlineSymbols.otf ${HOME}/.fonts
    fc-cache -vf ${HOME}/.fonts

    cp ${PEARL_ROOT}/mods/misc/powerline/font/10-powerline-symbols.conf ${HOME}/.fonts.conf.d/

    info "Vim binding applied"
    if ask "Do you want Powerline binding also for Bash?" "N"

    then
        apply "source ${PEARL_ROOT}/mods/misc/powerline/powerline/bindings/bash/powerline.sh" "${HOME}/.bashrc" false
    fi
    if ask "Do you want Powerline binding also for Tmux?" "N"
    then
        apply "source ${PEARL_ROOT}/mods/misc/powerline/powerline/bindings/tmux/powerline.conf" "${HOME}/.tmux.conf" false
    fi

    return 0
}

function pre_remove(){
    rm -f ${HOME}/.fonts/PowerlineSymbols.otf
    fc-cache -vf ${HOME}/.fonts

    local powerline_conf_file="${HOME}/.fonts.conf.d/10-powerline-symbols.conf"
    [ -f "$powerline_conf_file" ] && rm -f $powerline_conf_file

    unapply "source ${PEARL_ROOT}/etc/vim/vim.d/settings/powerline.vim" "${HOME}/.vimrc"
    unapply "source ${PEARL_ROOT}/mods/misc/powerline/powerline/bindings/bash/powerline.sh" "${HOME}/.bashrc"
    unapply "source ${PEARL_ROOT}/mods/misc/powerline/powerline/bindings/tmux/powerline.conf" "${HOME}/.tmux.conf"

    return 0
}
