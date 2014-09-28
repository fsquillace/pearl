#!/bin/bash

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

function pearl_install(){
    git_command=$(which git);

    if [ "$git_command" != "" ];
    then
        git clone git://github.com/fsquillace/pearl $PEARL_ROOT;
    else
        _pearl_wget_install
    fi
}


function _pearl_git_update(){
    git_command=$(which git);
    builtin cd $PEARL_ROOT
    if [ "$1" = "soft"  ]
    then
        git pull
    elif [ "$1" = "" ] || [ "$1" = "hard" ]
    then
        git fetch --all
        git reset --hard origin/master
    fi
    builtin cd $OLDPWD

}

function _pearl_wget_install(){
    local pearl_install=$(mktemp -d pearl-XXXXX -p /tmp)
    builtin cd $pearl_install
    wget -q https://github.com/fsquillace/pearl/archive/current.tar.gz
    tar xzvf current.tar.gz;

    mv pearl-current $PEARL_ROOT
    md5sum current.tar.gz > $PEARL_ROOT/pearl.sum
    cd $PEARL_ROOT;
    rm -rf $pearl_install
}

function _pearl_wget_update(){
    newSum=$(wget -q -O - https://github.com/fsquillace/pearl/archive/current.tar.gz | md5sum)
    oldSum=$(cat $PEARL_ROOT/pearl.sum)
        
    if [ "$newSum" != "$oldSum" ]
    then
        _pearl_wget_install
    fi
}

function pearl_update(){
    function up_help(){
        echo "Usage: pearl_update [soft/hard]"
        echo "hard (default): overwrite the changes you might have done in pearl folder"
        echo "soft: try to merge with the changes you made. In case of conflict it raises an error."
    }

    if [ ${#@} -gt 1 ]; then
        echo "pearl_update: unrecognized options '$@'"
        up_help
        return 128
    fi

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        up_help
        return 0
    fi

    git_command=$(which git);
    if [ "$git_command" != "" ] && [ -d "$PEARL_ROOT/.git" ];
    then
        _pearl_git_update $1
        source $PEARL_ROOT/pearl
    elif [ -f "$PEARL_ROOT/pearl.sum" ]
    then
        _pearl_wget_update
        source $PEARL_ROOT/pearl
    else
        echo "pearl wasn't installed using either wget or Git."
        echo "May be it was installed by the package manager of the system."
        echo "Use it if you want to update Pearl."
        return 1
    fi

    return 0
}


# This function is able to install/update pearl
# with either git or wget
function pearl_install_update(){
if [ -d $PEARL_ROOT ];
then
    pearl_update
else
    pearl_install
fi
}


if [ "${BASH_ARGV}" == "" ]; then
    # If pearl is not installed, install it to HOME
    # and ensure the user has the right permissions
    if [ -z $PEARL_ROOT ]
    then
        PEARL_ROOT=$HOME/.pearl
        if [ ! -x $HOME ];
        then
            echo "Home folder doesn't exist. Creating it!";
            sudo mkdir $HOME;
            sudo chown $HOME;
        fi;
    fi
    [ -z $PEARL_HOME ] && PEARL_HOME=$HOME/.config/pearl
    pearl_install_update
fi

