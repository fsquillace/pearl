# This module handles the pearl modules
#

function pearl_module_install(){
    local modulename=$1
    local hook_file=${PEARL_ROOT}/lib/core/mods/${modulename}/install.sh
    [ -f "$hook_file" ] && source "$hook_file"

    OLD_PWD=$(pwd)
    builtin cd $PEARL_ROOT
    type -t pre_install &> /dev/null && pre_install
    git submodule update --init --force --rebase "mods/$modulename"
    type -t post_install &> /dev/null && post_install

    pearl_set_category $modulename

    source ${PEARL_ROOT}/pearl
    builtin cd $OLD_PWD
}

function pearl_module_update(){
    local modulename=$1
    local hook_file=${PEARL_ROOT}/lib/core/mods/${modulename}/install.sh
    [ -f "$hook_file" ] && source "$hook_file"

    OLD_PWD=$(pwd)
    builtin cd $PEARL_ROOT
    type -t pre_update &> /dev/null && pre_update
    git submodule update --init --force --rebase "mods/$modulename"
    type -t post_update &> /dev/null && post_update

    pearl_set_category $modulename

    builtin cd $OLD_PWD
}

function pearl_set_category(){
    if [ -e $PEARL_ROOT/lib/core/mods/$1/*.vim ]
    then
        apply "source $PEARL_ROOT/lib/core/category/vim/vimrc" "${HOME}/.vimrc"
    fi
}

function pearl_module_uninstall(){
    local modulename=$1

    local hook_file=${PEARL_ROOT}/lib/core/mods/${modulename}/install.sh
    [ -f "$hook_file" ] && source "$hook_file"

    OLD_PWD=$(pwd)
    builtin cd $PEARL_ROOT
    type -t pre_uninstall &> /dev/null && pre_uninstall
    git submodule deinit -f "mods/${modulename}"
    type -t post_uninstall &> /dev/null && post_uninstall

    #[ -d "mods/${modulename}/" ] && rm -rf "mods/${modulename}/*"
    #[ -d ".git/modules/mods/$modulename" ] && rm -rf ".git/modules/mods/$modulename"
    builtin cd $OLD_PWD
}

function pearl_module_list(){
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

