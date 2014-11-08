#*******************
#** Generics options
#*******************
shopt -s cdspell &> /dev/null
shopt -s autocd  &> /dev/null
shopt -s dirspell &> /dev/null
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize &> /dev/null

#*******************
#** Generic variables
#*******************
export SYNC_HOME=~/Dropbox/
export PYTHONPATH=$PYTHONPATH:$PEARL_ROOT/lib
PATH=${PEARL_ROOT}/bin:${PATH}
export EDITOR=vim
export VISUAL=$EDITOR # some programs use this instead of EDITOR
export MANPATH=$MANPATH:$PEARL_ROOT/man

#*******************
#** Bindings
#*******************
# Prefix sudo to the command
bind '"\C-xs":"\C-asudo \C-e"'

#*******************
#** History
#*******************
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTIGNORE="&:l[las]:[bf]g:l:a:j:f:b:e"
export HISTCONTROL=erasedups:ignorespace
[ -z $HISTFILE ] && export HISTFILE=$HOME/.bash_history
shopt -s histappend &> /dev/null
