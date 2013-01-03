# This module depends on:
# $PEARL_ROOT/lib/util.sh


function _init_ssh_command(){
local initCommand
read -d '' initCommand <<- EOF
if [ ! -x \$HOME ];
then
    echo "Home folder doesn't exist. Creating it!";
    sudo mkdir \$HOME;
    sudo chown \$HOME;
fi;
[ -d \$HOME/.config/pearl/tmp ] || mkdir -p \$HOME/.config/pearl/tmp;

EOF
echo $initCommand
}


# Open a ssh session and transfer a minimal
# version of pearl
function ssh_mini_pearl(){
local homeScript=""
[ -f $PEARL_HOME/pearlrc ] && homeScript=$(cat $PEARL_HOME/pearlrc)
local aliasesScript=$(cat $PEARL_ROOT/lib/aliases.sh)
local opsScript="$(cat $PEARL_ROOT/lib/ops.sh)"
local initCommand=$(_init_ssh_command)

local commandScript=$(echo "$initCommand\n$aliasesScript\n$opsScript\n$homeScript")
commandScript=$(hexencode "$commandScript")


read -d '' CMD <<- EOF
commandScript="${commandScript}"
echo "\$(printf '%b' "\${commandScript//x/\\\x}")" > /tmp/.minipearl.sh;
exec /bin/bash --rcfile /tmp/.minipearl.sh -i
EOF

ssh -2 -t $@ -- "$CMD"
}


# Open a ssh session and create a complete pearl
# from either git or wget
function ssh_pearl(){
local installScript='
git_command=$(which git);

if [ -d $HOME/.pearl ];
then
    if [ "$git_command" != "" ] && [ -d "$HOME/.pearl/.git" ];
    then
        cd $HOME/.pearl;
        git pull;
        cd - &> /dev/null;
    fi;
else
    if [ "$git_command" != "" ];
    then
        git clone git://github.com/fsquillace/pearl $HOME/.pearl;
    else
        mkdir -p /tmp/pearl-install && cd /tmp/pearl-install;
        wget https://github.com/fsquillace/pearl/archive/current.tar.gz;
        md5sum current.tar.gz > $HOME/.pearl/pearl.sum
        tar xzvf current.tar.gz;
        mv pearl-current $HOME/.pearl;
        rm -rf /tmp/pearl-install;
        cd $HOME;
    fi
fi
source $HOME/.pearl/pearl;
'
local initCommand=$(_init_ssh_command)
local commandScript=$(echo "$initCommand\n$installScript")
commandScript=$(hexencode "$commandScript")

read -d '' CMD <<- EOF
commandScript="${commandScript}"
echo "\$(printf '%b' "\${commandScript//x/\\\x}")" > \$HOME/.config/pearl/tmp/minipearl.sh;
exec /bin/bash --rcfile \$HOME/.config/pearl/tmp/minipearl.sh -i
EOF

ssh -2 -t $@ -- "$CMD"
}

