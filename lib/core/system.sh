#!/bin/bash

function pearl_install(){
    [ -e $PEARL_HOME/.install ] && die "Pearl seems already been installed. Check ${PEARL_HOME}/.install file."
    PEARL_ROOT=$1

    pearl_logo
    # Shows information system
    echo ""
    command -v uname && uname -m
    cat /etc/*release
    echo ""

    info "The pearl configurations are not mandatory but they are strongly recommended."
    info "They consist of vim, bash, readline and much more made by pearl."
    info "You can easily change or reset the settings of pearl whenever you want executing:"
    info ">> pearl module install dotfiles"
    info ">> pearl-dotfiles list"
    info ">> pearl-dotfiles enable <configname>"
    info ""
    info "In order to have pearl at shell startup,"
    info "put the following in your bash/zsh config file:"
    info "source ${PEARL_ROOT}/pearl"
    info ""
    info "or for fish shell:"
    info "source ${PEARL_ROOT}/pearl.fish"
    info ""
    info "For more information: man pearl"

    info "Creating $PEARL_HOME directory ..."
    mkdir -p $PEARL_HOME/envs
    mkdir -p $PEARL_HOME/mans
    mkdir -p $PEARL_HOME/etc
    mkdir -p $PEARL_HOME/opt

    echo "# The following line is used to identify the pearl location (do not change it!):" > $PEARL_HOME/.install
    echo "export PEARL_ROOT=$PEARL_ROOT" >> $PEARL_HOME/.install

   [ -e $PEARL_HOME/pearlrc ] || echo "#This script is used to override the pearl settings." > $PEARL_HOME/pearlrc
   [ -e $PEARL_HOME/pearlrc.fish ] || echo "#This script is used to override the pearl settings." > $PEARL_HOME/pearlrc.fish
   info "Directory $PEARL_HOME created successfully."

}

function pearl_logo(){
cat "$PEARL_ROOT/share/logo/logo-ascii.txt"
}

function pearl_uninstall(){
    builtin cd $PEARL_ROOT
    #if ask "Are you sure to UNINSTALL all the Pearl modules in $PEARL_ROOT folder?" "N"
    #then
        #for module in $(git submodule status | grep -v "^-" | cut -d' ' -f3 | sed -e 's/^mods\///')
        #do
            #pearl_module_uninstall $module
        #done
    #fi
    if ask "Are you sure to DELETE the Pearl config folder too ($PEARL_HOME folder)?" "N"
    then
       rm -rf $PEARL_HOME
   fi
    builtin cd $OLDPWD
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
}

