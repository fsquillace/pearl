# pearl(1) options and aliases#

## BASH OPTIONS ##
*cdspell*
    Minor  errors  in  the  spelling  of  a
    directory  component  in  a  cd command will be
    corrected.
*autocd*
    A command name that is the  name  of  a
    directory  is  executed as if it were the 
    argument to the cd command.
*dirspell*
    Bash attempts  spelling  correction  on
    directory  names  during word completion if the
    directory  name  initially  supplied  does  not
    exist.
*histappend*
    The history list  is  appended  to  the
    file  named  by the value of the 'HISTFILE' 
    variable when the shell exits,  rather  than
    overwriting the file.
*checkwinsize*
    Check the window size after each command and,
    if necessary, update the values of LINES 
    and COLUMNS.


## MAIN ALIASES ##
- *~* - is your Home
- *q*=exit
- *f*=fg
- *b*=bg
- *j*=jobs
- *a*="ls -ha"
- *c*="cal"
- *d*="date"
- *e*='$EDITOR'
- *p*='pwd'
- *h*='hostname'
- *t*='tree'
- *l*="ls --group-directories-first --color=auto -h"
- *ll*="l -l"
- *la*="l -a"
- *c*="clear"
- *go*=ping 8.8.8.8
- *goo*=ping www.google.com
- *isconnect* - check whether the computer is connected
- *alert* - send a notification alert
- *scrssi* - Open irssi (a powerful irc client) within screen
- *pypdb* - Execute python script and call PDB when exception is raised
- *sshx* - Enhanced ssh for X11 forwarding and 256 colors
- *less* - less command with case insensitive
