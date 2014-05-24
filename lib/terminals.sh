
if [ -n "$TMUX" ]; then
    # set TERM according to the parent terminal's TERM (see etc/tmux.conf)
    case "$TERM" in
        *-256color) export TERM=xterm-256color ;;
        *) export TERM=screen ;;
    esac

    # Home/End keys in tmux
    bind '"\e[1~":"\eOH"'
    bind '"\e[4~":"\eOF"'

    PEARL_SESSION_NAME=$(tmux display-message -p '#S')
    PEARL_WINDOW_INDEX=$(tmux display-message -p '#I')
    PEARL_PANE_INDEX=$(tmux display-message -p '#P')
    [ -f $PEARL_HOME/envs/default ] && source $PEARL_HOME/envs/default
    [ -f $PEARL_HOME/envs/$PEARL_SESSION_NAME ] && source $PEARL_HOME/envs/$PEARL_SESSION_NAME
fi


if [ -n "$STY" ]; then

    PEARL_SESSION_NAME=$(echo $STY | cut -d . -f 2)
    PEARL_WINDOW_INDEX=${WINDOW}
    [ -f $PEARL_HOME/envs/default ] && source $PEARL_HOME/envs/default
    [ -f $PEARL_HOME/envs/$PEARL_SESSION_NAME ] && source $PEARL_HOME/envs/$PEARL_SESSION_NAME
fi


# Set the terminfo for screen 256
export TERMINFO_DIRS=$TERMINFO_DIRS:$PEARL_ROOT/share/terminfo


function tmux(){

    local tmux_command=$(which tmux 2> /dev/null)
    [ ! -f "$tmux_command" ] && tmux_command="/usr/bin/tmux"

    local OPT_GO=""
    local OPT_KILL=""
    local OPT_HELP=false
    local args=()
    while [ "$1" != "" ] ; do
	case "$1" in
	    -g|--go) shift; OPT_GO="$1" ; shift ;;
	    -k|--kill) shift; OPT_KILL="$1" ; shift ;;
            -h|--help) OPT_HELP=true ; shift ;;
            --) shift ; break ;;
	    *) args+=("$1") ; shift ;;
	esac
    done

    #################### END OPTION PARSING ############################

    if $OPT_HELP
    then
        $tmux_command --help
        echo ""
        echo -e "Extra usage form the wrapper: tmux [options]"
        echo -e "Options:"
        echo -e "\t-g, --go              Go to the directory selected by the key and create a tmux session"
        echo -e "\t-k, --kill            Kill the tmux session identified by the key"
        echo -e "\t-h, --help            Show this help message"
        return 0
    fi

    if [ "$OPT_GO" != "" ] && [ "$OPT_KILL" != "" ]
    then
        echo "The options --go and --kill cannot stay togheter."
        return 1
    fi

    if [ "$OPT_GO" != "" ]
    then
        local dir=$(cd -p $OPT_GO)
        [ "$dir" == "" ] && local dir="$PWD"
        builtin cd "$dir"
        # Set always the same $dir directory for the session
        if ! $tmux_command has-session -t "${OPT_GO}" &> /dev/null
        then
            $tmux_command new-session -d -s "${OPT_GO}" &> /dev/null
            $tmux_command set-option -t "${OPT_GO}" default-path $dir &> /dev/null
        fi
        $tmux_command new-session -AD -s "${OPT_GO}"
        builtin cd "$OLDPWD"
    elif [ "$OPT_KILL" != "" ]
    then
        $tmux_command kill-session -t "${OPT_KILL}"
    else
        $tmux_command ${args[@]}
    fi

    return 0
}

function screen(){

    local screen_command=$(which screen 2> /dev/null)
    [ ! -f "$screen_command" ] && screen_command="/usr/bin/screen"

    local OPT_GO=""
    local OPT_KILL=""
    local OPT_HELP=false
    local args=()
    while [ "$1" != "" ] ; do
	case "$1" in
	    -g|--go) shift; OPT_GO="$1" ; shift ;;
	    -k|--kill) shift; OPT_KILL="$1" ; shift ;;
            -h|--help) OPT_HELP=true ; shift ;;
            --) shift ; break ;;
	    *) args+=("$1") ; shift ;;
	esac
    done

    #################### END OPTION PARSING ############################

    if $OPT_HELP
    then
        $screen_command --help
        echo ""
        echo -e "Extra usage form the wrapper: screen [options]"
        echo -e "Options:"
        echo -e "\t-g, --go              Go to the directory selected by the key and create a screen session"
        echo -e "\t-k, --kill            Kill the screen session identified by the key"
        echo -e "\t-h, --help            Show this help message"
        return 0
    fi

    if [ "$OPT_GO" != "" ] && [ "$OPT_KILL" != "" ]
    then
        echo "The options --go and --kill cannot stay togheter."
        return 1
    fi

    if [ "$OPT_GO" != "" ]
    then
        local dir=$(cd -p $OPT_GO)
        [ "$dir" == "" ] && local dir="$PWD"
        builtin cd "$dir"
        $screen_command -S "${OPT_GO}" -aARd
        clear
        builtin cd "$OLDPWD"
    elif [ "$OPT_KILL" != "" ]
    then
        $screen_command -S "${OPT_KILL}" -X quit

    else
        $screen_command ${args[@]}
    fi

    return 0
}

