#!/bin/sh


hexencode(){
    local length=${#1}
    [ ${length} -eq 0 ] && length=1
    echo -e "$1" | od -w$length -t x1 | head -n1 | sed -e 's/^[0]* / /' -e 's/ /\\x/g'
}

hexdecode() {
# urldecode <string>
printf '%b' ${1}
}

urlencode() {
# urlencode <string>
# TODO encode the \t properly
# TODO make the encode faster with xargs

local length="${#1}"
for (( i = 0 ; i < length ; i++ )); do
local c="${1:i:1}"

case "$c" in
[a-zA-Z0-9.~_-]) printf "$c" ;;
' ') printf '%%20' ;;
$'\n') printf '%%0A' ;;
*) printf '%%%X' "'$c"
esac
done
}


urldecode() {
# urldecode <string>

printf '%b' "${1//%/\x}"
}


function confirm_question(){
    # $1: prompt;

    local res="none"
    while [ "$res" != "Y" ] && [ "$res" != "n" ] && [ "$res" != "N"  ] && [ "$res" != "y"  ] && [ "$res" != "" ];
    do
        read -p "$1" res
    done

    echo "$res"
}


function apply(){
    # If the file doesn't exist create it and append the line
    if [ ! -e "$2" ]
    then
        #dirp=$(readlink -f `dirname $2`)
        local dirp=$(dirname $2)
        mkdir -p $dirp
        touch "$2"
    fi
    # Check if already exists the
    # line into the file
    grep -x "$1" "$2" &> /dev/null
    if [ "$?" = "1" ]
    then
        echo "" >> $2
        echo "$1" >> $2
    fi
}

function unapply(){
    grep -v -x "$1" "$2" &> /tmp/tmp_file
    cat /tmp/tmp_file > "$2"
    rm -fr /tmp/tmp_file
}


function pearl_logo(){
cat "$PEARL_ROOT/share/logo/logo-ascii.txt"
}

# Switch to a particular context
# $1: context file in etc/context/
# If the context doesn't exists it gives an error
#function pearl_switch(){
    #local context="$PEARL_ROOT/etc/context/$1"
    #[ -f $context ] || context="$PEARL_HOME/etc/context/$1"

    #if [ ! -f "$context" ]
    #then
        #echo "Error: the context doesn't exist."
        #return 128
    #fi
    #source $PEARL_ROOT/pearl
    #source $context
#}


notifier(){
## Check out the log files $TEMPORARY/pearl.out $TEMPORARY/pearl.err and notify the user
## -e show the error
## -o show the output
## -a show all
## no option return the notify !!
#if [ -f $TEMPORARY/notify.* ]
#then

    #difout=$(diff $TEMPORARY/pearl.out $TEMPORARY/notify.out)
    #diferr=$(diff $TEMPORARY/pearl.err $TEMPORARY/notify.err)

#else
    #difout=""
    #diferr=""
#fi

    #if [ "$difout" -ne "" -a "$diferr" -ne "" ]
    #then
	#echo -e "\e[1;31m! \e[0m \e[1;33m! \e[0m"
    #elif [ "$difout" -ne "" ]
    #then
	#echo -e "\e[1;31m! \e[0m"
    #elif [ "$diferr" -ne "" ]
    #then
	#echo -e "\e[1;33m! \e[0m"
    #fi


## Update 
    #cp $TEMPORARY/pearl.out $TEMPORARY/notify.out
    #cp $TEMPORARY/pearl.err $TEMPORARY/notify.err

    echo -e "\e[1;31m! \e[0m \e[1;33m! \e[0m"
}




bootapp(){
# Permette di decidere se voler mostrare stout o stderr
local show_stdout=$3
local show_stderr=$4
local a=`ps aux | grep  -v "grep" | grep "$1"`  #`pidof $1`
if [ "$a" = "" ]; then
    #echo "L'applicazione " $1 "verrà eseguita tra" $2
    # Opzione di default
    if [ "$show_stdout" = "" ]; then
        sleep $2 && nohup $1 &> /dev/null &
    elif [ "$show_stdout" = "false" -a "$show_stderr" = "false" ]; then
    	sleep $2 && nohup $1 &> /dev/null &
    elif [ "$show_stdout" = "true" -a "$show_stderr" = "false" ]; then
        sleep $2 && nohup $1 1>> $TEMPORARY/pearl.out 2>> /dev/null &
    elif [ "$show_stdout" = "false" -a "$show_stderr" = "true" ]; then
        sleep $2 && nohup $1 2>> $TEMPORARY/pearl.err 1>> /dev/null &
    elif [ "$show_stdout" = "true" -a "$show_stderr" = "true" ]; then
        sleep $2 && nohup $1 1>> $TEMPORARY/pearl.out 2>> $TEMPORARY/pearl.err &
    fi

fi
}

function eye(){
    local TEMP=`getopt -o crwph --long case-sensitive,recursive,whole-words,pdf,help -n 'eye' -- "$@"`

    if [ $? != 0 ] ; then echo "Error on parsing the command line. Try eye -h" >&2 ; return ; fi

    # Note the quotes around `$TEMP': they are essential!
    eval set -- "$TEMP"

    local OPT_CASE="-i"
    local OPT_RECUR="-maxdepth 1"
    local OPT_WHOLE_WORDS=false
    local OPT_PDF=false
    local OPT_HELP=false
    while true ; do
	case "$1" in
	    -c|--case-sensitive) OPT_CASE="" ; shift ;;
	    -r|--recursive) OPT_RECUR="" ; shift ;;
	    -w|--whole-words) OPT_WHOLE_WORDS=true ; shift ;;
            -p|--pdf) OPT_PDF=true ; shift ;;
            -h|--help) OPT_HELP=true ; shift ;;
            --) shift ; break ;;
	    *) echo "Internal error!" ; return ;;
	esac
    done


    if $OPT_HELP
    then
        echo -e "Usage: eye [options] [path] pattern"
        echo -e "Options:"
        echo -e "\t-c, --case-sensitive  Case sensitive."
        echo -e "\t-r, --recursive       Recursive."
        echo -e "\t-w, --whole-words     Whole words."
        echo -e "\t-p, --pdf             Search in .pdf files too."
        echo -e "\t-h, --help            Show this help message"
        return 0
    fi


    local args=()
    for arg do
        args+=($arg)
    done

    if [ ${#args[@]} -gt 2 ]; then
        echo "Too many arguments!" ; return 127 ;
    elif [ ${#args[@]} -eq 1 ]; then
        local path=.
        local keyword=${args[0]}
    else
        local path=${args[0]}
        local keyword=${args[1]}
    fi


    if $OPT_WHOLE_WORDS
    then
        local keyword="[^0-9a-z]$keyword[^0-9a-z]"
    fi

    find $path $OPT_RECUR -type f -exec grep --binary-files=without-match --color=always $OPT_CASE -n "$keyword" {} \; -printf "\033[0;31m%p\033[0m\n" 


    # | awk -F "[\n:]" '{ print $0 }' # if($1 ~ /^([0-9]*):(.*)$/) {print $0} else {print $0} }' # else {print "\033[0;31m" $0 "\033[0m"; next; print $0 } }'



    if $OPT_PDF
    then
        local lis=$(find -type f -name "*.pdf" -printf "%p ")
        for l in $lis
        do
            pdftotext $l - | grep --color=always -n $OPT_CASE $keyword
            if [ "$?" -eq "0" ]; then
                echo -e "\033[0;31m$l\033[0m"
            fi
        done
    fi

}


# Trash command
function trash(){
    mkdir -p $PEARL_TEMPORARY

    if [ -z "$1" ] || [ "$1" = -s ] || [ "$1" = --show ]
    then
        ls --color -lh -a $PEARL_TEMPORARY
    elif [ "$1" = -r ] || [ "$1" = --recovery ]
    then
        mv $PEARL_TEMPORARY/$2 .
    elif [ "$1" = -e ] || [ "$1" = --empty ]
    then
        rm -rf $PEARL_TEMPORARY/*
    elif [ "$1" = -c ] || [ "$1" = --count ]
    then
        echo $(ls $PEARL_TEMPORARY | wc -l)
    elif [ "$1" = -h ] || [ "$1" = --help ]
    then
        echo "Usage: trash file1 file2 ...."
        echo -e "Moves to trash the files"
        echo -e "Options:"
        echo -e "\t-s, --show                Shows the trash"
        echo -e "\t-e, --empty               Empties the trash"
        echo -e "\t-r, --recovery <file>     Recovery a trashed file"
        echo -e "\t-c, --count               Count the trashed files"
        echo -e "\t-h, --help                Show this help message"
    else
        mv --backup=numbered -f -t $PEARL_TEMPORARY "$@"
    fi

}

function check_sync(){
    local sync_home_norm=$(realpath $SYNC_HOME)
    #find $sync_home_norm -print0 | xargs -0 -I {} echo "+:{}" > ~/.config/ranger/tagged
    find $sync_home_norm -print | awk -v q=$sync_home_norm '{sub(q,""); print "+:"$1}' > ~/.config/ranger/tagged
}


# cd to last path after exit
# This functionallows to change the directory 
# to the last visited one after ranger quits.
# You can always type "cd -" to go back
# to the original one.
function ranger(){

    # The following command add tags for the files synced. The problem is that is takes time
    #check_sync

    local ranger_command=${PEARL_ROOT}/opt/ranger/ranger.py
    [ -f $ranger_command ] || ranger_command="/usr/bin/ranger"

    # Checks out into the jobs if the user pressed the C-z key
    local id=$(jobs | grep ranger | awk -F "[][]" '{print $2}')
    if [ "$id" != "" ]
    then
        fg $id
        return
    fi

    # Checks out if the user pressed S key
    if [ "$RANGER_LEVEL" != "" ]
    then
        exit
        return # Ensures that it returns anyway if there are jobs stopped
    fi

    local tempfile='/tmp/chosendir'
    $ranger_command --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        echo $(cat "$tempfile")
        builtin cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}


# Create a sync with Dropbox/Ubuntu One folder using 
# absolute path to maintain the same structure
function sync() {
    local TEMP=`getopt -o la::r:hR --long list,add::,remove:,help,reverse  -n 'sync' -- "$@"`

    if [ $? != 0 ] ; then echo "Error on parsing the command line. Try sync -h" >&2 ; return ; fi

    # Note the quotes around `$TEMP': they are essential!
    eval set -- "$TEMP"

    local OPT_ADD=false
    local OPT_REMOVE=false
    local OPT_LIST=false
    local OPT_REVERSE=false
    local OPT_HELP=false
    while true ; do
	case "$1" in
	    -a|--add) OPT_ADD=true ; ARG1_ADD=$2; ARG2_ADD=$3; shift 3 ;;
	    -r|--remove) OPT_REMOVE=true ; ARG_REMOVE=$2 ; shift 2 ;;
	    -l|--list) OPT_LIST=true ; shift ;;
            -R|--reverse) OPT_REVERSE=true ; shift ;;
            -h|--help) OPT_HELP=true ; shift ;;
            --) shift ; break ;;
	    *) echo "Internal error!" ; return ;;
	esac
    done


    if $OPT_HELP # [ "$1" = --help ] && [ "$#" == 1 ]
    then
        echo "Usage: symc [options] [file1 file2 ...]"
        echo -e "Options:"
        echo -e "\t-R, --reverse] <num>                          Sync files or directories"
        echo -e "\t                                              using the <num> entry"
        echo -e "\t-l, --list                                    List all the sync entry"
        echo -e "\t-a, --add <local src> <local/remote dest>     Add a sync entry"
        echo -e "\t-r, --remove <num>                            Remove a sync entry"
        echo -e "\t-h, --help                                    Show this help message"
        return 0
    fi

    # If the file doesn't exist create it with a default entry
    if [ ! -f $PEARL_HOME/syncs ]
    then
        echo "/,~/Dropbox" >> $PEARL_HOME/syncs
    fi

    if $OPT_LIST #|| [ "$1" == "--list" ]
    then
        cat -n $PEARL_HOME/syncs | sed -e 's/,/  ->  /g'

    elif $OPT_REMOVE #|| [ "$1" == "--remove" ]
    then
        sed -e "${2}d" $PEARL_HOME/syncs | tee $PEARL_HOME/syncs

    elif $OPT_ADD #|| [ "$1" == "--add" ]
    then
        echo "$(readlink -f $ARG1_ADD),$ARG2_ADD" >> $PEARL_HOME/syncs
    else
        # Get the line of syncs
        local sync_src=$(awk -v num=$1 -F ',' 'NR == num {print $1}' $PEARL_HOME/syncs)
        local sync_dest=$(awk -v num=$1 -F ',' 'NR == num {print $2}' $PEARL_HOME/syncs)
        shift;

        #introduce --exclude option
        #exc_opt=""
        #for ((i=1; i<=$;i++))
        #do
            #if [[ "${!i}" != *--exclude* ]]
            #then
                #break
            #else
                #exc_opt="${exc_opt} ${!i}"
            #fi
        #done



        sync_src=$(readlink -f $sync_src)
        # Change sync_src if it's different from /
        if [ "$sync_src" != "/" ]
        then
            local sync_src=$sync_src/
        fi


        #for var in "$@" #Another solution
        # Create all the relative paths
        local rel_paths=""
        for arg in $@ # ((j=2;j<=$#;j++))
        do
            # Rsync Options:
            # -c:     Enable checksum
            # -a:     Preserve the attibutes of the files.
            # -v:     Verbose.
            # -z:     Enables the compression.
            # -u:     Update files.
            # -r:     Recursive.
            # -E:     Preserve Executability.
            # -h:     Human readable.
            # -n:     Simulate.
            # -R:     Relative (include implied directories).
            # -C:     Exclude CVS.
            # --exclude=.svn


            local abs_path=$(readlink -f "$arg") #"${!j}")
            # If readlink didn't work well skip the following steps
            # because without abs_path variable the next instructions 
            # could be dangerous
            if [ "$?" != "0" ]
            then
                continue
            fi



            # Manage the case of / for sync_src
            if [ "$sync_src" == "/" ]
            then
                local rel_path="$abs_path"

            else
                echo "$abs_path" | grep "^$sync_src" &> /dev/null
                if [ "$?" != 0 ]
                then
                    echo "Error: $abs_path is not in the base src directory $sync_src"
                    return 1
                fi

                # Get the relative path
                local rel_path=${abs_path/$sync_src/}

            fi
            # TODO solve the problem of spaces for directory and files
            local rel_paths="${rel_path} ${rel_paths}"

        done

            # For debug:
            #echo "Absolute path: $abs_path"
            #echo "Base path: $sync_src"
            #echo "Relative path: $rel_path"
            # echo ""


            # We must change directory to the base directory
            # to the the right implied directories with --relative option
            builtin cd "$sync_src"
            rsync --relative -C --exclude=.svn -uhzravE --delete ${rel_paths} "$sync_dest"
            builtin cd "$OLDPWD" &> /dev/null

            # The following solution doesn't manage deletion of files in the destination
            #cp -v -a --parents -u -r --target-directory $SYNC_HOME/ $(readlink -f $var)


    fi

}


# Create a link (that means link instead of copying like sync command)
# with Dropbox/Ubuntu One folder using
# absolute path to maintain the same structure
function symc() {
    #################### BEGIN OPTION PARSING ############################
    local TEMP=`getopt -o e:ucm:sh --long exclude:,unlink,clean,max-size:,show,help -n 'symc' -- "$@"`

    if [ $? != 0 ] ; then echo "Error on parsing the command line. Try symc -h" >&2 ; return ; fi

    # Note the quotes around `$TEMP': they are essential!
    eval set -- "$TEMP"

    local OPT_EXCLUDE=()
    local OPT_UNLINK=false
    local OPT_CLEAN=false
    local OPT_MAX_SIZE=""
    local OPT_SHOW=false
    local OPT_HELP=false
    while true ; do
	case "$1" in
            -e|--exclude) shift; OPT_EXCLUDE+=($1) ; shift ;;
            -u|--unlink) OPT_UNLINK=true ; shift ;;
            -c|--clean) OPT_CLEAN=true ; shift ;;
	    -m|--max-size) shift; OPT_MAX_SIZE="$1" ; shift ;;
            -s|--show) OPT_SHOW=true ; shift ;;
            -h|--help) OPT_HELP=true ; shift ;;
            --) shift ; break ;;
	    *) echo "Internal error!" ; return ;;
	esac
    done


    if $OPT_HELP
    then
        echo "Usage: symc [options] [file1 file2 ...]"
        echo -e "Link symbolic files or directories instead of copying (by default takes the current directory)"
        echo -e "Options:"
        echo -e "\t-m, --max-size BYTES        Max size in BYTES for each file to be symced."
        echo -e "\t-e, --exclude PATTERN       Exclude some file or directory that match to the PATTERN."
        echo -e "\t-u, --unlink                Remove the sym link of files or directories"
        echo -e "\t-c, --clean                 Delete broken sym links in the sync directory"
        echo -e "\t-s, --show                  Shows the sync directory"
        echo -e "\t-h, --help                  Show this help message"
        return 0
    fi

    local args=()
    for arg do
        args+=("$arg")
    done


    if $OPT_SHOW && [ ${#args[@]} -gt 0 ]; then
        echo "Error: No arguments with --show option!" ; return 127 ;
    elif $OPT_CLEAN && [ ${#args[@]} -gt 0 ]; then
        echo "Error: No arguments with --clean option!" ; return 127 ;
    fi

    # If no file is spcified take the current directory
    if ! $OPT_HELP && ! $OPT_CLEAN && ! $OPT_SHOW && [ ${#args[@]} -eq 0 ]; then
        local args=(".")
    fi

    #################### END OPTION PARSING ############################

    if $OPT_CLEAN
    then
        echo -e "Cleaning for broken symlinks in $SYNC_HOME. It could take time..."
        local res="none"
        while [ "$res" != "Y" ] && [ "$res" != "n" ] && [ "$res" != "N"  ] && [ "$res" != "y"  ] && [ "$res" != "" ];
        do
            read -p "Do you want to proceed? (Y/n)> " res
        done

        if [ "$res" == "n" ] || [ "$res" == "N" ]; then
            return 0
        fi

        find "$SYNC_HOME" -type l ! -execdir test -e '{}' \; -print -delete
        return 0
    fi

    if $OPT_SHOW
    then
        ls --color -lh -a "$SYNC_HOME"
        return 0
    fi






    #for var in "$@" #Another solution
    #for var in $args
    for var in "${args[@]}";
    do
        local abs_path=$(readlink -f "$var")

        # If readlink didn't work well skip the following steps
        # because without abs_path variable the next instructions 
        # could be dangerous
        if [ "$?" != "0" ]
        then
            echo "Error on getting the absolute path of $var"
            continue
        fi


        if $OPT_UNLINK
        then
            rm -v -fr "$SYNC_HOME/$abs_path"
        else
            # It needs to ensure that the file is readble
            test -r "$abs_path"
            if [ "$?" != "0" ]
            then
                echo -e "You don't have read permission for $var."
                continue
            fi

            exc_opt=""
            for el in ${OPT_EXCLUDE[@]}; do exc_opt="$exc_opt --exclude $el"; done

            # List of all directories to exclude only if the abs_path is a directory
            if [ -d "$abs_path" ]
            then
                du $exc_opt -b "$abs_path" | awk -F '[\t]' '{print $2;}' > /tmp/tmp_symc
            else
                echo "" > /tmp/tmp_symc
            fi

            # List of all files and directories
            local DU=`du $exc_opt -ab "$abs_path"`

            # Takes only the file with the satisfied constraints
            if [ "$OPT_MAX_SIZE" != "" ]
            then
                local FILES=$(echo "$DU" | awk -F '[\t]' -v ms=$OPT_MAX_SIZE '{if($1<ms){print $2;}  }')
            else
                local FILES=$(echo "$DU" | awk -F '[\t]' '{print $2;}')

            fi

            echo "$FILES" | grep -x -v -F -f /tmp/tmp_symc | tr -s '\n' '\000' | xargs -0 -I {} cp -f -s -v -a --parents -u --target-directory "$SYNC_HOME" {}

            unset DU
            unset FILES
            rm -f /tmp/tmp_symc

            # Wipe out all the files that don't have the read permission
            find "$SYNC_HOME/$abs_path" -type l ! -execdir test -r '{}' \; -delete

        fi
    done
}


# This function is a wrapper for cd including some functionalities
function cd() {
    #################### BEGIN OPTION PARSING ############################
    local TEMP=`getopt -o g:a:r:p:h --long go:,add:,remove:,print:,help -n 'cd' -- "$@"`

    if [ $? != 0 ] ; then echo "Error on parsing the command line. Try cd -h" >&2 ; return ; fi

    # Note the quotes around `$TEMP': they are essential!
    eval set -- "$TEMP"

    local OPT_ADD=""
    local OPT_REMOVE=""
    local OPT_GO=""
    local OPT_PRINT=""
    local OPT_HELP=false
    while true ; do
	case "$1" in
            -g|--go) shift; OPT_GO="$1" ; shift ;;
            -a|--add) shift; OPT_ADD="$1" ; shift ;;
            -r|--remove) shift; OPT_REMOVE="$1" ; shift ;;
	    -p|--print) shift; OPT_PRINT="$1" ; shift ;;
            -h|--help) OPT_HELP=true ; shift ;;
            --) shift ; break ;;
	    *) echo "Internal error!" ; return ;;
	esac
    done


    if $OPT_HELP
    then
        echo "Usage: cd [options] [key]"
        echo -e "List all the bookmarks entries"
        echo -e "Options:"
        echo -e "\t-g, --go [key]              Go to the directory specified by the key"
        echo -e "\t-a, --add <entry> [path]    Add the specified PATH assigning the ENTRY."
        echo -e "\t                            The entry key must contain alphanumeric and underscore chars."
        echo -e "\t                            The path is the current wd if PATH is not specified."
        echo -e "\t-r, --remove key            Remove an entry"
        echo -e "\t-p, --print key             Print the PATH entry (useful for pipe command)"
        echo -e "\t-h, --help                  Show this help message"
        return 0
    fi

    local args=()
    for arg do
        args+=("$arg")
    done

    #################### END OPTION PARSING ############################

    local bookmarks_file="$PEARL_HOME/bookmarks"
    touch $bookmarks_file

    if [ "$OPT_ADD" != ""  ]
    then
        # Checks first if key is an alphanumeric char
        if ! echo "$OPT_ADD" | grep '^\w*$' > /dev/null
        then
            echo "The entry key $OPT_ADD is not valid. It must only contain alphanumeric and underscore chars."
            return 128
        fi

        local path=${args}
        if [ -z "$path" ]; then
            local path="."
        fi

        local abs_path=$(readlink -f "$path")
        if [ ! -d "$abs_path" ]; then
            echo "$abs_path is not a directory."
            return 128
        fi

        # The commented code allow to create a random key
        #local pos=$(expr $RANDOM % ${#alphnum})
        #local key=${alphnum:$pos:1}
        echo "$OPT_ADD:$abs_path" >> "$bookmarks_file"
    elif [ "$OPT_REMOVE" != "" ]
    then
        grep "${OPT_REMOVE}:.*" ~/.config/pearl/bookmarks &> /dev/null || return 1

        local bookmrks=$(sed -e "/$OPT_REMOVE:.*/d" "$bookmarks_file")
        echo "$bookmrks" > "$bookmarks_file"
    elif [ "$OPT_PRINT" != "" ]
    then
        output=$(grep "${OPT_PRINT}:.*" ~/.config/pearl/bookmarks | cut -d: -f2)
        [ "$output" == "" ] && return 1
        echo "$output"
    elif [ "$OPT_GO" != "" ]
    then
        local path=$(awk -F ":" -v q=$OPT_GO '(q==$1){print $2}' $bookmarks_file)
        builtin cd "$path"
    else
        if [ "$args" != "" ]
        then
            builtin cd "$args"
        else
            awk -F ":" '{print $1") "$2}' $bookmarks_file
        fi
    fi

    return 0;
}


# Manage the favourite commands
# List, add, remove commands in a list and execute them using Cntrl-h combination.
function cmd() {
    local TEMP=`getopt -o raph --long remove,add,print,help  -n 'cmd' -- "$@"`

    if [ $? != 0 ] ; then echo "Error on parsing the command line. Try cmd -h" >&2 ; return ; fi

    # Note the quotes around `$TEMP': they are essential!
    eval set -- "$TEMP"

    local OPT_ADD=false
    local OPT_REMOVE=false
    local OPT_PRINT=false
    local OPT_HELP=false
    while true ; do
	case "$1" in
	    -a|--add) OPT_ADD=true ; shift ;;
	    -r|--remove) OPT_REMOVE=true ; shift ;;
	    -p|--print) OPT_PRINT=true ; shift ;;
            -h|--help) OPT_HELP=true ; shift ;;
            --) shift ; break ;;
	    *) echo "Internal error!" ; return 127 ;;
	esac
    done

    local args=()
    for arg do
        args+=("$arg")
    done


    if $OPT_HELP
    then
        echo "Usage: cmd [options] <num>"
        echo -e "Take the command from the list and store to the history. Type Ctrl+h to paste into the command line."
        echo -e "Options:"
        echo -e "\t-p, --print <num>               Print the entry selected"
        echo -e "\t-a, --add <cmd> [<comments>]    Add a command with comments"
        echo -e "\t-r, --remove <num>              Remove a command entry"
        echo -e "\t-h, --help                      Show this help message"
        return 0
    fi

    #################### END OPTION PARSING ############################

    touch $PEARL_HOME/commands

    if $OPT_REMOVE
    then
        if [ ${#args[@]} -eq 1 ]; then
            local cmds=$(sed -e "${args[0]}d" $PEARL_HOME/commands)
            echo "$cmds" > $PEARL_HOME/commands
        else
            echo "Error the --remove option needs only one argument."
            return 127
        fi

    elif $OPT_ADD
    then
        if [ ${#args[@]} -eq 1 ]; then
            local comments=""
        else
            local comments=${args[1]}
        fi
        if [ ${#args[@]} -le 2 ]; then
            echo "${args[0]}%;%$comments" >> $PEARL_HOME/commands
        else
            echo "Error the --add option needs maximum two arguments"
        fi

    elif $OPT_PRINT
    then
        if [ ${#args[@]} -eq 1 ]; then
            awk -v num=${args[0]} -F '%;%' 'NR == num {print $1}' $PEARL_HOME/commands
        else
            echo "Error the --print option needs only one argument."
            return 127
        fi
    else
        # If no file is spcified list all commands
        if [ ${#args[@]} -eq 0 ]; then
            cat $PEARL_HOME/commands | awk -F '%;%' '{print "\033[01;32m"NR": \033[01;33m"$2"\n\033[01;00m   "$1"\n"}'
        elif [ ${#args[@]} -eq 1 ]; then
            local entry=$(awk -v num=${args[0]} -F '%;%' 'NR == num {print $1}' $PEARL_HOME/commands)
            echo "bind '\"\C-g\":\"$entry\"'"  > $PEARL_TEMPORARY/new_cmd
            source $PEARL_TEMPORARY/new_cmd
            echo "Type C-g to get the command"
        else
            echo "Error too many arguments!"
            return 127
        fi
    fi

    return 0
}

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



function todo(){
    local TEMP=`getopt -o p:g:r:d:lh --long priority:go:,remove:,disable:,list,help  -n 'todo' -- "$@"`

    if [ $? != 0 ] ; then echo "Error on parsing the command line. Try todo -h" >&2 ; return ; fi

    # Note the quotes around `$TEMP': they are essential!
    eval set -- "$TEMP"

    local OPT_PRIORITY=""
    local OPT_REMOVE=""
    local OPT_DISABLE=""
    local OPT_GO=""
    local OPT_LIST=false
    local OPT_HELP=false
    while true ; do
	case "$1" in
            -p|--priority) shift; OPT_PRIORITY="$1" ; shift ;;
            -g|--go) shift; OPT_GO="$1" ; shift ;;
            -d|--disable) shift; OPT_DISABLE="$1" ; shift ;;
            -r|--remove) shift; OPT_REMOVE="$1" ; shift ;;
            -l|--list) OPT_LIST=true ; shift ;;
            -h|--help) OPT_HELP=true ; shift ;;
            --) shift ; break ;;
	    *) echo "Internal error!" ; return 127 ;;
	esac
    done

    local args=()
    for arg do
        args+=("$arg")
    done


    if $OPT_HELP
    then
        echo -e "Usage: todo [TODO]"
        echo -e "Detect the todos starting from the directories of the bookmarks having an integer entry key"
        echo -e "and prints only the lines having TODO words. You can also add a TODO in the general list."
        echo "Options:"
        echo -e "\t-p, --priority <num> <key>     Add a priority to the todo."
        echo -e "\t                               Possible values from the most important: 1,2,3,4,5 (default 3)"
        echo -e "\t-d, --disable <key>            Disable temporary a todo in the list"
        echo -e "\t-r, --remove <key>             Remove a todo in the list"
        echo -e "\t-g, --go <key>                 Scan for TODOs only for the entry specified"
        echo -e "\t-l, --list                     List only the general TODO list without scan any folder"
        echo -e "\t-h, --help                     Displays this"
        return 0
    fi


    function sort_todos(){
        # Print lines sorted only if they really exist
        [ -f "$1" ] && cat "$1" | sort -n
    }
    function print_todos(){
    sort_todos $1  | awk -F [:] '{last=$3;for(i=4;i<=NF;i++){last=last":"$i}; col=195+$1; if( $2 == "1"){ msg=1}else{msg=col} print "\033[38;5;"msg"m"NR") "last}'
    }

    function print_scan_todos(){
        local path="$1"
        echo -e "\033[0;33m$path\033[0m"
        local res=$(eye -c -r -w "$path" TODO | awk '{print "\t"$0}')
        if [ "$res" != "" ]; then
            echo "$res"
        else
            echo -e "\t\033[0;36mNothing TODO!\033[0m"
        fi
    }
    function update_todos_file(){
        # Update the content to the todos file
        if [ "$2" == ""  ]; then
            rm -rf "$1"
        else
            [ -f "$1" ] && echo "$2" > "$1"
        fi
    }

    # The format of the todos file is for each row to have:
    # <priority>:<disabled>:<todo>

    # Checks if directory exists
    if [ ! -d "$HOME/.config/ranger" ]; then
        mkdir -p "$HOME/.config/ranger_file"
    fi

    # Just in case the user delete the main files then create them
    local bookmarks_file="$HOME/.config/ranger/bookmarks"
    touch "$bookmarks_file"
    todos_main_file="$PEARL_HOME/todos"
    touch "$todos_main_file"

    if [ "$OPT_GO" != "" ]; then
        local todos_file="$(cd -p "$OPT_GO")/.todos"
    else
        local todos_file="$todos_main_file"
    fi


    if [ "$OPT_REMOVE" != "" ]
    then
        local out=$(sort_todos "$todos_file" | awk -v q=$OPT_REMOVE '(NR!=q){print $0}')
        update_todos_file "$todos_file" "$out"
    elif [ "$OPT_DISABLE" != "" ]
    then
        local out=$(sort_todos "$todos_file" | awk -F [:] -v q=$OPT_DISABLE '{last=$3; for(i=4;i<=NF;i++){last=last":"$i}; if(NR==q){print $1":1:"last} else{print $0}}')
        update_todos_file "$todos_file" "$out"
    elif [ "$OPT_PRIORITY" != "" ]
    then
        if [ -z "$args" ]; then
            echo "You didn't specify the todo key."
            return 128
        fi
        local out=$(sort_todos "$todos_file" | awk -F [:] -v k="$args" -v q="$OPT_PRIORITY" '{last=$3; for(i=4;i<=NF;i++){last=last":"$i}; if(NR==k){print q":"$2":"last} else{print $0}}')
        update_todos_file "$todos_file" "$out"
    elif $OPT_LIST
    then
        print_todos $todos_file
    else
        if [ ${#args[@]} -eq 1 ]; then
            # Append the todo in the todos file
            # Default todo has priority 3
            echo "3:0:${args[0]}" >> "$todos_file"
        elif [ ${#args[@]} -eq 0 ]; then
            if [ "$OPT_GO" != "" ]; then
                print_scan_todos $(cd -p "$OPT_GO")
                echo ""
                print_todos "$todos_file"
                echo ""
            else
                # List all todos
                local list=$(sed -e '/^[^0-9]\+\:/d' -e 's/^[0-9]\+\://g' $bookmarks_file)
                for path in $list
                do
                    print_scan_todos "$path"
                    print_todos "$path"/.todos
                    echo ""
                done
                print_todos "$todos_file"
            fi
        else
            echo "Error too many arguments"
        fi
    fi

}