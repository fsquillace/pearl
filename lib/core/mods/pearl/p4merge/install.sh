
function post_install(){
    ${PEARL_ROOT}/mods/pearl/p4merge/bin/p4install
}

function pre_uninstall(){
    ${PEARL_ROOT}/mods/pearl/p4merge/bin/p4uninstall
}
