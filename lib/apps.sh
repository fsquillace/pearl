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
    echo "Installed Syntastic in $bundle_dir/syntastic"
    builtin cd $OLDPWD
}
function pearl_uninstall_syntastic(){
    rm -rf ${HOME}/.vim/bundle/syntastic && echo "Syntastic removed!"
}

function pearl_install_ranger(){
    local OLD_PWD=$(pwd)
    local opt_dir=$PEARL_HOME/opt
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
    echo "Installed Ranger in $opt_dir/ranger"
    echo "Update your .bashrc with: PATH=\$PATH:${opt_dir}/ranger"
    builtin cd $OLD_PWD
}
function pearl_uninstall_ranger(){
    rm -rf ${PEARL_HOME}/opt/ranger && echo "Ranger removed!"
}

function pearl_install_liquidprompt(){
    local context=$PEARL_HOME/etc/context
    mkdir -p $context
    curl -so $context/liquidprompt https://raw.github.com/nojhan/liquidprompt/master/liquidprompt
    echo "Installed Liquidprompt as a context in $context"
}
function pearl_uninstall_liquidprompt(){
    rm -rf ${PEARL_HOME}/etc/context/liquidprompt && echo "Liquidprompt removed!"
}
