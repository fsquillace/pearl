# Configurations #
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
*Jedi*
    Using the jedi autocompletion library
*Python-mode*
    Vim python-mode. PyLint, Rope, Pydoc, breakpoints from box.

In particular *pathogen* is used to easily place plugins in the directory '$HOME/.vim/bundle' (Take a look in the project 'https://github.com/tpope/vim-pathogen').
In order to install important VIM plugin *pearl* provides useful bash script *pearl\_update\u_modules*

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

## Config files ##
The config files touched by *pearl* are:

* '~/.config/ranger/commands.py'
* '~/.bashrc'
* '~/.vimrc'
* '~/.inputrc'
* '~/.XDefaults'
* '~/.gitconfig'
* '~/.screenrc'
* '~/.zshrc'
