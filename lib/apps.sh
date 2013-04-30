function pearl_install_syntastic(){
    local bundle_dir=${HOME}/.vim/bundle
    if [ -e $bundle_dir/syntastic/ ];
    then
        builtin cd $bundle_dir/syntastic/
        git pull
    else
        mkdir -p $bundle_dir
        builtin cd $bundle_dir
        git clone https://github.com/scrooloose/syntastic.git
    fi
    builtin cd $OLDPWD
}

function pearl_uninstall_syntastic(){
    rm -rf ${HOME}/.vim/bundle/syntastic
}

function pearl_install_ranger(){
    local OLD_PWD=$(pwd)
    local opt_dir=$PEARL_HOME/opt
    echo "Installing ranger in $opt_dir/ranger ..."
    if [ -e $opt_dir/ranger ];
    then
        builtin cd $opt_dir/ranger
        git pull
    else
        mkdir -p $opt_dir
        builtin cd $opt_dir
        git clone git://git.savannah.nongnu.org/ranger.git
        builtin cd $opt_dir/ranger
    fi
    git checkout stable
    echo "Update your .bashrc with: PATH=\$PATH:${opt_dir}/ranger"
    builtin cd $OLD_PWD
}
function pearl_uninstall_ranger(){
    rm -rf ${PEARL_HOME}/opt/ranger
}
