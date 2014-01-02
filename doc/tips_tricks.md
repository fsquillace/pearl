# pearl(1) tips and tricks #

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

    source /path/to/pearl/lib/util.sh
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

