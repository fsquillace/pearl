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

import os
from ranger.core.loader import CommandLoader
import subprocess


class sync(Command):
    """
    :sync <num>             Copy the selected files to the sync directory
                            specified by the entry <num>
    :sync [-h || --help ]   Display the help

    Tries to copy to sync directory the selection.
    Type sync -h for all the available option.

    "Selection" is defined as all the "marked files" (by default, you
    can mark files with space or v). If there are no marked files,
    use the "current file" (where the cursor is)
    """
    allow_abbrev = False

    def execute(self):
        misc_lib = os.environ['PEARL_ROOT']+'/lib/util.sh'

        if (self.arg(1) == '-l' or self.arg(1) == '--list') and len(self.args)==2:
            self.fm.execute_command('source '+misc_lib+'; sync -l; sleep 5')
            #self.fm.cd(sync_dir)
            return
        elif (self.arg(1) == '-h' or self.arg(1) == '--help') and len(self.args)==2:
            self.fm.execute_command('source '+misc_lib+'; sync -h; sleep 5')
            return
        elif (self.arg(1) == '-a' or self.arg(1) == '--add') and len(self.args)==4:
            self.fm.execute_command('source '+misc_lib+'; '+self.line)
            return
        elif (self.arg(1) == '-r' or self.arg(1) == '--remove') and\
                len(self.args)==3:
            self.fm.execute_command('source '+misc_lib+'; '+self.line)
            return

        elif self.arg(1).isdigit() and len(self.args)==2:
            num_entry = self.arg(1)

            if num_entry.isdigit():
                # user confirmed sync!
                cfs = self.fm.env.cwd.get_selection()
                cwd = self.fm.env.cwd
                cf = self.fm.env.cf

                if cwd.marked_items or (cf.is_directory and not \
                        cf.is_link and len(os.listdir(cf.path)) > 0):
                    # Sync the selections
                    self.fm.execute_command('source '+misc_lib+' ; sync '+\
                            num_entry+' '+\
                          ' '.join(['"'+f.path+'"' for f in cfs]))
                    for f in cfs:
                        cwd.mark_item(f, val=False)
                else:
                    # Sync the file selected
                    self.fm.execute_command('source '+misc_lib+' ; sync '+\
                            num_entry+' '+\
                            '"'+cf.path+'"')
                return


        return self.fm.notify("Error in arguments: %s" % \
                (self.line), bad=True)




class symc(Command):
    """
    :symc                   Create a sym link of the selected files into the sync directory
    :symc [-h || --help ]   Show the help

    Tries to create a sym link of the selection to sync directory.
    Type symc -h for all the available option.

    "Selection" is defined as all the "marked files" (by default, you
    can mark files with space or v). If there are no marked files,
    use the "current file" (where the cursor is)
    """



    allow_abbrev = False

    def execute(self):

        misc_lib = os.environ['PEARL_ROOT']+'/lib/util.sh'

        if (self.arg(1) == '-s' or self.arg(1) == '--show') and\
                len(self.args)==2:
            self.fm.execute_command('source '+misc_lib+'; '+self.line+'; sleep 5')
            return
        elif (self.arg(1) == '-h' or self.arg(1) == '--help') and len(self.args)==2:
            self.fm.execute_command('source '+misc_lib+'; '+self.line+'; sleep 5')
            return
        elif (self.arg(1) == '-c' or self.arg(1) == '--clean') and\
                len(self.args)==2:
            self.fm.execute_command('source '+misc_lib+'; '+self.line)
            return

        elif len(self.args)==1 or\
                ((self.arg(1)=='-u' or self.arg(1)=='--unlink') and len(self.args)==2):

            # user confirmed sync!
            cfs = self.fm.env.cwd.get_selection()
            cwd = self.fm.env.cwd
            cf = self.fm.env.cf

            if cwd.marked_items or (cf.is_directory and not \
                    cf.is_link and len(os.listdir(cf.path)) > 0):
                # Sync the selections
                self.fm.execute_command('source '+misc_lib+'; '+self.line+\
                        ' '+\
                        ' '.join(['"'+f.path+'"' for f in cfs]))
                for f in cfs:
                    cwd.mark_item(f, val=False)

                return
            else:
                # Sync the file selected
                self.fm.execute_command('source '+misc_lib+'; '+self.line+\
                        ' '+\
                        '"'+cf.path+'"')
                return


        return self.fm.notify("Error in arguments: %s" % \
                (self.line), bad=True)



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
        trash_dir = os.environ['PEARL_TEMPORARY']
        misc_lib = os.environ['PEARL_ROOT']+'mods/pearl-utils/lib/utils.sh'

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

                self.fm.execute_command('source '+misc_lib+' ; trash '+\
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
            self.fm.execute_command('source '+misc_lib+' ; trash '+\
                      '"'+cf.path+'"')


class extract(Command):
    def execute(self):
        """ Extract from the selected compress files to current directory """
        cwd = self.fm.env.cwd
        cf = self.fm.env.cf

        if cwd.marked_items:
            cfs = cwd.get_selection()
        else:
            cfs = [cf]

        self.fm.execute_command('atool -x '+\
                ' '.join(['"'+f.path+'"' for f in cfs]))

        for f in cfs:
            cwd.mark_item(f, val=False)


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

        for f in marked_files:
            cwd.mark_item(f, val=False)


    def tab(self):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.env.cwd.path) + ext for ext in extension]

