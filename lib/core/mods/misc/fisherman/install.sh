
function post_install(){
    cd $PEARL_ROOT/mods/misc/fisherman
    make
    fish -c "fisher update"
    return 0
}

function pre_remove(){
    local fish_plugins=$(fish -c "fisher list")
    [ "$fish_plugins" == "." ] && return

    echo "$fish_plugins" | fish -c "fisher uninstall --force"
    return 0
}
