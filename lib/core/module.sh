# This module handles the pearl modules
#

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
    local pattern=".*"
    [ -z "$1" ] || pattern="$1"
    builtin cd $PEARL_ROOT
    local modlist=$(git submodule status | grep "^-" | cut -d' ' -f2 | sed -e 's/^mods\///' | grep "$pattern")
    for module in $modlist
    do
        _pearl_module_print $module false
    done
    local modlist=$(git submodule status | grep -v "^-" | cut -d' ' -f3 | sed -e 's/^mods\///' | grep "$pattern")
    for module in $modlist
    do
        _pearl_module_print $module true
    done
    builtin cd $OLDPWD
}

function _pearl_module_print() {
    local module=$1
    local installed=""
    $2 && installed="[installed]"
    info "$module $installed"
    echo "    ${descriptions[$module]}"
}
