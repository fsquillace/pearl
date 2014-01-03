# pearl(1) commands #

## COMMANDS ##
Here there is a list of the most important commands of *pearl*. There are
also other useful commands for Archlinux such as:
*pacaur*
    Very small program similar to yaourt.
*paclist*
    Lists all the installed package ordered by the size or the installation
    date.

Please, check out in the 'bin' directory of *pearl* root directory to see
all the available commands.

### CD ###
Allows to list all your favorite bookmark paths.
Each path is identified by an alphanumeric string (underscore included).
You can easily pass from the current directory to one in the bookmark simply
typing the entry.
Type *cd --help* to see all the available options.

Example of using:

    *$ cd -g* my\_project
    Changes to the directory in the fourth entry.

    *$ cd*
    Lists all the entries.

    *$ cd -a* pippo .
    Adds the current directory into the table.

    *$ cd -r* 4
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

    *$ screen/tmux -g* my\_project*
    Creates a new screen to the directory specified in the bookmark with entry my\_project.
    If the screen session already exists it recall the old screen session.

    *$ screen -list*
    Lists the already created lists.

    *$ tmux ls*
    Lists the already created lists.

    *$ screen/tmux -k my\_project*
    Close the session for the bookmark with entry my\_project.

### TODO ###
Allows recursively to search for TODOs inside every files in the directories
specified by the user. It is also possible to add new generics TODOs in the
default file. Type *todo --help* to see all the available options.

Example of using:

    *$ todo*
    Lists the generics TODOs and the TODOs contained into every files in the
    directories specified by the user.

    *$ todo* 'This is a new TODO'
    Adds a new TODO into the default file.

    *$ todo -r* 'NUM'
    Removes the TODO specified by the user.

    *$ todo -a* '<new/path>'
    Adds a new path to look for TODOs.

    *$ todo -l*
    Lists the available paths.

    *$ todo -d* 'NUM'
    Removes the paths specified by the entry.

### CMD ###
Allows to list your own favorite commands. Type *cmd --help* to see all the
available options.

Example of using:

    *$ cmd*
    Lists all the commands

    *$ cmd -a* "ls -l" "This is the corresponding comment"
    Adds a new command

    *$ cmd* 'NUM'
    Stores the corresponding command specified by the entry. Then, you just
    need to type Cntrl-g to put it in the command line. 

### MAN2 ###
MAN2 is a minimal manual to get essentials snippet information about all the
important commands. *man2* is able to scan manuals in a xml format that are stored in both
'$PEARL\_ROOT/share/mans/' and '$PEARL\_HOME/mans/'.
You can create your own manual xml file for storing all the information
you need. Just copy the manual xml template file from '$PEARL\_ROOT/share/mans/mans\_example.xml'
to '$PEARL\_HOME/mans/your\_man.xml'.
Type *man2 --help* to see all the available options.

Example of using:

    *$ man2* 'keyword'
    Search "keyword" into the db.

### EYE ###
EYE searches (also recursively) if substrings match with the specified pattern, 
into each text or pdf file.

Example of using:

    *$ eye -r* . "python"
    Searches recursively into the current directory the text files which contain the
    word "python"

    *$ eye -r -p* . "python"
    Same as above but also search for pdf files.

    *$ eye -r -c*  . "Line-[0-9]+"
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

//Like to rsync you can exclude some files or directories that match with a
//pattern. For example if you don't want sync makefiles:
//------------------------------------------------
//sync --exclude=Makefile --exclude=makefile mydir
//------------------------------------------------
//NOTE: The exclude feature is not currently available for this version of
//*pearl*

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

    *$ symc* /home/david/ /etc/
    Synchronizes all the files in the '/home/david' and '/etc/' respectively into
    '$SYNC\_HOME/home/david' and '$SYNC\_HOME/etc' creating symlinks.

    *$ symc* -m 3145728 --exclude Dropbox --exclude .git -e .svn -e .cvs ~
    Synchronizes all the files in the home directory with size lesser
    than 3MB (3145728=3MB)  excluding all the .git, .svn, .cvs folders.
    This is awesome and you can use it if you want to save most of your data
    periodically using cron.

### S FOR SSH ###
The *s* command represents a wrapper of SSH that allows to easily install *pearl* for remote
host. It uses exactly the same syntax as ssh and just add a bunch of code for install *pearl*.

Example of using:

    *$ s* myuser@myserver.com
    Access as myuser in myserver.com with *ssh*. Before spawn an interactive shell,
    the *s* check is *pearl* is already installed into myserver. If *pearl* is
    installed *s* updated *pearl* with the last version, otherwise it creates a
    copy of *pearl* in '~/.pearl' and spawn a bash terminal with the pearl
    configuration file.

### PROMPT CONTEXT ###
There is a command called 'pearl\_switch' that allow to change the appearance of the terminal.
Each context is stored in '$PEARL\_ROOT/etc/context'. The script simply change the
variables environment 'PS1' and 'PROMPT\_COMMAND'. There are two main contexts available:

* def - It is the default context. It is able to dinamically show the error code of the last command, the background jobs, the number of trashed files (see TRASH command for details) and the current git branch.

    [22:24:17 130 4 2 feel@myarch {master} pearl $]>

* ops - It is used for system administration. Useful for checking memory, load avg, etc.
The first three columns measure CPU and IO utilization of the last one, five, and 15 minute periods.
The fourth column shows the number of currently running processes and the total number of processes.
The last column displays the last process ID used.

    678/3844MB      0.47 0.51 0.52 2/273 30568
    [22:03:56 0  feel@myarch pearl $]>

In order to change the context type:

    pearl\_switch <context\_name>

You can install the famous *liquidprompt*, that works for both bash and zsh, just typing
*pearl\_install\_liquidprompt*. For further info go here: 'https://github.com/nojhan/liquidprompt'
You can create your own context just creating a file in '$PEARL\_HOME/etc/context'.

### TAILF ###
The command is similar to tail -f but it also highlights log keywords such as DEBUG, INFO, WARN, ERROR.
tailf requires perl.

