
MANPATH=$MANPATH:$PEARL_ROOT/mods/pearl/ssh/man
PEARL_SSH_ROOT="${PEARL_ROOT}/mods/pearl/ssh"
source ${PEARL_ROOT}/mods/pearl/ssh/lib/ssh_pearl.sh


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

# vim: ft=sh
