
function post_install(){
    cd $PEARL_ROOT/mods/misc/fisherman
    make
    fish -c "fisher update"
    return 0
}

function pre_remove(){
    fish -c "fisher list | fisher uninstall --force"
    return 0
}
