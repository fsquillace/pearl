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
        mv --backup=numbered -f -t $PYSHELL_TEMPORARY $@
    fi

}

# cd to last path after exit
# This functionallows to change the directory 
# to the last visited one after ranger quits.
# You can always type "cd -" to go back
# to the original one.
function ranger(){

    # Checks out into the jobs
    id=$(jobs | grep ranger | awk -F "[][]" '{print $2}')
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
    if [ "$1" = -h ] || [ "$1" = --help ] && [ "$#" == 1 ]
    then
        echo "Usage:"
        echo -e "sync <num> FILE1 FILE2 ...\tSync files or directories"
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

    if [ "$1" == "-l" ] || [ "$1" == "--list" ]
    then
        if [ "$#" == 1 ]
        then
            cat -n $PYSHELL_HOME/syncs | sed -e 's/,/  ->  /g'
        else
            echo "Error on arguments: type sync --help to know the usage."
            return 127
        fi

    elif [ "$1" == "-r" ] || [ "$1" == "--remove" ]
    then
        if [ "$#" == 2 ]
        then
            sed -e "${2}d" $PYSHELL_HOME/syncs | tee $PYSHELL_HOME/syncs
        else
            echo "Error on arguments: type sync --help to know the usage."
            return 127
        fi

    elif [ "$1" == "-a" ] || [ "$1" == "--add" ]
    then
        if [ "$#" == 3 ]
        then
            
            echo "$(readlink -f $2),$3" >> $PYSHELL_HOME/syncs
        else
            echo "Error on arguments: type sync --help to know the usage."
            return 127
        fi
    else
        # Get the line of syncs
        sync_src=$(awk -v num=$1 -F ',' 'NR == num {print $1}' $PYSHELL_HOME/syncs)
        sync_dest=$(awk -v num=$1 -F ',' 'NR == num {print $2}' $PYSHELL_HOME/syncs)


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
            sync_src=$sync_src/
        fi



        #for var in "$@" #Another solution
        # Create all the relative paths
        rel_paths=""
        for ((j=2;j<=$#;j++))
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



            # Manage the case of / for sync_src
            if [ "$sync_src" == "/" ]
            then
                rel_path="$abs_path"

            else
                echo "$abs_path" | grep "^$sync_src" &> /dev/null
                if [ "$?" != 0 ]
                then
                    echo "Error: $abs_path is not in the base src directory $sync_src"
                    return 1
                fi

                # Get the relative path
                rel_path=${abs_path/$sync_src/}

            fi
            # TODO solve the problem of spaces for directory and files
            rel_paths="${rel_path} ${rel_paths}"

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
# TODO Solve the problem of the space for the filename when using symc inside ranger it doesn't work.
function symc() {
    if [ "$1" = -h ] || [ "$1" = --help ]
    then
        echo "Usage:"
        echo -e "symc FILE1 FILE2 ...\tLink symbolic files or directories instead of copying"
        echo -e "symc [-u || --unlink] FILE1 FILE2 ...\tRemove the sym link of files or directories"
        echo -e "symc [-c || --clean]\tDelete broken sym links in the sync directory"
        echo -e "symc [-s || --show]\t\tShows the sync directory"
        echo -e "symc [-h || --help]\tDisplays this"
        return 0
    fi

    if [ "$1" == "-c" ] || [ "$1" == "--clean" ]
    then
        echo -e "Cleaning for broken symlinks in $SYNC_HOME. It could take time..."
        find "$SYNC_HOME" -type l ! -execdir test -e '{}' \; -delete
        return 0
    fi
    if [ "$1" == "-s" ] || [ "$1" == "--show" ]
    then
        ls --color -lh -a "$SYNC_HOME"
        return 0
    fi


    if [ "$1" == "-u" ] || [ "$1" == "--unlink" ]
    then
        i=2
    else
        i=1
    fi
"/"
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
                # Delete recursively all the version control directory
                find "$SYNC_HOME/$abs_path" -type d -name .svn -exec rm -Rf '{}' \;
                find "$SYNC_HOME/$abs_path" -type d -name .cvs -exec rm -Rf '{}' \;
                find "$SYNC_HOME/$abs_path" -type d -name .git -exec rm -Rf '{}' \;

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




