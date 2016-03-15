# This module contains all functionalities needed for
# handling the pearl core system.
#
# Dependencies:
# - lib/utils.sh
# - lib/core/module.sh
#
# vim: ft=sh

GIT=git

function pearl_install(){
    [ -e $PEARL_HOME/.install ] && die "Pearl seems already been installed. Check ${PEARL_HOME}/.install file."
    local PEARL_ROOT=$1
    [ ! -d "$PEARL_ROOT" ] && die "Error: Could not set PEARL_ROOT env because ${PEARL_ROOT} does not exist."

    pearl_logo
    # Shows information system
    echo ""
    command -v uname && uname -m
    cat /etc/*release
    echo ""

    info "Creating $PEARL_HOME directory ..."
    mkdir -p $PEARL_HOME/envs
    mkdir -p $PEARL_HOME/mans
    mkdir -p $PEARL_HOME/etc
    mkdir -p $PEARL_HOME/opt

    echo "# The following line is used to identify the pearl location (do not change it!):" > $PEARL_HOME/.install
    echo "PEARL_ROOT=$PEARL_ROOT" >> $PEARL_HOME/.install
    [ -e $PEARL_HOME/pearlrc ] || echo "#This script is used to override the pearl settings." > $PEARL_HOME/pearlrc
    [ -e $PEARL_HOME/pearlrc.fish ] || echo "#This script is used to override the pearl settings." > $PEARL_HOME/pearlrc.fish
    info "Directory $PEARL_HOME created successfully."

    info ""
    info "In order to have Pearl running at shell startup,"
    info "put the following in your BASH config file:"
    info "echo \"source ${PEARL_ROOT}/pearl\" >> ~/.bashrc"
    info ""
    info "or for ZSH:"
    info "echo \"source ${PEARL_ROOT}/pearl\" >> ~/.zshrc"
    info ""
    info "or for Fish shell:"
    info "echo \"source ${PEARL_ROOT}/pearl.fish\" >> ~/.config/fish/config.fish"
    info ""
    info "Start by checking the list of Pearl modules available:"
    info ">> pearl module list"
    info ""
    info "For more information:"
    info ">> man pearl"
}

function pearl_logo(){
    cat "$PEARL_ROOT/share/logo/logo-ascii.txt"
}

function pearl_remove(){
    cd $PEARL_ROOT
    if ask "Are you sure to REMOVE all the Pearl modules in $PEARL_ROOT folder?" "N"
    then
        for module in $(get_list_installed_modules)
        do
            pearl_module_remove $module
        done
    fi
    if ask "Are you sure to DELETE the Pearl config folder too ($PEARL_HOME folder)?" "N"
    then
       rm -rf $PEARL_HOME
    fi
}

function pearl_update(){
    cd $PEARL_ROOT
    $GIT fetch --all
    $GIT reset --hard origin/master

    for module in $(get_list_installed_modules)
    do
        pearl_module_update $module
    done
}

