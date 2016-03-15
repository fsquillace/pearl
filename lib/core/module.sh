# This module contains all functionalities needed for
# handling the pearl modules.
#
# Dependencies:
# - lib/utils.sh
#
# vim: ft=sh

GIT=git

declare -A descriptions
descriptions=( \
    ["misc/liquidprompt"]="A full-featured adaptive prompt (https://github.com/nojhan/liquidprompt) [bash][zsh]" \
    ["misc/ls-colors"]="A collection of LS_COLORS definitions (https://github.com/trapd00r/LS_COLORS) [bash][zsh][fish]" \
    ["misc/powerline"]="Powerline is a statusline plugin for vim, zsh, bash, tmux (https://github.com/powerline/powerline)" \
    ["misc/powerline-fonts"]="Patched fonts for Powerline (https://github.com/powerline/fonts)" \
    ["misc/ranger"]="A VIM-inspired filemanager for the console (http://ranger.nongnu.org/)" \
    ["pearl/dotfiles"]="The Pearl dotfiles (https://github.com/fsquillace/pearl-dotfiles)" \
    ["pearl/man"]="Pearl module for snippets from the open source world (https://github.com/fsquillace/pearl-man)" \
    ["pearl/p4merge"]="P4Merge tool for Pearl (https://github.com/fsquillace/pearl-p4merge)" \
    ["pearl/ssh"]="20 lines script that brings dotfiles in a ssh session (https://github.com/fsquillace/pearl-ssh)" \
    ["pearl/utils"]="The Pearl utility functions, aliases etc (https://github.com/fsquillace/pearl-utils)" \
    ["vim/airline"]="Status/tabline for vim (https://github.com/vim-airline/vim-airline)" \
    ["vim/bufexplorer"]="BufExplorer Plugin for Vim (https://github.com/jlanzarotta/bufexplorer)" \
    ["vim/fugitive"]="A Git wrapper so awesome, it should be illegal (https://github.com/tpope/vim-fugitive)" \
    ["vim/gitgutter"]="Shows a git diff (https://github.com/airblade/vim-gitgutter)" \
    ["vim/gnupg"]="Editing of gpg encrypted files (https://github.com/jamessan/vim-gnupg)" \
    ["vim/indentline"]="Display the indention levels with thin vertical lines (https://github.com/Yggdroot/indentLine)" \
    ["vim/jedi"]="jedi autocompletion library (https://github.com/davidhalter/jedi-vim)" \
    ["vim/nerdcommenter"]="Intensely orgasmic commenting (https://github.com/scrooloose/nerdcommenter)" \
    ["vim/nerdtree"]="A tree explorer (https://github.com/scrooloose/nerdtree)" \
    ["vim/python-mode"]="Vim python-mode (https://github.com/klen/python-mode)" \
    ["vim/signify"]="Show a diff (https://github.com/mhinz/vim-signify)" \
    ["vim/solarized"]="Precision colorscheme (https://github.com/altercation/vim-colors-solarized)" \
    ["vim/supertab"]="Perform all your vim insert mode completions with Tab (https://github.com/ervandew/supertab)" \
    ["vim/syntastic"]="Syntax checking hacks (https://github.com/scrooloose/syntastic)" \
    ["vim/zenburn"]="Low-contrast color scheme (https://github.com/jnurmine/Zenburn)" \
)

function pearl_module_install(){
    _pearl_module_install_update $1 pre_install post_install
}

function pearl_module_update(){
    _pearl_module_install_update $1 pre_update post_update
}

function pearl_module_remove(){
    local modulename=$1
    local pre_func=pre_remove
    local post_func=post_remove

    _init_module $modulename $pre_func $post_func

    builtin cd $PEARL_ROOT
    type -t $pre_func &> /dev/null && $pre_func
    $GIT submodule deinit -f "mods/${modulename}"
    type -t $post_func &> /dev/null && $post_func

    _unset_category $modulename
    _deinit_module $modulename $pre_func $post_func
}

function _pearl_module_install_update(){
    local modulename=$1
    local pre_func=$2
    local post_func=$3

    _init_module $modulename $pre_func $post_func

    builtin cd $PEARL_ROOT
    type -t $pre_func &> /dev/null && $pre_func
    $GIT submodule update --init --force --rebase "mods/$modulename"
    type -t $post_func &> /dev/null && $post_func

    _set_category $modulename
    _deinit_module $modulename $pre_func $post_func
}

function _init_module(){
    local modulename=$1
    local pre_func=$2
    local post_func=$3

    unset ${pre_func} ${post_func}
    local hook_file=${PEARL_ROOT}/lib/core/mods/${modulename}/install.sh
    [ -f "$hook_file" ] && source "$hook_file"
    return 0
}

function _deinit_module(){
    local modulename=$1
    local pre_func=$2
    local post_func=$3
    unset ${pre_func} ${post_func}
}

function _set_category(){
    _set_vim_category $1
}

function _set_vim_category(){
    if [ -e $PEARL_ROOT/lib/core/mods/$1/*.vim ]
    then
        apply "source $PEARL_ROOT/lib/core/category/vim/vimrc" "${HOME}/.vimrc"
    fi
}

function _unset_category(){
    _unset_vim_category $1
}

# Unset a category only if there are no mods for that category
function _unset_vim_category(){
    for module in $(get_list_installed_modules)
    do
        [ -e $PEARL_ROOT/lib/core/mods/$module/*.vim ] && return
    done
    unapply "source $PEARL_ROOT/lib/core/category/vim/vimrc" "${HOME}/.vimrc"
}

function pearl_module_list(){
    local pattern=".*"
    [ -z "$1" ] || pattern="$1"
    builtin cd $PEARL_ROOT
    for module in $(get_list_removed_modules $pattern)
    do
        _print_module $module false
    done
    for module in $(get_list_installed_modules $pattern)
    do
        _print_module $module true
    done
    builtin cd $OLDPWD
}

function get_list_installed_modules(){
    local pattern=$1
    $GIT submodule status | grep -v "^-" | cut -d' ' -f3 | sed -e 's/^mods\///' | grep "$pattern"
}

function get_list_removed_modules(){
    local pattern=$1
    $GIT submodule status | grep "^-" | cut -d' ' -f2 | sed -e 's/^mods\///' | grep "$pattern"
}

function _print_module() {
    local module=$1
    local installed=""
    $2 && installed="[installed]"
    local module_array=(${module//\// })
    local category=${module_array[0]}
    local modulename=${module_array[1]}
    bold_red
    echo -n "$category/"
    bold_white
    echo -n "$modulename "
    bold_cyan
    echo "$installed"
    normal
    echo "    ${descriptions[$module]}"
}
