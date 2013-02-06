
function pearl_install(){

######################### INSTALLATION STEP ###########################

if [ -e $PEARL_HOME/pearlrc ]
then

    # Checks for updates if pearl was installed from Git
    #if [ -d $PEARL_ROOT/.git ]
    #then
        #builtin cd $PEARL_ROOT
        #git pull origin master
        #builtin cd -
    #fi

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
    mkdir -p $PEARL_HOME/etc

    echo "#!/bin/bash" > $PEARL_HOME/pearlrc
    echo "#This script is used to execute anything you want. " >> $PEARL_HOME/pearlrc
    echo "# Uncomment and type your Dropbox/Ubuntu One home if it's different from ~/Dropbox/:" >> $PEARL_HOME/pearlrc
    echo "#export SYNC_HOME=~/Dropbox/" >> $PEARL_HOME/pearlrc
    chmod +x $PEARL_HOME/pearlrc

    echo ""
    echo "For more information: man pearl"

fi
#####################################################################################################

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

# Config gvimrc
grep "source $PEARL_ROOT/etc/gvimrc" $HOME/.gvimrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pearl config gvim? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PEARL_ROOT/etc/gvimrc" $HOME/.gvimrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pearl config gvim? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PEARL_ROOT/etc/gvimrc" $HOME/.gvimrc
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
        echo "pearl_update: unrecognized options '$@'"
        echo "Usage: pearl_update"
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
        # Gvim
        unapply "source $PEARL_ROOT/etc/gvimrc" $HOME/.gvimrc
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



function pearl_update(){
    if [ ${#@} -ne 0 ]; then
        echo "pearl_update: unrecognized options '$@'"
        echo "Usage: pearl_update"
        return 128
    fi

    if [ -d $PEARL_ROOT/.git ]
    then
        builtin cd $PEARL_ROOT
        git pull
        builtin cd -
    else
        echo "pearl wasn't installed using Git."
        echo "May be it was installed by the package manager of the system."
        echo "Use it if you want to update Pearl."
        return 1
    fi
}



