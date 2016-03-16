#!/bin/bash
source "$(dirname $0)/utils.sh"

source "$(dirname $0)/../lib/utils.sh"
source "$(dirname $0)/../lib/core/module.sh"
source "$(dirname $0)/../lib/core/system.sh"

# Disable the exiterr
set +e

OLD_PWD=$PWD

function oneTimeSetUp(){
    setUpUnitTests
}

function setUp(){
    PEARL_ROOT=/tmp/pearl-test-dir
    mkdir -p $PEARL_ROOT/share/logo/
    touch  $PEARL_ROOT/share/logo/logo-ascii.txt
    HOME=/tmp/pearl-test-home-dir
    mkdir -p $HOME
    PEARL_HOME=/tmp/pearl-test-dir/.config/pearl
    mkdir -p $PEARL_HOME
}

function tearDown(){
    cd $OLD_PWD
    rm -rf $PEARL_HOME
    rm -rf $HOME
    rm -rf $PEARL_ROOT
}

function test_pearl_install_already_existing(){
    touch $PEARL_HOME/.install
    assertCommandFail pearl_install $PEARL_ROOT
}

function test_pearl_install_not_existing_directory(){
    assertCommandFail pearl_install /tmp/not-existing-dirctory
}

function test_pearl_install(){
    assertCommandSuccess pearl_install $PEARL_ROOT
    cat $STDERRF
    [ -d $PEARL_HOME/envs ]
    assertEquals 0 $?
    [ -d $PEARL_HOME/mans ]
    assertEquals 0 $?
    [ -d $PEARL_HOME/etc ]
    assertEquals 0 $?
    [ -d $PEARL_HOME/opt ]
    assertEquals 0 $?

    [ -e $PEARL_HOME/.install ]
    assertEquals 0 $?
    cat $PEARL_HOME/.install | grep -q "PEARL_ROOT=$PEARL_ROOT"
    assertEquals 0 $?

    [ -e $PEARL_HOME/pearlrc ]
    assertEquals 0 $?
    [ -e $PEARL_HOME/pearlrc.fish ]
    assertEquals 0 $?
}

function test_pearl_install_existing_pearlrc(){
    echo "exist" > $PEARL_HOME/pearlrc
    echo "exist" > $PEARL_HOME/pearlrc.fish
    assertCommandSuccess pearl_install $PEARL_ROOT

    grep -q "exist" $PEARL_HOME/pearlrc
    assertEquals 0 $?
    grep -q "exist" $PEARL_HOME/pearlrc.fish
    assertEquals 0 $?
}

function test_pearl_update(){
    git_mock(){
        [ $1 != "submodule" ] && return
        if [ $2 == "status" ]
        then
            echo "-dbe3c15026afdb8b35d5a758081fdf7c2c860ad0 mods/pearl/utils"
            echo " 6f9cb1bb29e65e69200161217175e79b28b4e422 mods/pearl/ssh (remotes/origin/HEAD)"
        elif [ $2 == "update" ]
        then
            assertEquals "mods/pearl/ssh" $6
        fi
    }
    GIT=git_mock
    assertCommandSuccess pearl_update
}

function test_pearl_remove(){
    ask(){
        return 0
    }
    git_mock(){
        [ $1 != "submodule" ] && return
        if [ $2 == "status" ]
        then
            echo "-dbe3c15026afdb8b35d5a758081fdf7c2c860ad0 mods/pearl/utils"
            echo " 6f9cb1bb29e65e69200161217175e79b28b4e422 mods/pearl/ssh (remotes/origin/HEAD)"
        elif [ $2 == "deinit" ]
        then
            assertEquals "mods/pearl/ssh" $4
        fi
    }
    GIT=git_mock
    assertCommandSuccess pearl_remove
    [ ! -e $PEARL_HOME ]
    assertEquals 0 $?
}

function test_pearl_remove_no(){
    ask(){
        return 1
    }
    git_mock(){
        # This should never happen
        assertTrue "The git command has been executed" 123
    }
    GIT=git_mock
    assertCommandSuccess pearl_remove
    [ -e $PEARL_HOME ]
    assertEquals 0 $?
}

source $(dirname $0)/shunit2
