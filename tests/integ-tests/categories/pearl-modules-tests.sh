#!/bin/bash

# Basic integ tests for pearl/dotfiles
pearl-dotfiles --help
pearl-dotfiles -h
pearl-dotfiles list
pearl-dotfiles enable vimrc
cat ~/.vimrc | grep "source.*mods/pearl/dotfiles/etc/vim/vimrc"
pearl-dotfiles disable vimrc
#Travis complain by saying: man: manpath list too long
#man -P cat pearl.dotfiles


# Basic integ tests for pearl/man
man3 -P cat git
#man -P cat pearl.man3

# Basic integ tests for pearl/p4merge
git p4diff --help

# Basic integ tests for pearl/ssh
which ssh-pearl
#man -P cat pearl.ssh

# Basic integ tests for pearl/utils
trash --help
todo --help
cmd --help
#man -P cat pearl.utils
