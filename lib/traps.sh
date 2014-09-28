
#########################
# TRAPS
#########################

#*** Handle to clean temp directory
trap "/bin/rm -fr $PEARL_TEMPORARY" QUIT EXIT ABRT KILL TERM


#******* Script to trap USR1 signal in order to handle changing directory
function sigusr2()
{ 
  source $PEARL_TEMPORARY/new_cmd

}

trap "sigusr2" USR2       # catch -USR2 signal
