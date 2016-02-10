
function post_install(){
    ${PEARL_ROOT}/mods/pearl/p4merge/bin/p4install
    apply "[include] path = \"$PEARL_ROOT/mods/pearl/p4merge/etc/gitconfig\"" "$HOME/.gitconfig"
}

function pre_uninstall(){
    ${PEARL_ROOT}/mods/pearl/p4merge/bin/p4uninstall
    unapply "[include] path = \"$PEARL_ROOT/mods/pearl/p4merge/etc/gitconfig\"" "$HOME/.gitconfig"
}
