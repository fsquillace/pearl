# This module handles the pearl modules

function pearl_module_install_update(){
    function up_help(){
        echo "Usage: pearl_install_update_module <modulename>"
        echo "Install/update git submodules"
    }

    if [ ${#@} -ne 1 ]; then
        echo "pearl_install_update_module: unrecognized options '$@'"
        up_help
        return 128
    fi

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        up_help
        return 0
    fi

    local modulename=$1
    local hook_file=${PEARL_ROOT}/lib/hooks/${modulename}.sh
    [ -f "$hook_file" ] && source "$hook_file"

    OLD_PWD=$(pwd)
    builtin cd $PEARL_ROOT
    type -t pre_install &> /dev/null && pre_install
    git submodule update --init --force --rebase "mods/$modulename"
    type -t post_install &> /dev/null && post_install

    source ${PEARL_ROOT}/pearl
    builtin cd $OLD_PWD

    unset pre_install post_install
    unset pre_uninstall post_uninstall
    return 0
}

function pearl_module_uninstall(){
    function up_help(){
        echo "Usage: pearl_uninstall_module <modulename>"
        echo "Remove git submodule"
    }

    if [ ${#@} -ne 1 ]; then
        echo "pearl_uninstall_module: unrecognized options '$@'"
        up_help
        return 128
    fi

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        up_help
        return 0
    fi

    local modulename=$1

    local hook_file=${PEARL_ROOT}/lib/hooks/${modulename}.sh
    [ -f "$hook_file" ] && source "$hook_file"

    OLD_PWD=$(pwd)
    builtin cd $PEARL_ROOT
    type -t pre_uninstall &> /dev/null && pre_uninstall
    git submodule deinit -f "mods/${modulename}"
    type -t post_uninstall &> /dev/null && post_uninstall

    source ${PEARL_ROOT}/pearl
    #[ -d "mods/${modulename}/" ] && rm -rf "mods/${modulename}/*"
    #[ -d ".git/modules/mods/$modulename" ] && rm -rf ".git/modules/mods/$modulename"
    builtin cd $OLD_PWD

    unset pre_uninstall post_uninstall
    unset pre_install post_install
}

function pearl_module_list(){
    function up_help(){
        echo "Usage: pearl_list_modules <modulename>"
        echo "List git submodules"
    }

    if [ ${#@} -gt 0 ]; then
        echo "pearl_list_modules: unrecognized options '$@'"
        up_help
        return 128
    fi

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        up_help
        return 0
    fi

    builtin cd $PEARL_ROOT
    local modlist=$(git submodule status | awk '{print $2}'  | grep -E ^mods | sed 's/mods\///')
    for module in $modlist
    do
        local installed=""
        [ "$(ls -A mods/${module})" ] && installed="[installed]"
        echo "$module $installed"
    done
    builtin cd $OLDPWD

#    git config --list| grep -E ^submodule
}

