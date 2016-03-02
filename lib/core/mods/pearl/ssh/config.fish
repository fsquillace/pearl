
set MANPATH $MANPATH $PEARL_ROOT/mods/pearl/ssh/man
set PATH $PATH $PEARL_ROOT/mods/pearl/ssh/bin

mkdir -p "$PEARL_HOME/sshrc.d/"
[ ! -f "$PEARL_HOME/sshrc.d/pearl_aliases.sh" ]; \
    and [ -f "$PEARL_ROOT/mods/pearl/utils/lib/aliases.sh" ]; \
    and ln -s "$PEARL_ROOT/mods/pearl/utils/lib/aliases.sh" "$PEARL_HOME/sshrc.d/pearl_aliases.sh"

[ ! -f "$PEARL_HOME/sshrc.d/pearl_ops.sh" ]; \
    and [ -f "$PEARL_ROOT/mods/pearl/utils/lib/ops.bash" ]; \
    and ln -s "$PEARL_ROOT/mods/pearl/utils/lib/ops.bash" "$PEARL_HOME/sshrc.d/pearl_ops.sh"

[ ! -f "$PEARL_HOME/sshrc.d/pearl_core.sh" ]; \
    and [ -f "$PEARL_ROOT/mods/pearl/utils/lib/core.bash" ]; \
    and ln -s "$PEARL_ROOT/mods/pearl/utils/lib/core.bash" "$PEARL_HOME/sshrc.d/pearl_core.sh"

mkdir -p "$PEARL_HOME/sshinputrc.d/"
[ ! -f "$PEARL_HOME/sshinputrc.d/pearl_inputrc" ]; \
    and [ -f "$PEARL_ROOT/mods/pearl/dotfiles/etc/inputrc" ]; \
    and ln -s "$PEARL_ROOT/mods/pearl/dotfiles/etc/inputrc" "$PEARL_HOME/sshinputrc.d/pearl_inputrc"

mkdir -p "$PEARL_HOME/sshvimrc.d/"
[ ! -f "$PEARL_HOME/sshvimrc.d/pearl_vimrc" ]; \
    and [ -f "$PEARL_ROOT/mods/pearl/dotfiles/etc/vim/vimrc" ]; \
    and ln -s "$PEARL_ROOT/mods/pearl/dotfiles/etc/vim/vimrc" "$PEARL_HOME/sshvimrc.d/pearl_vimrc"

# vim: ft=sh
