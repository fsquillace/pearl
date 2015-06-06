function pre_uninstall(){
    rm -f ${PEARL_HOME}/sshrc.d/pearl_*
    return 0
}
