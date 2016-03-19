#!/bin/bash
source "$(dirname $0)/utils.sh"

source "$(dirname $0)/../../lib/utils.sh"
source "$(dirname $0)/../../lib/core/module.sh"

# Disable the exiterr
set +e

function oneTimeSetUp(){
    setUpUnitTests
}

function setUp(){
    pearlSetUp
}

function tearDown(){
    pearlTearDown
    unset GIT
    [ -e $HOME/.vimrc ] && rm $HOME/.vimrc
    return 0
}

function scenario_misc_mods(){
    mkdir -p $PEARL_ROOT/lib/core/mods/pearl/utils
    mkdir -p $PEARL_ROOT/lib/core/mods/pearl/ssh
    mkdir -p $PEARL_ROOT/lib/core/mods/misc/ls-colors
    GIT=git_misc_mods_mock
}

function scenario_two_vim_mods(){
    mkdir -p $PEARL_ROOT/lib/core/mods/vim/fugitive
    touch $PEARL_ROOT/lib/core/mods/vim/fugitive/config.vim
    scenario_one_vim_mod
    GIT=git_two_vim_mods_mock
}

function scenario_one_vim_mod(){
    mkdir -p $PEARL_ROOT/lib/core/mods/vim/gutter
    touch $PEARL_ROOT/lib/core/mods/vim/gutter/config.vim
    echo "source $PEARL_ROOT/lib/core/category/vim/vimrc" > $HOME/.vimrc
    GIT=git_one_vim_mod_mock
}

function git_two_vim_mods_mock(){
    case "$2" in
        "status") git_status_two_vim_mods_mock $@ ;;
        "update") git_install_mock $@ ;;
        "deinit") git_remove_mock $@ ;;
    esac
}

function git_one_vim_mod_mock(){
    case "$2" in
        "status") git_status_one_vim_mod_mock $@ ;;
        "update") git_install_mock $@ ;;
        "deinit") git_remove_mock $@ ;;
    esac
}

function git_misc_mods_mock(){
    case "$2" in
        "status") git_status_misc_mods_mock $@ ;;
        "update") git_install_mock $@ ;;
        "deinit") git_remove_mock $@ ;;
    esac
}

function git_status_misc_mods_mock(){
    echo "-dbe3c15026afdb8b35d5a758081fdf7c2c860ad0 mods/pearl/utils"
    echo " 06ccb64c5a8721012c5c9af5b46977d2e456b47e mods/misc/ls-colors (remotes/origin/HEAD)"
    echo " 6f9cb1bb29e65e69200161217175e79b28b4e422 mods/pearl/ssh (remotes/origin/HEAD)"
}

function git_status_two_vim_mods_mock(){
    echo " 6f9cb1bb29e65e69200161217175e79b28b4e422 mods/vim/fugitive (remotes/origin/HEAD)"
    git_status_one_vim_mod_mock
}

function git_status_one_vim_mod_mock(){
    echo "-6f9cb1bb29e65e69200161217175e79b28b4e422 mods/vim/gutter (remotes/origin/HEAD)"
}

function git_install_mock(){
    echo "$@" | grep -q "update"
    assertEquals 0 $?
}

function git_remove_mock(){
    echo "$@" | grep -q "deinit"
    assertEquals 0 $?
}


function get_pre_remove_func(){
    cat <<EOF
function pre_remove(){
    assertEquals $PEARL_ROOT \${PWD}
    echo "pre_remove"
}
EOF
}

function get_post_remove_func(){
    cat <<EOF
function post_remove(){
    assertEquals $PEARL_ROOT \${PWD}
    echo "post_remove"
}
EOF
}

function get_pre_install_func(){
    cat <<EOF
function pre_install(){
    assertEquals $PEARL_ROOT \${PWD}
    echo "pre_install"
}
EOF
}

function get_post_install_func(){
    cat <<EOF
function post_install(){
    assertEquals $PEARL_ROOT \${PWD}
    echo "post_install"
}
EOF
}

function get_pre_update_func(){
    cat <<EOF
function pre_update(){
    assertEquals $PEARL_ROOT \${PWD}
    echo "pre_update"
}
EOF
}

function get_post_update_func(){
    cat <<EOF
function post_update(){
    assertEquals $PEARL_ROOT \${PWD}
    echo "post_update"
}
EOF
}

function get_install(){
    local modulename=$1
    local install_content=$(cat <<EOF
$(get_pre_install_func)

$(get_post_install_func)

$(get_pre_update_func)

$(get_post_update_func)

$(get_pre_remove_func)

$(get_post_remove_func)
EOF
)
    echo "$install_content" > $PEARL_ROOT/lib/core/mods/${modulename}/install.sh
}

function get_install_post_install_only(){
    local modulename=$1
    install_content=$(cat <<EOF
$(get_post_install_func)
EOF
)
    echo "$install_content" > $PEARL_ROOT/lib/core/mods/${modulename}/install.sh
}

function get_install_pre_install_only(){
    local modulename=$1
    install_content=$(cat <<EOF
$(get_pre_install_func)
EOF
)
    echo "$install_content" > $PEARL_ROOT/lib/core/mods/${modulename}/install.sh
}

function get_remove_post_remove_only(){
    local modulename=$1
    install_content=$(cat <<EOF
$(get_post_remove_func)
EOF
)
    echo "$install_content" > $PEARL_ROOT/lib/core/mods/${modulename}/install.sh
}

function get_remove_pre_remove_only(){
    local modulename=$1
    install_content=$(cat <<EOF
$(get_pre_remove_func)
EOF
)
    echo "$install_content" > $PEARL_ROOT/lib/core/mods/${modulename}/install.sh
}

function get_update_post_update_only(){
    local modulename=$1
    install_content=$(cat <<EOF
$(get_post_update_func)
EOF
)
    echo "$install_content" > $PEARL_ROOT/lib/core/mods/${modulename}/install.sh
}

function get_update_pre_update_only(){
    local modulename=$1
    install_content=$(cat <<EOF
$(get_pre_update_func)
EOF
)
    echo "$install_content" > $PEARL_ROOT/lib/core/mods/${modulename}/install.sh
}

function test_pearl_module_list_empty_pattern(){
    scenario_misc_mods
    local out=$(pearl_module_list "")
    echo $out | grep -qE "pearl.*utils"
    assertEquals 0 $?
    echo $out | grep -qE "pearl.*ssh .*[installed]"
    assertEquals 0 $?
    echo $out | grep -qE "misc.*ls-colors .*[installed]"
    assertEquals 0 $?
}

function test_pearl_module_list_matching(){
    scenario_misc_mods
    local out=$(pearl_module_list "pearl")
    echo $out | grep -qE "pearl.*utils"
    assertEquals 0 $?
    echo $out | grep -qE "pearl.*ssh .*[installed]"
    assertEquals 0 $?
    echo $out | grep -qEv "misc.*ls-colors .*[installed]"
    assertEquals 0 $?
}


function test_pearl_module_list_not_matching(){
    scenario_misc_mods
    local out=$(pearl_module_list "blahblah")
    echo $out | grep -qE "pearl.*utils"
    assertEquals 1 $?
    echo $out | grep -qE "pearl.*ssh .*[installed]"
    assertEquals 1 $?
    echo $out | grep -qE "misc.*ls-colors .*[installed]"
    assertEquals 1 $?
}

function test_pearl_module_install(){
    scenario_misc_mods
    get_install "pearl/utils"
    assertCommandSuccess pearl_module_install "pearl/utils"
    cat $STDOUTF | grep -q "pre_install"
    assertEquals 0 $?
    cat $STDOUTF | grep -q "post_install"
    assertEquals 0 $?

    pearl_module_install "pearl/utils" > /dev/null
    type -t pre_install
    assertEquals 1 $?
    type -t post_install
    assertEquals 1 $?
}

function test_pearl_module_install_already_installed(){
    scenario_misc_mods
    get_install "misc/ls-colors"
    assertCommandFail pearl_module_install "misc/ls-colors"
}

function test_pearl_module_install_no_install_file(){
    scenario_misc_mods
    assertCommandSuccess pearl_module_install "pearl/utils"
    cat $STDOUTF | grep -q "pre_install"
    assertEquals 1 $?
    cat $STDOUTF | grep -q "post_install"
    assertEquals 1 $?
}

function test_pearl_module_install_post_install_only(){
    scenario_misc_mods
    get_install_post_install_only "pearl/utils"
    assertCommandSuccess pearl_module_install "pearl/utils"
    cat $STDOUTF | grep -qv "pre_install"
    assertEquals 0 $?
    cat $STDOUTF | grep -q "post_install"
    assertEquals 0 $?
}

function test_pearl_module_install_pre_install_only(){
    scenario_misc_mods
    get_install_pre_install_only "pearl/utils"
    assertCommandSuccess pearl_module_install "pearl/utils"
    cat $STDOUTF | grep -q "pre_install"
    assertEquals 0 $?
    cat $STDOUTF | grep -qv "post_install"
    assertEquals 0 $?
}

function test_pearl_module_install_no_install(){
    scenario_misc_mods
    echo "" > $PEARL_ROOT/lib/core/mods/pearl/utils/install.sh
    assertCommandSuccess pearl_module_install "pearl/utils"
    assertEquals "" "$(cat "$STDOUTF")"
}

function test_pearl_module_remove(){
    scenario_misc_mods
    local modulename="misc/ls-colors"
    get_install $modulename
    assertCommandSuccess pearl_module_remove $modulename
    cat "$STDOUTF" | grep -q "pre_remove"
    assertEquals 0 $?
    cat "$STDOUTF" | grep -q "post_remove"
    assertEquals 0 $?

    pearl_module_remove $modulename > /dev/null
    type -t pre_remove
    assertEquals 1 $?
    type -t post_remove
    assertEquals 1 $?
}

function test_pearl_module_remove_not_installed(){
    scenario_misc_mods
    local modulename="pearl/utils"
    get_install $modulename
    assertCommandFail pearl_module_remove $modulename
}

function test_pearl_module_remove_no_install(){
    scenario_misc_mods
    local modulename="misc/ls-colors"
    echo "" > $PEARL_ROOT/lib/core/mods/pearl/utils/install.sh
    assertCommandSuccess pearl_module_remove $modulename
    assertEquals "" "$(cat "$STDOUTF")"
}

function test_pearl_module_remove_post_remove_only(){
    scenario_misc_mods
    local modulename="misc/ls-colors"
    get_remove_post_remove_only $modulename
    assertCommandSuccess pearl_module_remove $modulename
    cat "$STDOUTF" | grep -qv "pre_remove"
    assertEquals 0 $?
    cat "$STDOUTF" | grep -q "post_remove"
    assertEquals 0 $?
}

function test_pearl_module_remove_pre_remove_only(){
    scenario_misc_mods
    local modulename="misc/ls-colors"
    get_remove_pre_remove_only $modulename
    assertCommandSuccess pearl_module_remove $modulename
    cat "$STDOUTF" | grep -q "pre_remove"
    assertEquals 0 $?
    cat "$STDOUTF" | grep -qv "post_remove"
    assertEquals 0 $?
}

function test_pearl_module_update(){
    scenario_misc_mods
    local modulename="misc/ls-colors"
    get_install $modulename
    assertCommandSuccess pearl_module_update $modulename
    cat "$STDOUTF" | grep -q "pre_update"
    assertEquals 0 $?
    cat "$STDOUTF" | grep -q "post_update"
    assertEquals 0 $?

    pearl_module_update $modulename > /dev/null
    type -t pre_update
    assertEquals 1 $?
    type -t post_update
    assertEquals 1 $?
}

function test_pearl_module_update_not_installed(){
    scenario_misc_mods
    local modulename="pearl/utils"
    get_install $modulename
    assertCommandFail pearl_module_update $modulename
}

function test_pearl_module_update_no_install(){
    scenario_misc_mods
    local modulename="misc/ls-colors"
    echo "" > $PEARL_ROOT/lib/core/mods/pearl/utils/install.sh
    assertCommandSuccess pearl_module_update $modulename
    assertEquals "" "$(cat "$STDOUTF")"
}

function test_pearl_module_update_post_update_only(){
    scenario_misc_mods
    local modulename="misc/ls-colors"
    get_update_post_update_only $modulename
    assertCommandSuccess pearl_module_update $modulename
    cat "$STDOUTF" | grep -qv "pre_update"
    assertEquals 0 $?
    cat "$STDOUTF" | grep -q "post_update"
    assertEquals 0 $?
}

function test_pearl_module_update_pre_update_only(){
    scenario_misc_mods
    local modulename="misc/ls-colors"
    get_update_pre_update_only $modulename
    assertCommandSuccess pearl_module_update $modulename
    cat "$STDOUTF" | grep -q "pre_update"
    assertEquals 0 $?
    cat "$STDOUTF" | grep -qv "post_update"
    assertEquals 0 $?
}

function test_set_category(){
    scenario_two_vim_mods
    assertCommandSuccess _set_category "vim/fugitive"
    cat $HOME/.vimrc | grep -q "source $PEARL_ROOT/lib/core/category/vim/vimrc"
    assertEquals 0 $?
    rm $PEARL_ROOT/lib/core/mods/vim/fugitive/config.vim
}

function test_set_category_no_category(){
    scenario_misc_mods
    assertCommandSuccess _set_category "vim/fugitive"
    [ ! -e $HOME/.vimrc ]
    assertEquals 0 $?
}

function test_unset_category(){
    scenario_one_vim_mod
    assertCommandSuccess _set_category "vim/gutter"
    cat $HOME/.vimrc | grep -qv "source $PEARL_ROOT/lib/core/category/vim/vimrc"
    assertEquals 0 $?
}

function test_unset_category_with_two_vim_mods(){
    scenario_two_vim_mods
    assertCommandSuccess _set_category "vim/gutter"
    cat $HOME/.vimrc | grep -q "source $PEARL_ROOT/lib/core/category/vim/vimrc"
    assertEquals 0 $?
}

source $(dirname $0)/shunit2
