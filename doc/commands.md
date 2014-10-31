# Commands #

Here there is a list of the most important commands of *pearl*.

Please, check out in the 'lib' directory of *pearl* root directory to see
all the available commands.


### CD ###
Allows to list all your favorite bookmark paths.
Each path is identified by an alphanumeric string (underscore included).
You can easily pass from the current directory to one in the bookmark simply
typing the entry.
Type *cd --help* to see all the available options.

Example of using:

    $ cd -a myproject .
    Adds the current directory into the bookmarks.

    $ cd -g myproject
    Changes the directory to the corresponding entry.

    $ cd
    Lists all the entries.

    $ cd -r 4
    Removes the fourth entry.


### SCREEN AND TMUX ###
The classic *screen* and *tmux* commands are wrapped using two bash functions that add two new options
'--go' ('-g') and '--kill' ('-k').
Basically, it creates a new screen or tmux session in the directory specified according the bookmark files shown
with *cd* command.
Moreover, if a session already exists for such directory, it reattach to the same session.
It is extremely useful when you want to use screen or tmux as an *IDE* and to recall your project
whenever you want. Cool!
If you are using multiple terminals and you call an already attached session in another terminal,
it automatically detaches and reattaches into the new terminal. The session name,
listed using '-list' option for screen and 'ls' for tmux, is called according to the related directory.
So, the sessions are named as '<key>' which 'key' is the key entry in the bookmarks file.
If *screen* or *tmux* do not find the key specified with '-g' option in the bookmarks file, it will creates
a new session from the current directory. In this case a session is identified only by its key and, so,
the session is named as '<key>'.
In order to close all windows of a session the option '--kill' ('-k') can be used. It basically executes
the command 'quit' of screen of 'kill-session' off tmux for the specified session.
Furthermore, when using screen or tmux with '-g' option a nice statusbar will appear in the bottom
of the terminal if the configuration file 'screenrc' or 'tmux.conf' from 'pearl\_settings' were activated.

Example of using:

    $ screen/tmux -g myproject
    Creates a new screen to the directory specified in the bookmark with entry my\_project.
    If the screen session already exists it recall the old screen session.

    $ screen -list
    Lists the already created lists.

    $ tmux ls
    Lists the already created lists.

    $ screen/tmux -k myproject
    Close the session for the bookmark with entry my\_project.


### SSH_PEARL AND SSH_MINI_PEARL ###
*ssh_pearl* and *ssh_mini_pearl* are both ssh wrappers that allow to get the ease of using *pearl* also in
a remote host! It uses exactly the same syntax as ssh command and just add a bunch of code for installing *pearl*.

Example:

    $ ssh_pearl myuser@myserver.com
    Access as myuser in myserver.com with *ssh* and install pearl.

The main differences between ssh_pearl and ssh_mini_pearl are:

*ssh_pearl* try to install a complete version of *pearl*.
If the remote host does not have git installed, *pearl* will
be installed directly downloading the lastest pearl tarball with wget command.

*ssh_mini_pearl* is particularly useful when you just want a small solution which you can define your own
aliases and functions. Basically, it transfers some modules contained
in 'lib/' folder (namely aliases.sh, options.sh, ops.sh and history.sh) and
the user defined file '~/.config/pearl/pearlsshrc'
to a unique file stored in '/tmp' directory of the remote machine!


### TODO ###
Allows recursively to search for TODOs inside every files in the directories
specified by the user. It is also possible to add new generics TODOs in the
default file. Type *todo --help* to see all the available options.

Example of using:

    $ todo
    Lists the generics TODOs and the TODOs contained into every files in the
    directories specified by the user.

    $ todo 'This is a new TODO'
    Adds a new TODO into the default file.

    $ todo -r 'NUM'
    Removes the TODO specified by the user.

    $ todo -a '<new/path>'
    Adds a new path to look for TODOs.

    $ todo -l
    Lists the available paths.

    $ todo -d 'NUM'
    Removes the paths specified by the entry.


### CMD ###
Allows to list your own favorite commands. Type *cmd --help* to see all the
available options.

Example of using:

    $ cmd
    Lists all the commands

    $ cmd -a "ls -l" "This is the corresponding comment"
    Adds a new command

    $ cmd 'NUM'
    Stores the corresponding command specified by the entry. Then, you just
    need to type Cntrl-g to put it in the command line. 


### EYE ###
EYE searches (also recursively) if substrings match with the specified pattern, 
into each text or pdf file.

Example of using:

    $ eye -r . "python"
    Searches recursively into the current directory the text files which contain the
    word "python"

    $ eye -r -p . "python"
    Same as above but also search for pdf files.

    $ eye -r -c  . "Line-[0-9]+"
    Same as above but matching using a regular expression and case sensitive.
    For example, the string "Line-235" matchs with the regex above.


### SYNC ###
SYNC is an awesome command that allows you to synchronize your data
using a synchronization system such as Dropbox/Ubuntu One in a very fashion
way. You need to install rsync to use this command.
SYNC allows you to define a base directory for source and destination in which you can
create a mirror between them.
For instance, if you have a rule that
indicate the source as '/home/david' and the destination as '/home/phil'
so, you can copy the directory '/home/david/mydir/mydir2' and it will be
placed into the destination as '/home/phil/mydir/mydir2' accordingly to
the rule.
SYNC uses rsync and it allows to create a perfect mirror updating the sync directory
with only the modified files.

You could add new rules using as destination directory a remote machine. For example,
you can synchronize files or directory directly on another remote machine:

    $ sync -a ~ user@domain.com:~
    $ cd ~
    $ sync 1 'mydir/myfile'

NOTE: Don't forget to use *colon* if you specify a machine location.
See *sync --help* to know all the details of how using this command.

Example of using:

    *$ sync -a* '/home/david/' '/home/david/Dropbox/'
    Add a new rule to mirror with Dropbox directory.
    *$ sync* 1 'mydata' 'mydir/video/'
    The files and directories 'mydata' and 'mydir/video' must be on '/home/david'. 
    If so, SYNC synchronizes all the files specified respectively into
    '/home/david/Dropbox/mydata' and '/home/david/Dropbox/mydir/video/'.


### SYMC ###
SYMC is still better than SYNC! It allows you to synchronize your data
using a synchronization system such as Dropbox/Ubuntu One in a very fashion
way by creating symlinks of the files instead of copying them.
SYMC build the same filesystem structure starting from the sync directory
specified by the environment variable '$SYNC\_HOME'. For instance, if you want to
sync the file '~/.bashrc' it will be copied in '$SYNC\_HOME/~/.bashrc' by cp
command. When updating/removing your files, they will be automatically synchronized 
by your sync system so that you don't need to sync manually every time and you won't 
lose your data anymore!

In '~/.pearl/pearlrc' you can specify your sync directory in the environment
variable '$SYNC\_HOME' (to default is '~/Dropbox').
See symc --help to know all the details of how using this command.

Example of using:

    $ symc /home/david/ /etc/
    Synchronizes all the files in the '/home/david' and '/etc/' respectively into
    '$SYNC\_HOME/home/david' and '$SYNC\_HOME/etc' creating symlinks.

    $ symc -m 3145728 --exclude Dropbox --exclude .git -e .svn -e .cvs ~
    Synchronizes all the files in the home directory with size lesser
    than 3MB (3145728=3MB)  excluding all the .git, .svn, .cvs folders.
    This is awesome and you can use it if you want to save most of your data
    periodically using cron.


### TAILF ###
The command is similar to tail -f but it also highlights log keywords such as DEBUG, INFO, WARN, ERROR.
tailf requires perl.

