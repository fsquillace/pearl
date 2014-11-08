# Pearl as an IDE #

This tutorial explains the big potential of pearl to make your life easy
during the development of a software.

Let's suppose you want to develop a web application using Django and having
pearl as your personal IDE.

Please *note* that this example will use tmux as terminal but the same feature
are implemented for GNU screen as well.

Moreover, this tutorial suppose that you already have installed
[pearl framework](https://github.com/fsquillace/pearl)
and [pearl utils mod](https://github.com/fsquillace/pearl-utils).


## Setup the workspace ##

First of all you need choose your workspace directory and mark it using `cd` command.

    cd -a mydjango /this/is/a/very/long/path

In this way your directory will alsways be marked as 'mydjango'. If you want to go
to the directory:

    cd -g mydjango


## Setup the terminal ##

This is the funny part. Once your workspace has been marked with `cd`, you can
use either TMUX in order to create a sessionto the directory

    tmux -g mydjango

In this way, pearl will create a tmux session with name *mydjango* and every time
you create a new window, the directory will be changed automatically according to the `mydjango` mark.

Also, you can use the awesome pearl configuration for TMUX, that allow to have
several essentials keybindings and much more:

    pearl_config_install_update tmux


### Environment in tmux session ###

Usually, when you have to reboot you machine, you need to reopen several programs
in tmux located in different windows. With pearl you can set it once for all.

In '~/.config/pearl/envs' it is possible
to add environments that describe the window structure and the program to execute
for each session.

For example, your django project uses virtualenv and you need to activate it for
each window you are creating. Moreover, let's suppose you want to have
`ranger` file manager in the first window,
`vim` in the second window, the django shell to the third window
and the dbshell in the fourth window, the only thing
you have to do is to create a file *mydjango* in the directory
*~/.config/pearl/envs* with the following content:

    source venv/bin/activate
    [ $PEARL_WINDOW_INDEX -eq 1 ] && ranger
    [ $PEARL_WINDOW_INDEX -eq 2 ] && vim
    [ $PEARL_WINDOW_INDEX -eq 3 ] && ./manage.py shell
    [ $PEARL_WINDOW_INDEX -eq 4 ] && ./manage.py dbshell

This file is a bash script that is executed every time you create a window in
the *mydjango* tmux session.

You can create even more complex window structures of your tmux session if you want,
since pearl provides some variable environments like $PEARL\_SESSION\_NAME,
$PEARL\_WINDOW\_INDEX and $PEARL\_PANE\_INDEX.

There is also a special file named *default* you can create in the same directory
*~/.config/pearl/envs*, which allow to define the generic environment
for any tmux session.


## Setup vim ##

Just use the awesome pearl configuration for vim and enjoy it!

    pearl_config_install_update vim

To install the [vim-python-mode](https://github.com/klen/python-mode):

    pearl_module_install_update vim-python-mode

To get the list of all plugins for vim and more in pearl use:

    pearl_module_list


## Setup git ##

Just use the awesome pearl configuration for git and enjoy it!

    pearl_config_install_update gitconfig


## Install ranger ##

`ranger` is a ncurses file manager with vim like keybindings. I strongly suggest it.

    pearl_module_install_update ranger


## Trash files ##

If you need to remove a file/directory but you don't want to risk to delete it
forever, use the `trash` command.

    trash myfile1 myfile2 ...

They will be placed in a temporary directory *~/.config/pearl/tmp/* and they will
be deleted only when you exit from the terminal.


## Keep track of your TODOs ##

Sometimes it is hard to wrap up all the TODOs sentences are placed in a big project.
To list all TODOs contained in the files of the directory marked as `mydjango:`

    todo -g mydjango


## Conclusion ##

There are many other functions, config files and modules to check out.
Take a look at the code and enjoy pearl!

