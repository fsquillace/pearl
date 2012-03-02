# -*- coding: utf-8 -*-
# Copyright (C) 2009, 2010, 2011  Roman Zimbelmann <romanz@lavabit.com>
# This configuration file is licensed under the same terms as ranger.
# ===================================================================
# This file contains ranger's commands.
# It's all in python; lines beginning with # are comments.
#
# Note that additional commands are automatically generated from the methods
# of the class ranger.core.actions.Actions.
#
# You can customize commands in the file ~/.config/ranger/commands.py.
# It has the same syntax as this file.  In fact, you can just copy this
# file there with `ranger --copy-config=commands' and make your modifications.
# But make sure you update your configs when you update ranger.
#
# ===================================================================
# Every class defined here which is a subclass of `Command' will be used as a
# command in ranger.  Several methods are defined to interface with ranger:
#   execute(): called when the command is executed.
#   cancel():  called when closing the console.
#   tab():     called when <TAB> is pressed.
#   quick():   called after each keypress.
#
# The return values for tab() can be either:
#   None: There is no tab completion
#   A string: Change the console to this string
#   A list/tuple/generator: cycle through every item in it
#
# The return value for quick() can be:
#   False: Nothing happens
#   True: Execute the command afterwards
#
# The return value for execute() and cancel() doesn't matter.
#
# ===================================================================
# Commands have certain attributes and methods that facilitate parsing of
# the arguments:
#
# self.line: The whole line that was written in the console.
# self.args: A list of all (space-separated) arguments to the command.
# self.quantifier: If this command was mapped to the key "X" and
#      the user pressed 6X, self.quantifier will be 6.
# self.arg(n): The n-th argument, or an empty string if it doesn't exist.
# self.rest(n): The n-th argument plus everything that followed.  For example,
#      If the command was "search foo bar a b c", rest(2) will be "bar a b c"
# self.start(n): The n-th argument and anything before it.  For example,
#      If the command was "search foo bar a b c", rest(2) will be "bar a b c"
#
# ===================================================================
# And this is a little reference for common ranger functions and objects:
#
# self.fm: A reference to the "fm" object which contains most information
#      about ranger.
# self.fm.notify(string): Print the given string on the screen.
# self.fm.notify(string, bad=True): Print the given string in RED.
# self.fm.reload_cwd(): Reload the current working directory.
# self.fm.env.cwd: The current working directory. (A File object.)
# self.fm.env.cf: The current file. (A File object too.)
# self.fm.env.cwd.get_selection(): A list of all selected files.
# self.fm.execute_console(string): Execute the string as a ranger command.
# self.fm.open_console(string): Open the console with the given string
#      already typed in for you.
# self.fm.move(direction): Moves the cursor in the given direction, which
#      can be something like down=3, up=5, right=1, left=1, to=6, ...
#
# File objects (for example self.fm.env.cf) have these useful attributes and
# methods:
#
# cf.path: The path to the file.
# cf.basename: The base name only.
# cf.load_content(): Force a loading of the directories content (which
#      obviously works with directories only)
# cf.is_directory: True/False depending on whether it's a directory.
#
# For advanced commands it is unavoidable to dive a bit into the source code
# of ranger.
# ===================================================================

from ranger.api.commands import *
from ranger.ext.get_executables import get_executables
from ranger.core.runner import ALLOWED_FLAGS


import os
from ranger.core.loader import CommandLoader
import subprocess


class sync(Command):
    """
    :sync                   Move to the sync directory the selected files
    :sync [-s || --show ]   Show the sync directory
   
    Tries to move to sync directory the selection.

    "Selection" is defined as all the "marked files" (by default, you
    can mark files with space or v). If there are no marked files,
    use the "current file" (where the cursor is)

    When attempting to synsync-empty directories or multiple
    marked files, it will require a confirmation: The last word in
    the line has to start with a 'y'.  This may look like:
    :trash yes
    :trash seriously? yeah!
    """

    allow_abbrev = False
   
    def execute(self):
        sync_dir = os.environ['SYNC_HOME']

        if self.arg(1) == '-s' or self.arg(1) == '--show':
            self.fm.cd(sync_dir)
        else:
            lastword = self.arg(-1)
            SYNC_WARNING = 'sync seriously? '
            
            if lastword.startswith('y'):
                # user confirmed sync!
                cfs = self.fm.env.cwd.get_selection()
                cwd = self.fm.env.cwd

                for f in cfs:
                    subprocess.getstatusoutput('rsync -R -C --exclude=.svn -uhzravE --delete '+\
                            f.path+' '+sync_dir)
                    
                    cwd.mark_item(f, val=False)
                return
            
            elif self.line.startswith(SYNC_WARNING):
                # user did not confirm sync
                return
    
            cwd = self.fm.env.cwd
            cf = self.fm.env.cf
            
            if cwd.marked_items or (cf.is_directory and not cf.is_link \
                                    and len(os.listdir(cf.path)) > 0):
                # better ask for a confirmation, when attempting to
                # sync multiple files or a non-empty directory.
                return self.fm.open_console(SYNC_WARNING)
    

            # no need for a confirmation, just sync
            subprocess.getstatusoutput('rsync -R -C --exclude=.svn -uhzravE --delete '+\
                    cf.path+' '+sync_dir)



class trash(Command):
    """
    :trash                   Move to trash the selected files
    :trash [-s || --show ]   Show the trash
    :trash [-e || --empty]   Empty the trash
    
    Tries to move to trash the selection.

    "Selection" is defined as all the "marked files" (by default, you
    can mark files with space or v). If there are no marked files,
    use the "current file" (where the cursor is)

    When attempting to trash non-empty directories or multiple
    marked files, it will require a confirmation: The last word in
    the line has to start with a 'y'.  This may look like:
    :trash yes
    :trash seriously? yeah!
    """

    allow_abbrev = False
    
    def execute(self):
        trash_dir = os.environ['PYSHELL_TEMPORARY']
        os.system('mkdir -p '+ trash_dir)
        
        if self.arg(1) == '-s' or self.arg(1) == '--show':
            self.fm.cd(trash_dir)
        elif self.arg(1) == '-e' or self.arg(1) == '--empty':
            os.system('rm -rf '+ trash_dir+'/*')

        else:
            lastword = self.arg(-1)
            TRASH_WARNING = 'trash seriously? '
            
            if lastword.startswith('y'):
                # user confirmed deletion!
                cfs = self.fm.env.cwd.get_selection()    
                os.system('mv --backup=numbered -f -t "'+trash_dir+'" '+\
                          ' '.join(['"'+f.path+'"' for f in cfs]))
                return
            elif self.line.startswith(TRASH_WARNING):
                # user did not confirm deletion
                return
    
            cwd = self.fm.env.cwd
            cf = self.fm.env.cf
            
            if cwd.marked_items or (cf.is_directory and not cf.is_link \
                                    and len(os.listdir(cf.path)) > 0):
                # better ask for a confirmation, when attempting to
                # delete multiple files or a non-empty directory.
                return self.fm.open_console(TRASH_WARNING)
    
            # no need for a confirmation, just delete
            os.system('mv --backup=numbered -f -t '+trash_dir+' '+\
                      '"'+cf.path+'"')


class extracthere(Command):
    def execute(self):
        """ Extract copied files to current directory """
        cwd = self.fm.env.cwd
        marked_files = tuple(cwd.get_selection())
        #old version was wih copy instead of mark
        #copied_files = tuple(self.fm.env.copy)

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.env.get_directory(original_path)
            cwd.load_content()

        one_file = marked_files[0]
        cwd = self.fm.env.cwd
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.env.copy.clear()
        self.fm.env.cut = False
        if len(marked_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags \
                            + [f.path for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)



class compress(Command):
    def execute(self):
        """ Compress marked files to current directory """
        cwd = self.fm.env.cwd
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.env.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                            [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.env.cwd.path) + ext for ext in extension]

