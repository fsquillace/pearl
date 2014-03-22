# This module depends on:
# $PEARL_ROOT/lib/util.sh


# Open a ssh session and transfer a minimal
# version of pearl
function ssh_mini_pearl(){
[ -z $PEARL_HOME ] && PEARL_HOME=${HOME}/.config/pearl
local homeScript=""
[ -f $PEARL_HOME/pearlsshrc ] && homeScript=$(cat $PEARL_HOME/pearlsshrc)

local aliasesScript=""
local opsScript=""
if [ -d "$PEARL_ROOT" ];
then
    aliasesScript=$(cat $PEARL_ROOT/lib/aliases.sh)
    opsScript="$(cat $PEARL_ROOT/lib/ops.sh)"
fi

local commandScript=$(echo "$aliasesScript\n$opsScript\n$homeScript")
commandScript=$(hexencode "$commandScript")

CMD="commandScript=\"${commandScript}\"; PEARL_INSTALL=\$(mktemp -d pearl-XXXXX -p /tmp); echo \"\$(printf '%b' \"\${commandScript}\")\" > \${PEARL_INSTALL}/minipearl.sh; bash --rcfile \${PEARL_INSTALL}/minipearl.sh -i; [ -d \${PEARL_INSTALL} ] && rm -rf \${PEARL_INSTALL}"

ssh -2 -t $@ -- "$CMD"
}


# Open a ssh session and create a complete pearl
# from either git or wget
function ssh_pearl(){
local installScript=""
if [ -d "$PEARL_ROOT" ];
then
    installScript=$(cat ${PEARL_ROOT}/lib/make.sh)
else
    installScript=$(wget -q -O - https://raw.github.com/fsquillace/pearl/master/lib/make.sh)
fi

local commandScript=$(hexencode "$installScript")

CMD="commandScript=\"${commandScript}\"; PEARL_INSTALL=\$(mktemp -d pearl-XXXXX -p /tmp); echo \"\$(printf '%b' \"\${commandScript}\")\" > \${PEARL_INSTALL}/make.sh; bash \${PEARL_INSTALL}/make.sh; bash --rcfile \$HOME/.pearl/pearl -i; [ -d \${PEARL_INSTALL} ] && rm -rf \${PEARL_INSTALL}"

ssh -2 -t $@ -- "$CMD"
}

