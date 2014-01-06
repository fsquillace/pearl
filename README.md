# pearl(1) #

## Name ##
pearl - An enhanced shell bash framework

## Description ##
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

## Installation ##
*pearl* should work with many recent release of bash. The minimum recommended
version is 4.3.9.

Usually all git releases are ok,
but for uninstalling modules the minimum recommended version is >=1.8 since
the previous git releases don't support the "submodule deinit" command.

### Using Git... ###

For sure the best way of installing *pearl* is to place it
in a hidden subdirectory of HOME (by default ~/.pearl).
Type the following commands:

    $ git clone 'git://github.com/fsquillace/pearl.git' $HOME/.pearl
    $ source $HOME/.pearl/pearl

### ...Or even smarter... ###

Using the *make.sh* script, pearl can be installed even on a
machine that doesn't have git installed!
*make.sh* installs or updates pearl with either git or wget depending
if git has been installed into the machine.

    $ wget --no-check-certificate -O - https://raw.github.com/fsquillace/pearl/master/lib/make.sh | bash
    $ source $HOME/.pearl/pearl

### ...Or even super smarter! ###

Supposing that the local machine has already installed pearl,
you can install/update pearl and access through a ssh session
on a remote machine with:

    $ ssh_pearl user@server.com

## Usage ##
- To update pearl:
  ``pearl_update``
- To uninstall completely and safely pearl:
  ``pearl_uninstall``

### Modules ###
- To list the modules
  ``pearl_module_list``
- To install *ranger* (an awesome file manager!) module
  ``pearl_module_install_update ranger``
- To uninstall the *ranger* module
  ``pearl_module_uninstall ranger``

### Configs ###
- To list all the configurations
  ``pearl_config_list``
- To enable the vim configuration
  ``pearl_config_enable vimrc``
- To disable the vim configuration
  ``pearl_config_disable vimrc``

The file ``$HOME/.config/pearl/pearlrc`` is the user-defined config
that contains all the settings done from the user.
This can be useful when you want to override some aliases,
variables or pearl's script.

## Quickstart ##
- Trash safely a file/directory instead of deleting it through rm:
  ``trash myfile``
- Add a directory to a bookmark:
  ``cd -a mytag ~/documents``
- To cd to a marked directory:
  ``cd -g mytag``
- To open tmux session on a marked directory:
  ``tmux -g mytag``
- much much more… take a look at lib/ for what 'pearl' offers…

## Help ##
Just type one of the manuals you need in:

    man pearl.<TAB>

## FAQ ##
Q: I cannot uninstall modules: error: pathspec 'deinit' did not match any file(s) known to git.
A: deinit command is available only for newer git releases >=1.8.

## Files ##
*pearl* creates a config directory in ``~/.config/pearl`` which include
several config files. All the temporary directories
of the associated shell are stored in ``~/.config/pearl/tmp``.

The bookmark paths are stored into ``~/.config/pearl/bookmarks``.
The TODOs are stored into ``~/.config/pearl/todos``.
The commands are stored in ``~/.config/pearl/commands``.

## Copyright ##

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

## Bugs ##
Of course there is no bug in pearl. But there may be unexpected behaviors.
Go to 'https://github.com/fsquillace/pearl/issues' you can report directly
this unexpected behaviors.

## Authors ##
Filippo Squillace <feel.squally@gmail.com>.

## WWW ##
https://github.com/fsquillace/pearl

## Last words ##

    Consider your origins:
    You were not born to live like brutes
    but to follow virtue and knowledge.
    [verse, Dante Alighieri, from Divine Comedy]

