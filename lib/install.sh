#!/bin/bash

function pearl_create_home(){
    if [ -e $PEARL_HOME/pearlrc ]
    then
        source $PEARL_HOME/pearlrc
    else
        pearl_logo
        # Shows informations system
        echo ""
        (uname -m && cat /etc/*release)

        echo ""
        echo "The pearl configurations are not mandatory but they are strongly recommended."
        echo "They consist of vim, bash, readline and ranger file manager and many others configurations made by pearl."
        echo "You can easily change or reset the settings of pearl whenever you want executing:"
        echo ">> pearl_settings"
        echo ""

        pearl_settings

        echo "Creating ~/.config/pearl directory ..."
        mkdir -p $PEARL_HOME/bkp
        mkdir -p $PEARL_HOME/mans
        mkdir -p $PEARL_HOME/etc/context
        mkdir -p $PEARL_HOME/opt

        echo "#!/bin/bash" > $PEARL_HOME/pearlrc
        echo "#This script is used to execute anything you want. " >> $PEARL_HOME/pearlrc
        echo "# Uncomment and type your Dropbox/Ubuntu One home if it's different from ~/Dropbox/:" >> $PEARL_HOME/pearlrc
        echo "#export SYNC_HOME=~/Dropbox/" >> $PEARL_HOME/pearlrc
        chmod +x $PEARL_HOME/pearlrc

        echo ""
        echo "For more information: man pearl"

    fi

}

function pearl_settings(){

# TODO Add the config for ssh, ranger, irssi, mutt, bash_profile

if [ ${#@} -ne 0 ]; then
    echo "pearl_settings: unrecognized options '$@'"
    echo "Usage: pearl_settings"
    return 128
fi

# Config bashrc
grep "source $PEARL_ROOT/pearl" $HOME/.bashrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START pearl when open a new terminal? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PEARL_ROOT/pearl" $HOME/.bashrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE pearl when open a new terminal? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PEARL_ROOT/pearl" $HOME/.bashrc
    fi
fi

# Config vimrc
grep "source $PEARL_ROOT/etc/vimrc" $HOME/.vimrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pearl config vim? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PEARL_ROOT/etc/vimrc" $HOME/.vimrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pearl config vim? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PEARL_ROOT/etc/vimrc" $HOME/.vimrc
    fi
fi

# Config inputrc
grep "\$include $PEARL_ROOT/etc/inputrc" $HOME/.inputrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pearl completion history? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "\$include $PEARL_ROOT/etc/inputrc" $HOME/.inputrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pearl completion history? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "\$include $PEARL_ROOT/etc/inputrc" $HOME/.inputrc
    fi
fi

# Config ranger
grep "exec(open('$PEARL_ROOT/etc/ranger/commands.py').read())" $HOME/.config/ranger/commands.py &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pearl Ranger file manager config? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "exec(open('$PEARL_ROOT/etc/ranger/commands.py').read())" $HOME/.config/ranger/commands.py
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pearl Ranger file manager config? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "exec(open('$PEARL_ROOT/etc/ranger/commands.py').read())" $HOME/.config/ranger/commands.py
    fi
fi

# Config screenrc
grep "source $PEARL_ROOT/etc/screenrc" $HOME/.screenrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pearl config for the screen command? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PEARL_ROOT/etc/screenrc" $HOME/.screenrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pearl config for the screen command? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PEARL_ROOT/etc/screenrc" $HOME/.screenrc
    fi
fi

# Config tmux.conf
grep "source $PEARL_ROOT/etc/tmux.conf" $HOME/.tmux.conf &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pearl config for tmux command? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PEARL_ROOT/etc/tmux.conf" $HOME/.tmux.conf
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pearl config for tmux command? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PEARL_ROOT/etc/tmux.conf" $HOME/.tmux.conf
    fi
fi

# Config Xdefaults
grep "# include \"$PEARL_ROOT/etc/Xdefaults\"" $HOME/.Xdefaults &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the Xdefaults config for the urxvt terminal? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "# include \"$PEARL_ROOT/etc/Xdefaults\"" $HOME/.Xdefaults
    fi
else
    local res=$(confirm_question "Do you want to DELETE the Xdefaults config for the urxvt terminal? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "# include \"$PEARL_ROOT/etc/Xdefaults\"" $HOME/.Xdefaults
    fi
fi

# Config liquidpromptrc
grep "source \"$PEARL_ROOT/etc/liquidpromptrc\"" $HOME/.liquidpromptrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the liquidprompt config? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source \"$PEARL_ROOT/etc/liquidpromptrc\"" $HOME/.liquidpromptrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the liquidpromptrc config? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source \"$PEARL_ROOT/etc/liquidpromptrc\"" $HOME/.liquidpromptrc
    fi
fi

# Config gitconfig
grep "\[include\] path = \"$PEARL_ROOT/etc/gitconfig\"" $HOME/.gitconfig &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the git config? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "[include] path = \"$PEARL_ROOT/etc/gitconfig\"" $HOME/.gitconfig
        cat <<EOF > $HOME/.gitignore
build
eclipse-bin/
.project
.classpath
.coverage
nohup.out
runpy
*.pyc
*.pyo
__pycache__/
.project
.pydevproject
*.swp
EOF
    fi
else
    local res=$(confirm_question "Do you want to DELETE the git config? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "\[include\] path = \"$PEARL_ROOT/etc/gitconfig\"" $HOME/.gitconfig
        [ -f $HOME/.gitignore ] && rm -f $HOME/.gitignore
    fi
fi


}

function pearl_unistall(){
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

    local res=$(confirm_question "Are you sure to DELETE completely Pearl? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        echo "Resetting all the configuration files..."
        # Bash
        unapply "source $PEARL_ROOT/pearl" $HOME/.bashrc
        # Vim
        unapply "source $PEARL_ROOT/etc/vimrc" $HOME/.vimrc
        # Inputrc
        unapply "\$include $PEARL_ROOT/etc/inputrc" $HOME/.inputrc
        # Ranger
        unapply "exec(open('$PEARL_ROOT/etc/ranger/commands.py').read())" $HOME/.config/ranger/commands.py
        # Screenrc
        unapply "source $PEARL_ROOT/etc/screenrc" $HOME/.screenrc
        # XDefautls
        unapply "# include \"$PEARL_ROOT/etc/Xdefaults\"" $HOME/.Xdefaults
        # Gitconfig
        unapply "\[include\] path = \"$PEARL_ROOT/etc/gitconfig\"" $HOME/.gitconfig
        [ -f $HOME/.gitignore ] && rm -f $HOME/.gitignore

        echo "Removing Pearl on the system..."
        rm -rf $PEARL_ROOT
    fi

    local res=$(confirm_question "Are you sure to DELETE the Pearl config folder too ($PEARL_HOME folder)? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
       rm -rf $PEARL_HOME
   fi

}

function pearl_update_modules(){
    function up_help(){
        echo "Usage: pearl_update_modules"
        echo "Init/update git submodule: syntastic,fugitive, etc.."
    }

    if [ ${#@} -gt 0 ]; then
        echo "pearl_update_modules: unrecognized options '$@'"
        up_help
        return 128
    fi

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        up_help
        return 0
    fi

    builtin cd $PEARL_ROOT
    git submodule init
    git submodule update
    builtin cd $OLDPWD
    builtin cd $PEARL_ROOT/etc/vim/bundle/jedi-vim/
    git submodule update --init
    builtin cd $OLDPWD

    return 0
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
    if [ ! -f "$PEARL_INSTALL/current.tar.gz" ]
    then
        wget https://github.com/fsquillace/pearl/archive/current.tar.gz
    fi

    builtin cd $PEARL_INSTALL
    tar xzvf current.tar.gz;
    mv pearl-current $HOME/.pearl;
    md5sum current.tar.gz > $HOME/.pearl/pearl.sum
    cd $HOME;
}

function _pearl_wget_update(){
    builtin cd $PEARL_INSTALL
    wget https://github.com/fsquillace/pearl/archive/current.tar.gz
    oldSum=$(cat $PEARL_ROOT/pearl.sum)
        
    if [ "$(md5sum current.tar.gz)" != "$oldSum" ]
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
    PEARL_INSTALL=$(mktemp -d pearl-XXXXX -p /tmp)
    [ -z $PEARL_ROOT ] && PEARL_ROOT=$HOME/.pearl
    [ -z $PEARL_HOME ] && PEARL_HOME=$HOME/.config/pearl
    pearl_install_update
    rm -rf $PEARL_INSTALL
fi

