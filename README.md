# pearl(1) #

## NAME ##
pearl - An enhanced shell bash framework

## SYNOPSIS ##
*source* *<path/to/pearl>/pearl*

*bash --rcfile <path/to/pearl>/pearl*

## DESCRIPTION ##
*pearl* is an enhanced and lightweight shell framework that allows
to improve the way of using the shell Bash GNU/Linux and automate many daily
activities of the system administrator. Basically, *pearl* contains
several variables, functions, aliases, configuration files and commands
out of the box. *pearl* also contains important configurations files
vimrc, bashrc, inputrc and many others.

The main goal of pearl is to provide for both expert and beginner users a
starting point respectively, for using quickly the shell terminal and learning
how to create customized functions, aliases and managing configuration files of the
main open source programs. *pearl* is not meant to give a static configuration
for the users but it provides the freedom to customize as much as they want.

Only in the best shell you will find a pearl!

## INSTALLATION ##
There are two ways for installing pearl depending if the user
has either the root permission or not. This is due to the fact that *pearl*
appears extremely useful also in case the user has a non-root
access to a remote server but, the user wants all the advantages of using
*pearl*. Anyway, there is a bash function called *s* (more details in COMMANDS section),
that allows to automatically install *pearl* before accessing to a SSH session!

### ROOT PERMISSION ###
If you use Archlinux you can install it from the AUR typing:

    $ yaourt -S pearl
    $ source /opt/pearl/pearl

Open a new terminal and a *pearl* will be directly activated.

In the future there will be a Launchpad repository for distributions
Debian-based.

### NON ROOT PERMISSION (GIT REPOSITORY) ###
Probably the best way of installing *pearl* is to place it in a hidden subdirectory
of ~. If you do not have root permission, you can directly install *pearl* by the
git repository. Type the following commands:

    $ git clone 'git://github.com/fsquillace/pearl.git' $HOME/.pearl
    $ source $HOME/.pearl/pearl

If you are using *pearl* for the first time you probably do not have the
configuration directory in '~/.config/.pearl'. In this case, the command
'pearl\_settings' will be executed. 'pearl\_settings' will ask you if you want to
apply new config for the files '.bashrc', '.vimrc', '.inputrc', '.screenrc', '.Xdefaults',
'.gitconfig', '.gitignore'.
It consists
just on appending a line for each of those files. This new configuration are not mandatory
but they are strongly recommended (see below to have information about the vim, bash and
readline configurations made by *pearl*)

You can easily change or reset the settings of pearl whenever you want executing 'pearl\_settings' again.
You can also install *pearl* in other place different from your home.

If you choose to install the *pearl* configurations and you open a new terminal the following scripts will be executed:

- *.bashrc*
    pearl append a new line in '.bashrc' in order to startup *pearl* once a terminal is opened.
- *pearl*
    pearl introduce every alias, variable and script that the *pearl* commands need for the correct execution.
- *.pearlrc*
    Contains all the configuration that you need to set after the execution of pearl.
    This can be useful when you want directly edit some alias, variable or script of pearl.

## UPDATE PEARL ##
In case *pearl* was installed with root permission, *pearl* can be updated using the
same package manager of the system. If *pearl* was installed using Git repository,
*pearl* provides a handy command to help you update it 'pearl\_update'.

## UNINSTALL PEARL ##
There is no reason to uninstall *pearl*, it is too awesome :). Anyway, *pearl* provides
a nice function 'pearl\_uninstall' that uninstall completely in a really clear way *pearl* itself.

## CONFIGURATIONS ##
*pearl* applies several new configuration for vim, bash and inputrc. This
operation allows to get better experience of your shell. 

### Vimrc ###
*pearl* introduces a sourcing into your own .vimrc file configuration at the
end of the file. You can just uncomment it if you do not want this by typing 'pearl\_settings'.
This is particular useful when you want to type file in remote server so as
having all the feature you are used to. Here is a small list of the
feature enabled in VIM:

*Highlights and autocompletion*

    For java, python, javascript, html, css, c/c++,xml and more;
*Smart Home*

    The key 'Home' has the special power of moving the cursor to the
    first character of the line;
*Write with sudo*

    Use :Wsudo command to write a file with sudo if you forgot it when opening the file;
*Indent Folding*

    Allows to use folding when the file is indented. Use 'za' to toggle 
    a fold it's the only command worth it;

*Moving among windows*

- *Up* -> 'Cntrl+k'
- *Down* -> 'Cntrl+j'
- *Left* -> 'Cntrl+h'
- *Right* -> 'Cntrl+l'

*Resizing current window*

- *Increase vertically* -> '+'
- *Decrease vertically* -> '-'
- *Increase horizontally* -> '>'
- *Decrease vertically* -> '<'
- *Maximize* -> '\_'

*Spelling*

- *Select Language* -> '\ol' (i.e. it,en,es. The dict will be downloaded if it doesn't exist.)
- *Select spell file* -> '\of'
- *Correct word* -> '\os' or 'Cntrl+x s' (in insert mode)
- *Remove spelling* -> '\or'
- *Add word in dict* -> '\oa'
- *Go to next error* -> '\on'
- *Go to previous error* -> '\op'

*Search and replace*

- *Search and replace* -> '\r'

*File choosers*

- *Explore* -> '\e'
- *Ranger* -> '\o'

*Session*

- *New session* -> '\sa' (automatically saved in '$HOME/.vim/sessions')
- *Open session* -> '\so'
- *Remove session* -> '\sr'

Extra plugin configurations:

*Nerd Commenter*

- *Comment* -> 'Cntrl-,'

*Buffer explorer*

- *Select buffer* -> '\b'
- *Open vertical window* -> '\v'
- *Open horizontal window* -> '\h'

*pearl* provides also few useful plugins for VIM by default that are stored in '$PEARL\_ROOT/etc/vim'.
They are:

*Pathogen*
    Manage your runtimepath
*Nerd Commenter*
    To comment lines for all file types;
*Buffer Explorer*
    Allow easily to change between buffers;
*Super Tab*
    Integrate all the VIM feature using only the TAB key;
*Gnupg*
    Plugin for transparent editing of gpg encrypted files
*Spellfile*
    Download spell file when searching for the given language
*Airline*
    Lean & mean statusline for vim that's light as air
*Syntastic*
    Syntax checking hacks for vim
*Fugitive*
    A Git wrapper so awesome, it should be illegal

In particular *pathogen* is used to easily place plugins in the directory '$HOME/.vim/bundle' (Take a look in the project 'https://github.com/tpope/vim-pathogen').
In order to install important VIM plugin *pearl* provides useful bash scripts with prefix *pearl\_install*
Currently, you can install/upgrade the fantastic syntax checker plugin called *syntastic*
through *pathogen* simply typing: *pearl\_install\_syntastic*.

### Bashrc ###
*pearl* introduces a sourcing into your own .bashrc file configuration at the
end of the file. You can just uncomment it if you do not want this *pearl*
feature.

In this way *pearl* automatically startup when opening a new shell.

### Inputrc ###
*pearl* introduces a sourcing into your own '.inputrc' file configuration at the
end of the file. You can just uncomment it if you do not want this *pearl*
feature.
The most important feature applied with inputrc are:

- Case insensitive typing directories;
- Typing the prefix of an old command you will get the entire command once
      typing the up/down arrows or Cntrl-p/Cntrl-n keys.

### Ranger/commands.py ###
*pearl* introduces a sourcing into the config file of ranger commands.py
There are several commands for ranger that *pearl* introduces:

*:trash*
    Move to trash the selected files
*:trash* [*-s* || *--show*]
    Show the trash
*:trash* [*-e* || *--empty*]
    Empty the trash


*:sync <num>*
    Sync the selected files on the entry <num>
*:sync* [*-l* || *--list*]
    Show the list of the sync entries
    To know all the available option type: *sync -h*.
    For more details see the SYNC section below.

*:symc*
    Create symlinks of the selected files into sync directory
*:symc -u*
    Remove the symlinks of the selected files
*:symc* [*-s* || *--show*]
    Show the sync directory
    Allows to sync the files selected creating symlinks instead of copying them 
    into the SYNC\_HOME specified in ~/.config/pearl/pearlrc.
    For more details see the SYMC section below.

*:extract*
    Extract the files contained from to the selected compress files.

*:compress* 'FILE.EXT'
    Compress the selected files into 'FILE.EXT' where EXT can be any compress
    extension (.tar.gz .zip .rar ...).

### GitConfig ###
A note worth to be noticed is that the gitconfig creates a file in 
~/.gitignore in order to have a general gitignore file. You can put all
the extension files that do not need to be pushed into any git repositories.

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
Each context is stored in '$PEARL\_ROOT/etc/context' and it is a script that simply change the
environment variable 'PS1' and 'PROMPT\_COMMAND'. There are three main contexts available:

* def - It is the default context. It will show the basic information.
    [22:00:09 0 feel@myarch pearl $]>
* dev - It is used for development purpose. It shows information of the current git branch.
    [22:00:09 0 {master} feel@myarch pearl $]>
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

### BACKUP ###
BACKUP command makes sessions of backup including files and directories.
Each backup can be sent to a mailbox by specifying the account credentials
into your config file. The config file is located in
'~/.config/pearl/etc/backup.conf'. If it doesn't exist the program BACKUP will
find backup.conf in the etc directory of pearl root (to default is
'/opt/pearl/etc/backup.conf').
It's possible to create several sessions instead of using only one config
file. Moreover, you can create files directly in a directory called 'backup.d'
and recall them by the BACKUP program to apply backups of the corresponding
file and directories reported into the session.
The backup will be stored according to the variable 'bkp\_dir' specified into
backup.conf file (to default the directory is '~/.config/pearl/backups').
See backup --help to know all the details of how using this command.

Example of using:
    *$ backup -s*
    Lists all the sessions created by the user in 'etc/backup.d' directory.

    *$ backup*
    Applies a backup for the main session in 'backup.conf' file. The backup
    will be stored in 'bkp\_dir'.

    *$ backup -m mysession1*
    Applies a backup of the session contained in 'backup.d/mysession1' and
    send an email attaching it.

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
- *c*="clear"
- *e*='$EDITOR'
- *p*='pwd'
- *h*='history'
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

## TIPS & TRICKS ##

### DEFAULT PERMISSIONS ###
When you create a new file or directory it will get some default permissions.
You will be the owner. Your default group will be used as the group. And the
mode will normally be world readable or private depending on your umask. The
following values make sense for a umask:

[width="15%"]
|=================================
|umask |file mode  |directory mode
|0022  |-rw-r--r-- |drwxr-xr-x
|0077  |-rw------- |drwx------
|=================================
*pearl* uses the '0022'. For security reasons you can use '0077'.
If you do not want '0022', you can specify the other in 
'~/.config/pearlrc' by typing: *umask* '0077'


### REMOVING FILES WITH TRASH COMMAND ###
*pearl* provides an useful command that allows moving to a trash directory
unneeded files instead of removing directly them using rm command. The
interface used is the same of the command implemented in ranger by *pearl*.
Each shell creates its own trash directory located in
~/.config/.pearl/tmp/`tty`. The command trash will make a backup of each
existing destination file or directory.
Usage:

    *$ trash* 'FILE1' 'FILE2' ...
    Move the files into trash

    *$ trash* [*-s* || *--show*]
    Show the trash

    *$ trash* [*-e* || *--empty*]
    Empty the trash

The trash directory will be removed when exiting from the shell.

### BIND FOR RANGER ###
Cntrl-o starts ranger command

### ONE INSTANCE OF RANGER ###
When typing S key in ranger, it opens a new terminal but you can forget that you have
already an instance of ranger in the same terminal. To avoid of opening nested 
ranger instances, the built-in script ranger in *pearl* allows you to always 
open the last ranger available.

### CHANGING DIRECTORY EXITING FROM RANGER ###
There is a function that allows to change automatically the current directory you are
in ranger as soon as the user quit from ranger programm.
Note that you can return to the original directory by typing "cd -".

### RANGER FILE CHOOSER IN VIM ###
Instead of using the Explorer of Vim to select files in the filysystem, you can
even use ranger. In particular, when you type '\o' you will see an instance of
ranger that allow you to select files. See all the functionality of *pearl*
for Vim in the Vim configuration section.

### INSTALLING AND UPGRADING RANGER ###
Simply type *pearl\_update\_modules* and it will place the program in '$PEARL\_HOME/opt/ranger'.

### BOOT GRAPHICAL APPLICATION AT STARTUP OF X SEVER ###
You can specify in your ~/.xinitrc your applications you want to startup
with some delay with the following bash function:

    source /path/to/pearl/lib/misc.sh
    bootapp pidgin 23

It will boot pidgin after 23 seconds. This function allow to reduce the
overhead of booting the X Server with a lot of application at startup.

### COLORIZE THE HOSTNAME IN PROMPT ###
In order to recognize easily which machine you are currently using,
the hostname information present in the prompt is colorized in function of its value.
In other words, there is a hash function that gives a int value that correspond
to a color for a given hostname string.

### LS\_COLORS ###
The LS\_COLORS variable is set in order to have a nice color for each extension file.
The original configuration was made by 'https://github.com/trapd00r/LS\_COLORS'.


## CONFIG FILES ##
The config files touched by *pearl* are:

* '~/.config/ranger/commands.py'
* '~/.bashrc'
* '~/.vimrc'
* '~/.inputrc'
* '~/.XDefaults'
* '~/.gitconfig'
* '~/.screenrc'
* '~/.zshrc'

## FILES ##
*pearl* creates a config directory in '~/.config/pearl' which include 
several config files. All the temporary directories of the associated shell 
are stored in '~/.config/pearl/tmp'.

The bookmark paths are stored into '~/.config/pearl/bookmarks'.
The TODOs are stored into '~/.config/pearl/todos'.
The commands are stored in '~/.config/pearl/commands'.

## COPYRIGHT ##

       Copyright  (C) 2008, 2009, 2010, 2011, 2012, 2013 Free  Software 
       Foundation, Inc.

       Permission  is  granted to make and distribute verbatim copies
       of this document provided the copyright notice and  this  per‐
       mission notice are preserved on all copies.

       Permission is granted to copy and distribute modified versions
       of this document under the conditions  for  verbatim  copying,
       provided that the entire resulting derived work is distributed
       under the terms of a permission notice identical to this one.

       Permission is granted to copy and distribute  translations  of
       this  document  into  another language, under the above condi‐
       tions for  modified  versions,  except  that  this  permission
       notice  may  be  stated  in a translation approved by the Free
       Software Foundation.

## BUGS ##
	Of course there is no bug in *pearl*. But there may be unexpected behaviors.
	Go to 'https://github.com/fsquillace/pearl/issues' you can report directly
	this unexpected behaviors.

## AUTHORS ##
Filippo Squillace <feel.squally@gmail.com>.

## WWW ##
'https://github.com/fsquillace/pearl'

## Last words ##
[verse, Dante Alighieri, from Divine Comedy]
    Consider your origins:
    You were not born to live like brutes
    but to follow virtue and knowledge.

