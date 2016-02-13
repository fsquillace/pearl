# Pearl #

[![Build status](https://api.travis-ci.org/fsquillace/pearl.png?branch=master)](https://travis-ci.org/fsquillace/pearl)

*pearl* - The Linux shell made easy

```
       _/_/_/     _/_/_/_/    _/_/_/     _/_/_/         _/
     _/     _/   _/        _/      _/  _/      _/      _/
    _/     _/   _/        _/      _/  _/       _/     _/
   _/_/_/_/    _/_/_/    _/_/_/_/_/  _/_/_/_/_/      _/
  _/          _/        _/      _/  _/      _/      _/
 _/          _/        _/      _/  _/        _/    _/
_/          _/_/_/_/  _/      _/  _/          _/  _/_/_/_/_/
```

## Description ##
*pearl* is an enhanced and lightweight shell framework that allows
to improve the way of using the shell Bash/Zsh/Fish and automate many daily
activities of the system administrator.
*pearl* comes bundled with a ton of helpful functions, helpers, plugins,
aliases, configuration files and commands, all out of the box.

The main goal of pearl is to provide for both expert and beginner users a
starting point, respectively, for using quickly the shell terminal
and learning how to create customized functions, aliases and
managing configuration files of the main open source programs.

*pearl* is not meant to give static configurations
for the users but it provides the freedom to customize
them as much as you want.

Only in the best shell you will find a pearl!

## Installation ##
The main Pearl dependencies are:

- bash (>=4.2)
- git (>=1.8)

### Installation for Bash/Zsh ###
Just clone the Pearl repo somewhere (for example in ~/.pearl):

    git clone 'https://github.com/fsquillace/pearl.git' $HOME/.pearl
    export PATH=$HOME/.pearl/bin:$PATH
    pearl system install

Put the following in your shell config file (i.e. ~/.bashrc, ~/.zshrc)"
    source $HOME/.pearl/pearl

### Installation for Fish ###
Just clone the Pearl repo somewhere (for example in ~/.pearl):

    git clone 'https://github.com/fsquillace/pearl.git' $HOME/.pearl
    set PATH $HOME/.pearl/bin $PATH
    pearl system install

Put the following in your shell config file (i.e. ~/.config/fish/config.fish)"
    source $HOME/.pearl/pearl.fish

### Additional Pearl modules to install ###
Some useful Pearl modules to install:

    pearl module install pearl/utils
    pearl module install pearl/dotfiles

## Quickstart ##
- Install the pearl utils mod:

    `pearl module install pearl/utils`

- Trash safely a file/directory instead of deleting it through rm:

    `trash myfile`

- Add a directory to a bookmark:

    `cd -a mytag ~/documents`

- To cd to a marked directory:

    `cd -g mytag`

- To open tmux session on a marked directory:

    `tmux -g mytag`

- How to use [pearl as an IDE](https://github.com/fsquillace/pearl/blob/master/doc/pearl-as-ide.md)

- much much more… take a look at the list of modules for what 'pearl' offers…

    `pearl module list`

## Usage ##
- To update pearl:

    `pearl system update`

- To uninstall completely and safely pearl:

    `pearl system uninstall`

### Modules ###
- To list the modules

    `pearl module list`

- To install *ranger* module

    `pearl module install misc/ranger`

- To uninstall the *ranger* module

    `pearl module uninstall misc/ranger`

List of main modules are:

- [powerline](https://github.com/Lokaltog/powerline) - statusline plugin for vim and more
- [ranger](http://ranger.nongnu.org/) - A ncurses file manager
- [vim-syntastic](https://github.com/scrooloose/syntastic) - Syntax checking hacks for vim
- [vim-python-mode](https://github.com/klen/python-mode)
- [pearl-ssh](https://github.com/fsquillace/pearl-ssh)
- [pearl-man](https://github.com/fsquillace/pearl-man)
- and much more...

### Dotfiles ###
After installed the pearl mod [pearl-dotfiles](https://github.com/fsquillace/pearl-dotfiles):

- To list all the configurations

    `pearl-dotfiles list`

- To enable the vim configuration

    `pearl-dotfiles enable vimrc`

- To disable the vim configuration

    `pearl-dotfiles enable vimrc`

The file ``$HOME/.config/pearl/pearlrc`` is the user-defined config
that contains all the settings done from the user.
This can be useful when you want to override some aliases,
variables or pearl scripts.

## Help ##
Just type one of the manuals you need in:

    man pearl.<TAB>

## FAQ ##
Q: I cannot uninstall modules: error: pathspec 'deinit' did not match any file(s) known to git.

A: deinit command is available only for newer git releases >=1.8.


Q: What if I want to override some configuration properties?

A: The override configuration can be done directly to the traditional
config file of the tool since it will have the highest priority.
For example, to override some properties of vim, just edit the '~/.vimrc' file.

## Files ##
*pearl* creates a config directory in ``~/.config/pearl`` which include
several config files. All the temporary directories
of the associated shell are stored in ``~/.config/pearl/tmp``.

The bookmark paths are stored into ``~/.config/pearl/bookmarks``.
The TODOs are stored into ``~/.config/pearl/todos``.
The commands are stored in ``~/.config/pearl/commands``.

## Copyright ##

    Copyright  (C) 2008-2016 Free  Software Foundation, Inc.

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
Filippo Squillace <feel.sqoox@gmail.com>.

## WWW ##
https://github.com/fsquillace/pearl

## Last words ##

    Consider your origins:
    You were not born to live like brutes
    but to follow virtue and knowledge.
    [verse, Dante Alighieri, from Divine Comedy]

