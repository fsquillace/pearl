
function post_install(){
    local root_path="${PEARL_ROOT}/mods/pearl-man/"
    OLD_PWD=$(pwd)
    builtin cd "$root_path"
    git submodule update --init --force --rebase
    builtin cd "$OLD_PWD"
    return 0
}
