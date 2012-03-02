#!/bin/sh

apply(){
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



pyshell-logo(){
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
