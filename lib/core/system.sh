#!/bin/bash

function pearl_install(){
    [ -e $PEARL_HOME/.install ] && error "Pearl seems already been installed. Check ${PEARL_HOME}/.install file."
    PEARL_ROOT=$1

    pearl_logo
    # Shows information system
    echo ""
    (uname -m && cat /etc/*release)

    echo ""
    echo "The pearl configurations are not mandatory but they are strongly recommended."
    echo "They consist of vim, bash, readline and much more made by pearl."
    echo "You can easily change or reset the settings of pearl whenever you want executing:"
    echo ">> pearl module install dotfiles"
    echo ">> pearl-dotfiles list"
    echo ">> pearl-dotfiles enable <configname>"
    echo ""
    echo "In order to have pearl at shell startup,"
    echo "put the following in your shell config file (i.e. .bashrc, .zshrc or config.fish)"
    echo "source ${PEARL_ROOT}/pearl"
    echo ""
    echo "For more information: man pearl"

    echo "Creating ~/.config/pearl directory ..."
    mkdir -p $PEARL_HOME/envs
    mkdir -p $PEARL_HOME/mans
    mkdir -p $PEARL_HOME/etc
    mkdir -p $PEARL_HOME/opt

    echo "# The following line is used to identify the pearl location (do not change it!):" > $PEARL_HOME/.install
    echo "export PEARL_ROOT=$PEARL_ROOT" >> $PEARL_HOME/.install

   [ -e $PEARL_HOME/pearlrc ] || echo "#This script is used to override the pearl settings." > $PEARL_HOME/pearlrc
   [ -e $PEARL_HOME/pearlrc.fish ] || echo "#This script is used to override the pearl settings." > $PEARL_HOME/pearlrc.fish

}

function pearl_logo(){
cat "$PEARL_ROOT/share/logo/logo-ascii.txt"
}

function pearl_uninstall(){
    if [ ${#@} -ne 0 ]; then
        echo "pearl_uninstall: unrecognized options '$@'"
        echo "Usage: pearl_uninstall"
        return 128
    fi

    if [ ! -d $PEARL_ROOT/.git ]
    then
        echo "pearl wasn't installed using Git."
        echo "May be it was installed by the package manager of the system."
        echo "Use it if you want to uninstall Pearl."
        return 1
    fi

    if ask "Are you sure to DELETE completely Pearl?" "N"
    then
        echo "Resetting all the configuration files..."
        # TODO refactor this:
        # Bash
        unapply "source $PEARL_ROOT/pearl" $HOME/.bashrc
        # Vim
        unapply "source $PEARL_ROOT/etc/vim/vimrc" $HOME/.vimrc
        # Inputrc
        unapply "\$include $PEARL_ROOT/etc/inputrc" $HOME/.inputrc
        # Ranger
        unapply "exec(open('$PEARL_ROOT/etc/ranger/commands.py').read())" $HOME/.config/ranger/commands.py
        # Screenrc
        unapply "source $PEARL_ROOT/etc/screenrc" $HOME/.screenrc
        # XDefautls
        unapply "# include \"$PEARL_ROOT/etc/Xdefaults\"" $HOME/.Xdefaults
        # Gitconfig
        unapply "\[include\] path = \"$PEARL_ROOT/etc/git/gitconfig\"" $HOME/.gitconfig
        [ -f $HOME/.gitignore ] && rm -f $HOME/.gitignore

        echo "Removing Pearl on the system..."
        rm -rf $PEARL_ROOT
    fi

    if ask "Are you sure to DELETE the Pearl config folder too ($PEARL_HOME folder)?" "N"
    then
       rm -rf $PEARL_HOME
   fi

}

function pearl_update(){
    builtin cd $PEARL_ROOT
    if [ "$1" = "soft"  ]
    then
        git pull
    elif [ "$1" = "" ] || [ "$1" = "hard" ]
    then
        git fetch --all
        git reset --hard origin/master
    fi

    # Update of the modules
    for modulepath in $(ls mods/*/*/.git | sed 's/\/\.git$//')
    do
        git submodule update $modulepath
    done
    builtin cd $OLDPWD
    source $PEARL_ROOT/pearl
}

