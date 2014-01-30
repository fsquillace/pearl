# This module is used to create the user home directory
# and to set the config files


PEARL_CONFIGS="bashrc:source $PEARL_ROOT/pearl:$HOME/.bashrc
vimrc:source $PEARL_ROOT/etc/vimrc:$HOME/.vimrc
emacs:(load-file \"$PEARL_ROOT/etc/emacs.el\"):$HOME/.emacs
inputrc:\$include $PEARL_ROOT/etc/inputrc:$HOME/.inputrc
ranger:exec(open('$PEARL_ROOT/etc/ranger/commands.py').read()):$HOME/.config/ranger/commands.py
screenrc:source $PEARL_ROOT/etc/screenrc:$HOME/.screenrc
tmux:source $PEARL_ROOT/etc/tmux.conf:$HOME/.tmux.conf
xdefaults:# include \"$PEARL_ROOT/etc/Xdefaults\":$HOME/.Xdefaults
gitconfig:[include] path = \"$PEARL_ROOT/etc/gitconfig\":$HOME/.gitconfig
gitignore:[core] excludesfile = $PEARL_ROOT/etc/gitignore:$HOME/.gitconfig"

function pearl_config_enable(){
    function up_help(){
        echo "Usage: pearl_config_enable <configname>"
        echo "Enable the config"
    }

    if [ ${#@} -ne 1 ]; then
        echo "pearl_config_enable: unrecognized options '$@'"
        up_help
        return 128
    fi

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        up_help
        return 0
    fi

    local configname="$1"

    while read -r line; do
        local conf=$(echo $line | awk -F : '{print $1}')
        local confline=$(echo "$line" | awk -F : '{print $2}')
        local conffile=$(echo "$line" | awk -F : '{print $3}')
        if [ "$conf" == "$configname" ]
        then
            echo "Applying in $conffile ..."
            apply "$confline" "$conffile"
            return 0
        fi
    done <<< "$PEARL_CONFIGS"

    return 1
}

function pearl_config_disable(){
    function up_help(){
        echo "Usage: pearl_config_disable <configname>"
        echo "Disable the config"
    }

    if [ ${#@} -ne 1 ]; then
        echo "pearl_config_disable: unrecognized options '$@'"
        up_help
        return 128
    fi

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        up_help
        return 0
    fi

    local configname="$1"

    while read -r line; do
        local conf=$(echo $line | awk -F : '{print $1}')
        local confline=$(echo "$line" | awk -F : '{print $2}')
        local conffile=$(echo "$line" | awk -F : '{print $3}')
        if [ "$conf" == "$configname" ]
        then
            echo "Unapplying in $conffile ..."
            unapply "$confline" "$conffile"
            return 0
        fi
    done <<< "$PEARL_CONFIGS"

    return 1
}


function pearl_config_list(){
    while read -r line; do
        local conf=$(echo $line | awk -F : '{print $1}')
        local confline=$(echo "$line" | awk -F : '{print $2}')
        local conffile=$(echo "$line" | awk -F : '{print $3}')

        local enabled=""
        is_applied "$confline" "$conffile" && enabled="[enabled]"
        echo "$conf $enabled"

    done <<< "$PEARL_CONFIGS"

    return 0
}


function pearl_init(){
    if [ -e $PEARL_HOME/pearlrc ]
    then
        source $PEARL_HOME/pearlrc
    else
        pearl_logo
        # Shows informations system
        echo ""
        (uname -m && cat /etc/*release)

        echo ""
        echo "The pearl configurations are not mandatory but they are strongly recommended."
        echo "They consist of vim, bash, readline and much more made by pearl."
        echo "You can easily change or reset the settings of pearl whenever you want executing:"
        echo ">> pearl_config_list"
        echo ">> pearl_config_enable <configname>"
        echo ""

        pearl_config_enable bashrc

        echo "Creating ~/.config/pearl directory ..."
        mkdir -p $PEARL_HOME/bkp
        mkdir -p $PEARL_HOME/mans
        mkdir -p $PEARL_HOME/etc/context
        mkdir -p $PEARL_HOME/opt

        echo "#!/bin/bash" > $PEARL_HOME/pearlrc
        echo "#This script is used to execute anything you want. " >> $PEARL_HOME/pearlrc
        echo "# Uncomment and type your Dropbox/Ubuntu One home if it's different from ~/Dropbox/:" >> $PEARL_HOME/pearlrc
        echo "#export SYNC_HOME=~/Dropbox/" >> $PEARL_HOME/pearlrc
        chmod +x $PEARL_HOME/pearlrc

        echo ""
        echo "For more information: man pearl"

    fi

}

