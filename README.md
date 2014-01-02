# pearl(1) #

## NAME ##
pearl - An enhanced shell bash framework

## SYNOPSIS ##
*source* *<path/to/pearl>/pearl*

*bash --rcfile <path/to/pearl>/pearl*

## DESCRIPTION ##
*pearl* is an enhanced and lightweight shell framework that allows
to improve the way of using the shell Bash GNU/Linux and automate many daily
activities of the system administrator.
*pearl* comes bundled with a ton of helpful functions, helpers, plugins,
aliases, configuration files and commands all out of the box.
It also contains important configurations files
vimrc, bashrc, inputrc and many others.

The main goal of pearl is to provide for both expert and beginner users a
starting point, respectively, for using quickly the shell terminal
and learning how to create customized functions, aliases and
managing configuration files of the main open source programs.
*pearl* is not meant to give static configurations
for the users but it provides the freedom to customize
them as much as you want.

Only in the best shell you will find a pearl!

## INSTALLATION ##
*pearl* should work with many recent release of bash.

### USING GIT... ###

For sure the best way of installing *pearl* is to place it
in a hidden subdirectory of HOME (by default ~/.pearl).
Type the following commands:

    $ git clone 'git://github.com/fsquillace/pearl.git' $HOME/.pearl
    $ source $HOME/.pearl/pearl

### ...OR EVEN SMARTER... ###

Using the *install.sh* script, pearl can be installed even on a
machine that doesn't have git installed!
*install.sh* installs or updates pearl with either git or wget depending
if git has been installed into the machine.

    $ wget --no-check-certificate -O - https://raw.github.com/fsquillace/pearl/master/lib/install.sh | bash
    $ source $HOME/.pearl/pearl

### ...OR EVEN SUPER SMARTER! ###

Supposing that the local machine has already installed pearl,
you can install/update pearl and access through a ssh session
on a remote machine with:

    $ ssh_pearl user@server.com

## USAGE ##
- To define all the settings (enable/disable configurations files):
  ``pearl_settings``
- To update pearl:
  ``pearl_update``
- To uninstall completely and safely pearl:
  ``pearl_uninstall``

The file '$HOME/.config/pearl/pearlrc' is the user-defined config
that contains all the settings done from the user.
This can be useful when you want to override some aliases,
variables or pearl's script.

## QUICKSTART ##
- Trash safely a file/directory instead of deleting it through rm:
  ``trash myfile``
- Add a directory to a bookmark:
  ``cd -a mytag ~/documents``
- To cd to a marked directory:
  ``cd -g mytag``
- To open tmux session on a marked directory:
  ``tmux -g mytag``
- much much more… take a look at lib/ for what 'pearl' offers…

## HELP ##
Just type one of the manuals you need in:
    man pearl.<TAB>

## FILES ##
*pearl* creates a config directory in '~/.config/pearl' which include
several config files. All the temporary directories
of the associated shell are stored in '~/.config/pearl/tmp'.

The bookmark paths are stored into '~/.config/pearl/bookmarks'.
The TODOs are stored into '~/.config/pearl/todos'.
The commands are stored in '~/.config/pearl/commands'.

## COPYRIGHT ##

       Copyright  (C) 2008-2014 Free  Software Foundation, Inc.

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
	Of course there is no bug in pearl. But there may be unexpected behaviors.
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

