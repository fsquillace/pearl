
function pyshell_install(){

######################### INSTALLATION STEP ###########################

if [ -e $PYSHELL_HOME ]
then

    # Checks for updates if pyshell was installed from Git
    #if [ -d $PYSHELL_ROOT/.git ]
    #then
        #builtin cd $PYSHELL_ROOT
        #git pull origin master
        #builtin cd -
    #fi

    source $PYSHELL_HOME/pyshellrc
else

    pyshell_logo

    # Shows informations system
    echo ""
    (uname -m && cat /etc/*release) | xargs

    echo ""
    echo "The pyshell configurations are not mandatory but they are strongly recommended."
    echo "They consist of vim, bash, readline and ranger file manager configurations made by pyshell."
    echo "You can easily change or reset the settings of pyshell whenever you want executing:"
    echo ">> pyshell_settings"
    echo ""

    pyshell_settings

    echo "Creating ~/.config/pyshell directory ..."
    mkdir -p $PYSHELL_HOME/bkp
    mkdir -p $PYSHELL_HOME/etc

    echo "#!/bin/bash" > $PYSHELL_HOME/pyshellrc
    echo "#This script is used to execute anything you want. " >> $PYSHELL_HOME/pyshellrc
    echo "# Uncomment and type your Dropbox/Ubuntu One home if it's different from ~/Dropbox/:" >> $PYSHELL_HOME/pyshellrc
    echo "#export SYNC_HOME=~/Dropbox/" >> $PYSHELL_HOME/pyshellrc
    chmod +x $PYSHELL_HOME/pyshellrc

    echo "For more information: man pyshell"

fi
#####################################################################################################

}

function pyshell_settings(){

# TODO Add the config for ssh, ranger, irssi, mutt, bash_profile

if [ ${#@} -ne 0 ]; then
    echo "pyshell_settings: unrecognized options '$@'"
    echo "Usage: pyshell_settings"
    return 128
fi

# Config bashrc
grep "source $PYSHELL_ROOT/pyshell" $HOME/.bashrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START pyshell when open a new terminal? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PYSHELL_ROOT/pyshell" $HOME/.bashrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE pyshell when open a new terminal? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PYSHELL_ROOT/pyshell" $HOME/.bashrc
    fi
fi

# Config vimrc
grep "source $PYSHELL_ROOT/etc/vimrc" $HOME/.vimrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pyshell config vim? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PYSHELL_ROOT/etc/vimrc" $HOME/.vimrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pyshell config vim? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PYSHELL_ROOT/etc/vimrc" $HOME/.vimrc
    fi
fi

# Config gvimrc
grep "source $PYSHELL_ROOT/etc/gvimrc" $HOME/.gvimrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pyshell config gvim? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PYSHELL_ROOT/etc/gvimrc" $HOME/.gvimrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pyshell config gvim? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PYSHELL_ROOT/etc/gvimrc" $HOME/.gvimrc
    fi
fi

# Config inputrc
grep "\$include $PYSHELL_ROOT/etc/inputrc" $HOME/.inputrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pyshell completion history? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "\$include $PYSHELL_ROOT/etc/inputrc" $HOME/.inputrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pyshell completion history? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "\$include $PYSHELL_ROOT/etc/inputrc" $HOME/.inputrc
    fi
fi

# Config ranger
grep "exec(open('$PYSHELL_ROOT/etc/ranger/commands.py').read())" $HOME/.config/ranger/commands.py &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pyshell Ranger file manager config? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "exec(open('$PYSHELL_ROOT/etc/ranger/commands.py').read())" $HOME/.config/ranger/commands.py
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pyshell Ranger file manager config? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "exec(open('$PYSHELL_ROOT/etc/ranger/commands.py').read())" $HOME/.config/ranger/commands.py
    fi
fi

# Config screenrc
grep "source $PYSHELL_ROOT/etc/screenrc" $HOME/.screenrc &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the pyshell config for the screen command? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "source $PYSHELL_ROOT/etc/screenrc" $HOME/.screenrc
    fi
else
    local res=$(confirm_question "Do you want to DELETE the pyshell config for the screen command? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "source $PYSHELL_ROOT/etc/screenrc" $HOME/.screenrc
    fi
fi

# Config Xdefaults
grep "# include \"$PYSHELL_ROOT/etc/Xdefaults\"" $HOME/.Xdefaults &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the Xdefaults config for the urxvt terminal? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "# include \"$PYSHELL_ROOT/etc/Xdefaults\"" $HOME/.Xdefaults
    fi
else
    local res=$(confirm_question "Do you want to DELETE the Xdefaults config for the urxvt terminal? (y/N)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ]; then
        unapply "# include \"$PYSHELL_ROOT/etc/Xdefaults\"" $HOME/.Xdefaults
    fi
fi

# Config gitconfig
grep "\[include\] path = \"$PYSHELL_ROOT/etc/gitconfig\"" $HOME/.gitconfig &> /dev/null
if [ "$?" != "0" ]
then
    local res=$(confirm_question "Do you want to START the git config? (Y/n)> ")

    if [ "$res" == "y" ] || [ "$res" == "Y" ] || [ "$res" == "" ]; then
        apply "[include] path = \"$PYSHELL_ROOT/etc/gitconfig\"" $HOME/.gitconfig
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
        unapply "\[include\] path = \"$PYSHELL_ROOT/etc/gitconfig\"" $HOME/.gitconfig
        [ -f $HOME/.gitignore ] && rm -f $HOME/.gitignore
    fi
fi


}

function pyshell_update(){
    if [ ${#@} -ne 0 ]; then
        echo "pyshell_update: unrecognized options '$@'"
        echo "Usage: pyshell_update"
        return 128
    fi

    if [ -d $PYSHELL_ROOT/.git ]
    then
        builtin cd $PYSHELL_ROOT
        git pull
        builtin cd -
    else
        echo "PyShell wasn't installed using Git."
        echo "May be it was installed by the package manager of the system."
        echo "Use it if you want to update Pyshell."
        return 1
    fi
}



