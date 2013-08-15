function pearl_install_liquidprompt(){
    local context=$PEARL_HOME/etc/context
    mkdir -p $context
    curl -so $context/liquidprompt https://raw.github.com/nojhan/liquidprompt/master/liquidprompt
    echo "Installed Liquidprompt as a context in $context"
}
function pearl_uninstall_liquidprompt(){
    rm -rf ${PEARL_HOME}/etc/context/liquidprompt && echo "Liquidprompt removed!"
}
