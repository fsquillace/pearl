
function post_install(){
    mkdir -p ~/.fonts
    mkdir -p ~/.fonts.conf.d/
    cp ${PEARL_ROOT}/mods/powerline/font/PowerlineSymbols.otf ~/.fonts
    fc-cache -vf ~/.fonts

    cp ${PEARL_ROOT}/mods/powerline/font/10-powerline-symbols.conf ~/.fonts.conf.d/


    if ask "Do you want Powerline for Vim?"
    then
        apply "source ${PEARL_ROOT}/etc/vim.d/settings/powerline.vim" "${HOME}/.vimrc" false
    fi
    if ask "Do you want Powerline for Bash?"

    then
        apply "source ${PEARL_ROOT}/mods/powerline/powerline/bindings/bash/powerline.sh" "${HOME}/.bashrc" false
    fi
    if ask "Do you want Powerline for Tmux?"
    then
        apply "source ${PEARL_ROOT}/mods/powerline/powerline/bindings/tmux/powerline.conf" "${HOME}/.tmux.conf" false
    fi

    return 0
}

function pre_uninstall(){
    rm -f ~/.fonts/PowerlineSymbols.otf
    fc-cache -vf ~/.fonts

    rm ~/.fonts.conf.d/10-powerline-symbols.conf

    unapply "source ${PEARL_ROOT}/etc/vim.d/settings/powerline.vim" "${HOME}/.vimrc"
    unapply "source ${PEARL_ROOT}/mods/powerline/powerline/bindings/bash/powerline.sh" "${HOME}/.bashrc"
    unapply "source ${PEARL_ROOT}/mods/powerline/powerline/bindings/tmux/powerline.conf" "${HOME}/.tmux.conf"

    return 0
}
