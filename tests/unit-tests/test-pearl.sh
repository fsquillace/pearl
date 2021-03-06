#!/bin/bash
source "$(dirname $0)/utils.sh"

# Set PEARL_ROOT before the pearl script so that
# the ENABLE_SIGNAL will be enabled
PEARL_ROOT="$(dirname $0)/../.."
source $PEARL_ROOT/bin/pearl -h &> /dev/null

# Disable the exiterr
set +e

function oneTimeSetUp(){
    setUpUnitTests
}

function setUp(){
:
}

function tearDown(){
:
}

## Mock functions ##
KILL_CMD=kill_mock

function kill_mock() {
    echo "kill $@"
}

function usage(){
    echo "usage"
}

function pearl_install(){
    echo "pearl_install $@"
}

function pearl_update(){
    echo "pearl_update"
}

function pearl_remove(){
    echo "pearl_remove"
}

function pearl_module_install(){
    echo "pearl_module_install $@"
}

function pearl_module_update(){
    echo "pearl_module_update $@"
}

function pearl_module_remove(){
    echo "pearl_module_remove $@"
}

function pearl_module_list(){
    echo "pearl_module_list $@"
}

function pearl_wrap(){
    parse_arguments "$@"
    check_cli
    execute_operation
}

function test_help(){
    assertCommandSuccess pearl_wrap -h
    assertEquals "usage" "$(cat $STDOUTF)"
    assertCommandSuccess pearl_wrap --help
    assertEquals "usage" "$(cat $STDOUTF)"
}

function test_pearl_install(){
    assertCommandSuccess pearl_wrap install
    assertEquals "$(outputWithKill "pearl_install $PEARL_ROOT")" "$(cat $STDOUTF)"
}

function test_pearl_update(){
    assertCommandSuccess pearl_wrap update
    assertEquals "$(outputWithKill "pearl_update")" "$(cat $STDOUTF)"
}

function test_pearl_remove(){
    assertCommandSuccess pearl_wrap remove
    assertEquals "pearl_remove" "$(cat $STDOUTF)"
}
function outputWithKill(){
    echo -e "$@\nkill -USR1 $PPID"
}

function test_pearl_module_install(){
    assertCommandSuccess pearl_wrap install vim/fugitive misc/ranger
    assertEquals "$(outputWithKill "pearl_module_install vim/fugitive\npearl_module_install misc/ranger")" "$(cat $STDOUTF)"
}

function test_pearl_module_install_already_installed(){
    pearl_module_install(){
        [ "$1" == "misc/ranger" ] && return 1
        echo "pearl_module_install $@"
        return 0
    }
    assertCommandFail pearl_wrap install vim/fugitive misc/ranger
    assertEquals "$(outputWithKill "pearl_module_install vim/fugitive")" "$(cat $STDOUTF)"
}

function test_pearl_module_update(){
    assertCommandSuccess pearl_wrap update vim/fugitive misc/ranger
    assertEquals "$(outputWithKill "pearl_module_update vim/fugitive\npearl_module_update misc/ranger")" "$(cat $STDOUTF)"
}

function test_pearl_module_update_not_installed(){
    pearl_module_update(){
        [ "$1" == "misc/ranger" ] && return 1
        echo "pearl_module_update $@"
        return 0
    }
    assertCommandFail pearl_wrap update vim/fugitive misc/ranger
    assertEquals "$(outputWithKill "pearl_module_update vim/fugitive")" "$(cat $STDOUTF)"
}

function test_pearl_module_remove(){
    assertCommandSuccess pearl_wrap remove vim/fugitive misc/ranger
    assertEquals "$(outputWithKill "pearl_module_remove vim/fugitive\npearl_module_remove misc/ranger")" "$(cat $STDOUTF)"
}

function test_pearl_module_remove_not_installed(){
    pearl_module_remove(){
        [ "$1" == "misc/ranger" ] && return 1
        echo "pearl_module_remove $@"
        return 0
    }
    assertCommandFail pearl_wrap remove vim/fugitive misc/ranger
    assertEquals "$(outputWithKill "pearl_module_remove vim/fugitive")" "$(cat $STDOUTF)"
}

function test_pearl_module_list(){
    assertCommandSuccess pearl_wrap list
    assertEquals "pearl_module_list " "$(cat $STDOUTF)"
}

function test_pearl_module_search(){
    assertCommandSuccess pearl_wrap search vim
    assertEquals "pearl_module_list vim" "$(cat $STDOUTF)"
}

function test_check_cli(){
    assertCommandFail pearl_wrap -b
    assertCommandFail pearl_wrap wrong_arg
    assertCommandFail pearl_wrap -h install
}

source $(dirname $0)/shunit2
