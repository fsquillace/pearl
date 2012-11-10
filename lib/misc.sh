#!/bin/sh

function apply(){
    # If the file doesn't exist create it and append the line
    if [ ! -e "$2" ]
    then
        echo "Creating config file: $2"
        #dirp=$(readlink -f `dirname $2`)
        local dirp=$(dirname $2)
        mkdir -p $dirp
        touch "$2"
    fi
    # Check if already exists the
    # line into the file
    grep "$1" "$2" &> /dev/null
    if [ "$?" = "1" ]
    then
        echo "Sourcing $2 config. Uncomment in $2 if you don't want it."
        echo "" >> $2
        echo "$1" >> $2
    fi
}



function pyshell_logo(){
cat "$PYSHELL_ROOT/share/logo/logo-ascii.txt"
}

notifier(){
## Check out the log files $TEMPORARY/pyshell.out $TEMPORARY/pyshell.err and notify the user
## -e show the error
## -o show the output
## -a show all
## no option return the notify !!
#if [ -f $TEMPORARY/notify.* ]
#then
    
    #difout=$(diff $TEMPORARY/pyshell.out $TEMPORARY/notify.out)
    #diferr=$(diff $TEMPORARY/pyshell.err $TEMPORARY/notify.err)
    
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
    #cp $TEMPORARY/pyshell.out $TEMPORARY/notify.out
    #cp $TEMPORARY/pyshell.err $TEMPORARY/notify.err

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
        sleep $2 && nohup $1 1>> $TEMPORARY/pyshell.out 2>> /dev/null &
    elif [ "$show_stdout" = "false" -a "$show_stderr" = "true" ]; then
        sleep $2 && nohup $1 2>> $TEMPORARY/pyshell.err 1>> /dev/null &
    elif [ "$show_stdout" = "true" -a "$show_stderr" = "true" ]; then
        sleep $2 && nohup $1 1>> $TEMPORARY/pyshell.out 2>> $TEMPORARY/pyshell.err &
    fi

fi
}

# TODO the variable pkgdir is not well set.
function pyshell_update(){
    local srcdir=/tmp/pyshell
    local pkgdir=$PYSHELL_ROOT


    mkdir -p $srcdir
    cd $srcdir
    wget https://aur.archlinux.org/packages/py/pyshell/PKGBUILD
    source PKGBUILD
    wget -O pyshell.tar.gz $source
    tar -xzvf pyshell.tar.gz

    build

    cd $pkgdir
    rm -rf $srcdir

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
        echo "Usage: eye [options] [path] pattern"
        echo "Options:"
        echo "-h, --help            show this help message and exit"
        echo "-c, --case-sensitive  Case sensitive."
        echo "-r, --recursive       Recursive."
        echo "-w, --whole-words     Whole words."
        echo "-p, --pdf             Search in .pdf files too."
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
    mkdir -p $PYSHELL_TEMPORARY

    if [ -z "$1" ] || [ "$1" = -s ] || [ "$1" = --show ]
    then
        ls --color -lh -a $PYSHELL_TEMPORARY
    elif [ "$1" = -e ] || [ "$1" = --empty ]
    then
        rm -rf $PYSHELL_TEMPORARY/*
    elif [ "$1" = -h ] || [ "$1" = --help ]
    then
        echo "Usage:"
        echo -e "trash FILE1 FILE2 ...\t\tMoves to trash the files"
        echo -e "trash [-s || --show]\t\tShows the trash"
        echo -e "trash [-e || --empty]\t\tEmpties the trash"
        echo -e "trash [-h || --help]\t\tDisplays this"
    else
        mv --backup=numbered -f -t $PYSHELL_TEMPORARY "$@"
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

    # Checks out into the jobs
    local id=$(jobs | grep ranger | awk -F "[][]" '{print $2}')
    if [ "$id" != "" ]
    then
        fg $id
        return
    fi

    # Checks out if the user pressed S key
    ps -t `tty` -o comm= | grep ranger &> /dev/null
    if [ "$?" == "0" ]
    then
        exit
        return # Ensures that it returns anyway if there are jobs stopped
    fi

    local tempfile='/tmp/chosendir'
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
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
        echo "Usage:"
        echo -e "sync [-R || --reverse] <num> FILE1 FILE2 ...\tSync files or directories"
        echo -e "\t\tusing the <num> entry"
        echo -e "sync [-l || --list]\t\tList all the sync entry"
        echo -e "sync [-a || --add] <local src> <local/remote dest>\t\tAdd a sync entry"
        echo -e "sync [-r || --remove] <num>\t\tREmove a sync entry"
        echo -e "sync [-h || --help]\t\tDisplays this"
        return 0
    fi

    # If the file doesn't exist create it with a default entry
    if [ ! -f $PYSHELL_HOME/syncs ]
    then
        echo "/,~/Dropbox" >> $PYSHELL_HOME/syncs
    fi

    if $OPT_LIST #|| [ "$1" == "--list" ]
    then
        cat -n $PYSHELL_HOME/syncs | sed -e 's/,/  ->  /g'

    elif $OPT_REMOVE #|| [ "$1" == "--remove" ]
    then
        sed -e "${2}d" $PYSHELL_HOME/syncs | tee $PYSHELL_HOME/syncs

    elif $OPT_ADD #|| [ "$1" == "--add" ]
    then
        echo "$(readlink -f $ARG1_ADD),$ARG2_ADD" >> $PYSHELL_HOME/syncs
    else
        # Get the line of syncs
        local sync_src=$(awk -v num=$1 -F ',' 'NR == num {print $1}' $PYSHELL_HOME/syncs)
        local sync_dest=$(awk -v num=$1 -F ',' 'NR == num {print $2}' $PYSHELL_HOME/syncs)
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
            builtin cd $sync_src
            rsync --relative -C --exclude=.svn -uhzravE --delete ${rel_paths} "$sync_dest"
            builtin cd - &> /dev/null

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
        echo "Usage:"
        echo -e "symc [FILE1 FILE2] ...\tLink symbolic files or directories instead of copying (by default takes the current directory)"
        echo -e "symc [[-m || --max-size] BYTES] [FILE1] ...\tMax size in BYTES for each file to be symced."
        echo -e "symc [[-e || --exclude] PATTERN] [FILE1] ...\tExclude some file or directory that match to the PATTERN."
        echo -e "symc [-u || --unlink] [FILE1 FILE2] ...\tRemove the sym link of files or directories"
        echo -e "symc [-c || --clean]\tDelete broken sym links in the sync directory"
        echo -e "symc [-s || --show]\tShows the sync directory"
        echo -e "symc [-h || --help]\tDisplays this"
        return 0
    fi

    local args=()
    for arg do
        args+=("$arg")
    done

    # If no file is spcified take the current directory
    if [ ${#args[@]} -eq 0 ]; then
        local args=(".")
    fi



    if $OPT_SHOW && [ ${#args[@]} -gt 0 ]; then
        echo "Error: No arguments with --show option!" ; return 127 ;
    elif $OPT_CLEAN && [ ${#args[@]} -gt 0 ]; then
        echo "Error: No arguments with --clean option!" ; return 127 ;
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

            # Calculate the directories
            du $exc_opt -b "$abs_path" | awk -F '[\t]' '{print $2;}' > /tmp/tmp_symc

            local DU=`du $exc_opt -ab "$abs_path"`

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
            #find "$SYNC_HOME/$abs_path" -type l ! -execdir test -r '{}' \; -delete

        fi
    done
}


# This function integrate cd and cd2 in the same command
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
        echo "Usage: cd [OPT] [KEY]"
        echo -e "cd\tList all the entries"
        echo -e "cd -g [KEY]\tGo to the directory specified by the key"
        echo -e "cd [-a || --add] PATH\tAdd the specified PATH"
        echo -e "cd [[-r || --remove] KEY\tRemove an entry"
        echo -e "cd [-p || --print] KEY\tPrint the PATH entry (useful for pipe command)"
        echo -e "symc [-h || --help]\tDisplays this"
        return 0
    fi

    local args=()
    for arg do
        args+=("$arg")
    done

    #################### END OPTION PARSING ############################

    if [ "$OPT_ADD" != ""  ]
    then
        local abs_path=$(readlink -f "$OPT_ADD")
        local alphnum="abcdefghilmnopqrstuvwykzxABCDEFGHILMNOPQRSTUVZWYKX0123456789"
        local pos=$(expr $RANDOM % ${#alphnum})
        local key=${alphnum:$pos:1}
        echo "$key:$abs_path" >> $HOME/.config/ranger/bookmarks
    elif [ "$OPT_REMOVE" != "" ]
    then
        local bookmrks=$(sed -e "/$OPT_REMOVE:.*/d" $HOME/.config/ranger/bookmarks)
        echo "$bookmrks" > $HOME/.config/ranger/bookmarks
    elif [ "$OPT_PRINT" != "" ]
    then
        awk -F ":" -v q=$OPT_PRINT '(q==$1){print $2}' $HOME/.config/ranger/bookmarks
    elif [ "$OPT_GO" != "" ]
    then
        local path=$(awk -F ":" -v q=$OPT_GO '(q==$1){print $2}' $HOME/.config/ranger/bookmarks)
        builtin cd "$path"
    else
        if [ "$args" != "" ]
        then
            builtin cd $args
        else
            awk -F ":" '{print $1") "$2}' $HOME/.config/ranger/bookmarks
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
        echo "Usage:"
        echo -e "cmd <num>\t\tTake the command from the list and store to the history. Type Ctrl+h to paste into the command line."
        echo -e "cmd [-p || --print] <num>\t\tPrint the entry selected"
        echo -e "cmd [-a || --add] <cmd> [<comments>]\t\tAdd a command with comments"
        echo -e "cmd [-r || --remove] <num>\t\tRemove a command entry"
        echo -e "cmd [-h || --help]\t\tDisplays this"
        return 0
    fi

    # If the file doesn't exist create it with a default entry
    if [ ! -f $PYSHELL_HOME/commands ]
    then
        touch $PYSHELL_HOME/commands
    fi


    if $OPT_REMOVE
    then
        if [ ${#args[@]} -eq 1 ]; then
            local cmds=$(sed -e "${args[0]}d" $PYSHELL_HOME/commands)
            echo "$cmds" > $PYSHELL_HOME/commands
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
            echo "${args[0]}%;%$comments" >> $PYSHELL_HOME/commands
        else
            echo "Error the --add option needs maximum two arguments"
        fi

    elif $OPT_PRINT
    then
        if [ ${#args[@]} -eq 1 ]; then
            awk -v num=${args[0]} -F '%;%' 'NR == num {print $1}' $PYSHELL_HOME/commands
        else
            echo "Error the --print option needs only one argument."
            return 127
        fi
    else
        # If no file is spcified list all commands
        if [ ${#args[@]} -eq 0 ]; then
            cat $PYSHELL_HOME/commands | awk -F '%;%' '{print "\033[01;32m"NR": \033[01;33m"$2"\n\033[01;00m   "$1"\n"}'
        elif [ ${#args[@]} -eq 1 ]; then
            local entry=$(awk -v num=${args[0]} -F '%;%' 'NR == num {print $1}' $PYSHELL_HOME/commands)
            echo "bind '\"\C-h\":\"$entry\"'"  > $PYSHELL_TEMPORARY/new_cmd
            source $PYSHELL_TEMPORARY/new_cmd
        else
            echo "Error too many arguments!"
            return 127
        fi
    fi

    return 0
}
