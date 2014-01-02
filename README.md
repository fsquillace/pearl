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

