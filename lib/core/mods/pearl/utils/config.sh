
MANPATH=$MANPATH:$PEARL_ROOT/mods/pearl/utils/man
PATH=$PATH:$PEARL_ROOT/mods/pearl/utils/bin
source ${PEARL_ROOT}/mods/pearl/utils/lib/utils.bash
source ${PEARL_ROOT}/mods/pearl/utils/lib/core.bash

source ${PEARL_ROOT}/mods/pearl/utils/lib/aliases.sh
source ${PEARL_ROOT}/mods/pearl/utils/lib/aliases.bash
source ${PEARL_ROOT}/mods/pearl/utils/lib/ops.bash
[ -z "$BASH" ] || source ${PEARL_ROOT}/mods/pearl/utils/lib/prompt.bash
source ${PEARL_ROOT}/mods/pearl/utils/lib/terminals.bash
source ${PEARL_ROOT}/mods/pearl/utils/lib/traps.sh

return 0
# vim: ft=sh
