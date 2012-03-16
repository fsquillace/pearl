#!/bin/sh

function apply(){
    # If the file doesn't exist create it and append the line
    if [ ! -e "$2" ]
    then
        echo "Creating config file: $2"
        #dirp=$(readlink -f `dirname $2`)
        dirp=$(dirname $2)
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
show_stdout=$3
show_stderr=$4
a=`ps aux | grep  -v "grep" | grep "$1"`  #`pidof $1`
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



# Trash command
function trash(){
    mkdir -p $PYSHELL_TEMPORARY

    if [ -z "$1" ] || [ "$1" = -s ] || [ "$1" = --show ]
    then
        ll -a $PYSHELL_TEMPORARY
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
        mv --backup=numbered -f -t $PYSHELL_TEMPORARY $@
    fi

}

# cd to last path after exit
# This functionallows to change the directory 
# to the last visited one after ranger quits.
# You can always type "cd -" to go back
# to the original one.
function ranger(){
    tempfile='/tmp/chosendir'
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
    if [ "$1" = -h ] || [ "$1" = --help ]
    then
        echo "Usage:"
        echo -e "sync [--exclude=PATTERN] FILE1 FILE2 ...\tSync files or directories"
        echo -e "\t\texcluding what mathces with PATTERN"
        echo -e "sync [-h || --help]\t\tDisplays this"
        return 0
    fi

    # introduce --exclude option
    exc_opt=""
    for ((i=1; i<=$#;i++))
    do
        if [[ "${!i}" != *--exclude* ]]
        then
            break
        else
            exc_opt="${exc_opt} ${!i}"
        fi
    done

    #for var in "$@" #Another solution
    for ((j=$i;j<=$#;j++))
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

        abs_path=$(readlink -f "${!j}")

        # If readlink didn't work well skip the following steps
        # because without abs_path variable the next instructions 
        # could be dangerous
        if [ "$?" != "0" ]
        then
            continue
        fi

        rsync -R -C --exclude=.svn ${exc_opt} -uhzravE --delete "$abs_path" "$SYNC_HOME" 
        
        # The following solution doesn't manage deletion of files in the destination
        #cp -v -a --parents -u -r --target-directory $SYNC_HOME/ $(readlink -f $var)
    done

}


# Create a link (that means link instead of copying like sync command)
# with Dropbox/Ubuntu One folder using
# absolute path to maintain the same structure
function symc() {
    if [ "$1" = -h ] || [ "$1" = --help ]
    then
        echo "Usage:"
        echo -e "symc FILE1 FILE2 ...\tLink symbolic files or directories instead of copying"
        echo -e "symc [-u || --unlink] FILE1 FILE2 ...\tRemove the sym link of files or directories"
        echo -e "symc [-c || --clean]\tDelete broken sym links in SYNC directory"
        echo -e "symc [-h || --help]\tDisplays this"
        return 0
    fi

    if [ "$1" == "-c" ] || [ "$1" == "--clean" ]
    then
        echo -e "Cleaning for broken symlinks in $SYNC_HOME. It could take time..."
        find "$SYNC_HOME" -type l ! -execdir test -e '{}' \; -delete
        return 0
    fi


    if [ "$1" == "-u" ] || [ "$1" == "--unlink" ]
    then
        i=2
    else
        i=1
    fi

    #for var in "$@" #Another solution
    for ((j=$i;j<=$#;j++))
    do
        abs_path=$(readlink -f "${!j}")

        # If readlink didn't work well skip the following steps
        # because without abs_path variable the next instructions 
        # could be dangerous
        if [ "$?" != "0" ]
        then
            continue
        fi

        if [ "$1" == "-u" ] || [ "$1" == "--unlink" ]
        then
            rm -v -fr "$SYNC_HOME/$abs_path"
        else
            # It needs to ensure that the file is readble
            test -r "$abs_path"
            if [ "$?" == "0" ]
            then
                # The following solution doesn't manage deletion of files in the destination
                cp -f -s -v -a --parents -u -r --target-directory "$SYNC_HOME" "$abs_path"
                # Wipe out all the files that don't have the read permission
                find "$SYNC_HOME/$abs_path" -type l ! -execdir test -r '{}' \; -delete
            else
                echo -e "The entry "${!j}" don't have read permission."
            fi

            #Tag the file to be shown in ranger
            #if [ "$?" == 0 ]
            #then
                #mkdir -p ~/.config/ranger/
                #echo "$abs_path" >> ~/.config/ranger/tagged
            #fi
            #ln -s $(readlink -f ${!j}) $SYNC_HOME
        fi
    done
}


# This function integrate cd and cd2 in the same command
function cd() {
    if [ -z "$1" ] 
    then
	$PYSHELL_ROOT/bin/cd2
    elif [ "$1" = -g ]
    then
        builtin cd `$PYSHELL_ROOT/bin/cd2 -p $2`
    elif [ "$1" = -a ] || [ "$1" = --add ] || [ "$1" = -r ] || [ "$1" = --remove ] \
	|| [ "$1" = -h ] || [ "$1" = --help ] || [ "$1" = -p ] || [ "$1" = --print ]
    then
        $PYSHELL_ROOT/bin/cd2 $1 $2
    else
	builtin cd $1
    fi
}




