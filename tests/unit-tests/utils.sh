
OLD_PWD=$PWD

function pearlSetUp(){
    PEARL_ROOT=$(TMPDIR=/tmp mktemp -d -t pearl-test-root.XXXXXXX)
    mkdir -p $PEARL_ROOT/share/logo/
    touch  $PEARL_ROOT/share/logo/logo-ascii.txt
    HOME=$(TMPDIR=/tmp mktemp -d -t pearl-user-home.XXXXXXX)
    mkdir -p $HOME
    PEARL_HOME=$(TMPDIR=/tmp mktemp -d -t pearl-test-home.XXXXXXX)
    mkdir -p $PEARL_HOME
}

function pearlTearDown(){
    cd $OLD_PWD
    rm -rf $PEARL_HOME
    rm -rf $HOME
    rm -rf $PEARL_ROOT
}

function setUpUnitTests(){
    OUTPUT_DIR="${SHUNIT_TMPDIR}/output"
    mkdir "${OUTPUT_DIR}"
    STDOUTF="${OUTPUT_DIR}/stdout"
    STDERRF="${OUTPUT_DIR}/stderr"
}

function assertCommandSuccess(){
    $(set -e
      $@ > $STDOUTF 2> $STDERRF
    )
    assertTrue "The command $1 did not return 0 exit status" $?
}

function assertCommandFail(){
    $(set -e
      $@ > $STDOUTF 2> $STDERRF
    )
    assertFalse "The command $1 returned 0 exit status" $?
}

# $1: expected exit status
# $2-: The command under test
function assertCommandFailOnStatus(){
    local status=$1
    shift
    $(set -e
      $@ > $STDOUTF 2> $STDERRF
    )
    assertEquals $status $?
}
