function pre_uninstall(){
    rm -f ${PEARL_HOME}/sshrc.d/pearl_*
    rm -f ${PEARL_HOME}/sshinputrc.d/pearl_*
    rm -f ${PEARL_HOME}/sshvimrc.d/pearl_*
    return 0
}
