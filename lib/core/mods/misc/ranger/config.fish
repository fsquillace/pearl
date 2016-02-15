# Compatible with ranger 1.4.2 through 1.6.*
#
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

set PATH $PATH $PEARL_ROOT/mods/misc/ranger/scripts

# cd to last path after exit
# This functionallows to change the directory 
# to the last visited one after ranger quits.
# You can always type "cd -" to go back
# to the original one.
# This is still beta for Fish!
#function ranger-cd
    #set ranger_command "python $PEARL_ROOT/mods/misc/ranger/scripts/ranger"

    ## Checks out into the jobs if the user pressed the C-z key
    #set id (jobs | grep ranger | awk -F "[][]" '{print $2}')
    #if [ "$id" != "" ]
        #fg $id
        #return
    #end

    ## Checks out if the user pressed S key
    #if [ "$RANGER_LEVEL" != "" ]
        #exit
        #return # Ensures that it returns anyway if there are jobs stopped
    #end

    #set tempfile '/tmp/chosendir'
    #$ranger_command --choosedir="$tempfile" "(pwd)"
##test -f "$tempfile" &&
    #if [ "(cat -- "$tempfile")" != "(echo -n `pwd`)" ]
        #echo (cat "$tempfile")
        #cd (cat "$tempfile")
    #end
    #rm -f -- "$tempfile"
#end

# This binds Ctrl-O to ranger-cd:
bind \co 'ranger'

# TODO for fish
#[ -n "$RANGER_LEVEL" ] && PS1='(in ranger)'"$PS1"
