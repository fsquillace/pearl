#@@@@@@@@@@@@@@@@@@
#@@ Aliases
#@@@@@@@@@@@@@@@@@@

alias ..="cd .."
alias ...="cd ../.."
alias "cd.."="cd .."
alias "cd-"="cd -"
alias "cd~"="cd ${HOME}"

# Mini-aliases :)`
alias j="jobs"
alias f="fg"
alias b="bg"
alias q="exit"
alias ls="/bin/ls --color=auto"

# Only the newer version of ls support the option --group-directories-first
ls --group-directories-first &> /dev/null
if [ "$?" -eq 0 ]; then
    alias l="ls --group-directories-first --color=auto -h"
else
    alias l="ls --color=auto -h"
fi

alias a="ls -ha"
alias c="cal"
alias d="date"
alias e='$EDITOR'
alias p='pwd'
alias h='hostname'
alias t='tree'

alias ll="l -l"
alias la="a -l"

alias share="cd ${PEARL_ROOT}/share"
alias home="cd ${HOME}"
alias ~="cd ${HOME}"
alias etc="cd ${PEARL_ROOT}/etc"
alias bin="cd ${PEARL_ROOT}/bin"

# Allows to keep aliases in sudo
alias sudo="sudo "
#alias sudo="sudo -E"    # Useful to keep variables environment when you are root

alias go="ping 8.8.8.8"
alias goo="ping www.google.com"

# Grep-based aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# Looks up to the history
alias hgrep='history | grep -i'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Open screen+irssi
alias scrssi="screen -S scrssi -aARd -c ${PEARL_ROOT}/etc/screenrc -t irssi irssi; clear"

# less case insensitive
alias less="less -i"

# If the system has htop use it!
[ -e /usr/bin/htop ] && alias top="/usr/bin/htop"

# Enhanced ssh for X11 forwarding and 256 colors
alias sshx="TERM=xterm-256color LANG=en_US.UTF-8 ssh -Y"

# Enhanced mosh for 256 colors
alias moshx="LANG=en_US.UTF-8 mosh"

#@@@@@@@@@@@@@@@@@@@
