
MANPATH=$MANPATH:$PEARL_ROOT/mods/pearl/ssh/man
source ${PEARL_ROOT}/mods/pearl/ssh/lib/ssh_pearl.sh
PATH=$PATH:${PEARL_ROOT}/mods/pearl/ssh/bin


mkdir -p "${PEARL_HOME}/sshrc.d/"
[ ! -f "${PEARL_HOME}/sshrc.d/pearl_aliases.sh" ] && \
    [ -f "$PEARL_ROOT/mods/pearl/utils/lib/aliases.sh" ] && \
    ln -s "$PEARL_ROOT/mods/pearl/utils/lib/aliases.sh" "${PEARL_HOME}/sshrc.d/pearl_aliases.sh"

[ ! -f "${PEARL_HOME}/sshrc.d/pearl_ops.sh" ] && \
    [ -f "$PEARL_ROOT/mods/pearl/utils/lib/ops.sh" ] && \
    ln -s "$PEARL_ROOT/mods/pearl/utils/lib/ops.sh" "${PEARL_HOME}/sshrc.d/pearl_ops.sh"

[ ! -f "${PEARL_HOME}/sshrc.d/pearl_core.sh" ] && \
    [ -f "$PEARL_ROOT/mods/pearl/utils/lib/core.sh" ] && \
    ln -s "$PEARL_ROOT/mods/pearl/utils/lib/core.sh" "${PEARL_HOME}/sshrc.d/pearl_core.sh"

mkdir -p "${PEARL_HOME}/sshinputrc.d/"
[ ! -f "${PEARL_HOME}/sshinputrc.d/pearl_inputrc" ] && \
    [ -f "$PEARL_ROOT/mods/pearl/dotfiles/etc/inputrc" ] && \
    ln -s "$PEARL_ROOT/mods/pearl/dotfiles/etc/inputrc" "${PEARL_HOME}/sshinputrc.d/pearl_inputrc"

mkdir -p "${PEARL_HOME}/sshvimrc.d/"
[ ! -f "${PEARL_HOME}/sshvimrc.d/pearl_vimrc" ] && \
    [ -f "$PEARL_ROOT/mods/pearl/dotfiles/etc/vim/vimrc" ] && \
    ln -s "$PEARL_ROOT/mods/pearl/dotfiles/etc/vim/vimrc" "${PEARL_HOME}/sshvimrc.d/pearl_vimrc"

# vim: ft=sh
