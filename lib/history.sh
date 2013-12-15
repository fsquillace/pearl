# HIST variables
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTIGNORE="&:l[las]:[bf]g:l:a:j:f:b:e"
export HISTCONTROL=erasedups:ignorespace

## Command history configuration
if [ -z $HISTFILE ]; then
    export HISTFILE=$HOME/.bash_history
fi

# append to the history file, don't overwrite it
shopt -s histappend &> /dev/null
