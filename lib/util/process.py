#!/usr/bin/python

#
# Author: Filippo Squillace <sqoox85@gmail.com>
#
# Copyright 2010
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranties of
# MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.

'''Script that contains functions for various type of operations with processes.
'''
__author__ = 'Filippo Squillace'
__date__ = '20/12/2010'
__license__   = 'GPL v3'
__copyright__ = '2010'
__docformat__ = 'restructuredtext en'
__version__ = "0.0.1"


import threading
import subprocess
import sys, os, time
import shlex
from subprocess import Popen, list2cmdline, PIPE
from .logger import info, error, debug, warn
import collections


#----------------------------------------------------------------------
def is_already_executed(proc):
    """
    This function check out isf proc is already executed in the system.
    The function takes the current user in $USER.
    It returns the number of instances of the processes currently executed.
    """
    try:
        user = os.environ['USER']
        debug('The user is '+user)
    except NameError:
        error('The environment variable $USER doesn\'t exist')
        user = ''
    # Get the name of the command chopping all the options and the path
    proc_without_opts = proc.split()[0].split('/')[-1]
    debug('The name of the process is '+proc_without_opts)
    (st, out) = subprocess.getstatusoutput('ps --no-heading -C '+proc_without_opts+\
                                         '  -o user | grep "'+user+'"')
    if st!=0:
        return 0

    return len(out.split('\n'))
    

#----------------------------------------------------------------------
def execute(proc, sleep_time=0, once=False, background=False, nohup=False):
    """
    This function execute a command and check out if it is already executed when 'once=True'.
    At most only one instance can be executed for each user of the system.
    The function takes the current user in $USER.
    """
    if once and is_already_executed(proc):
        warn('The command '+proc+' has been already executed')
        return 1

    # Create the process
    if background: bkg='&'
    else: bkg=''
    if nohup: nhp = 'nohup'
    else: nhp = ''
    
    p = Popen('sleep '+str(sleep_time)+' && '+nhp+' '+proc +\
          '  '+bkg, stdout=open('/dev/null','a'), stderr=open('/dev/null','a'), shell=True)
    

    return p.returncode
    


def cpu_count():
    ''' Returns the number of CPUs in the system
    '''
    num = 1
    if sys.platform == 'win32':
        try:
            num = int(os.environ['NUMBER_OF_PROCESSORS'])
        except (ValueError, KeyError):
            pass
    elif sys.platform == 'darwin':
        try:
            num = int(os.popen('sysctl -n hw.ncpu').read())
        except ValueError:
            pass
    else:
        try:
            num = os.sysconf('SC_NPROCESSORS_ONLN')
        except (ValueError, OSError, AttributeError):
            pass

    return num



def exec_commands(cmds):
    ''' Exec commands in parallel in multiple process 
    (as much as we have CPU)
    Arg: List of commands in list format
    '''
    if not cmds: return # empty list

    def done(p):
        return p.poll() is not None
    def success(p):
        return p.returncode == 0
    def fail():
        sys.exit(1)

    max_task = cpu_count()
    processes = []
    while True:
        while cmds and len(processes) < max_task:
            task = cmds.pop()
            print(list2cmdline(task))
            processes.append(Popen(task))

        for p in processes:
            if done(p):
                if success(p):
                    processes.remove(p)
                else:
                    fail()

        if not processes and not cmds:
            break
        else:
            time.sleep(0.05)
            
########################################################################
class Daemon(threading.Thread):
    """
    """
    __thr__ = None
    __stdin__ = sys.stdin
    __stdout__ = sys.stdout
    
    class Communicator(threading.Thread):
        """
        
        """
        HELP = 'help'
        __msgs__ = [HELP]
        def __init__(self, daemon):
            threading.Thread.__init__(self)
            self.__msgs__ = []
            for k,v in daemon.__class__.__dict__.items():
                if isinstance(v, collections.Callable) and  k[0]!='_' and k!='run':
                    self.__msgs__.append(k)
            self.__daemon__ = daemon
            
            
        def run(self):
            info('Type help to list all the commands.')
            
            
            while True:
                try:
                    self.__daemon__.__stdout__.write("\n"+repr(self.__daemon__)+">> ")
                    self.__daemon__.__stdout__.flush()
                    line = self.__daemon__.__stdin__.readline()
                    if not line:
                        break
                    self.__daemon__.__stdout__.write(line)
                    self.__daemon__.__stdout__.flush()
                    #line = raw_input("\n>> ")
                    if len(line)==0 or line=='\n':
                        # This is the default action
                        info(str(self.__daemon__))
                        continue
                except :
                    continue
                
                line_to_list = line.strip().split()
                cmd = line_to_list[0]
                
                if cmd==self.HELP:
                    info('\n'.join(self.__msgs__))
                    info('\nType cntrl+z to exit.')
                    info('Type "command help" to show the help for a specified command.')
                elif self.__msgs__.count(cmd) == 0:
                    error('The process doesn\'t recognize the command '+line)
                elif len(line_to_list)==2 and line_to_list[1]==self.HELP:
                    eval('info(self.__daemon__.'+cmd+'.__doc__)')
                else:
                    eval('self.__daemon__.'+cmd+'(line_to_list)')

    #----------------------------------------------------------------------
    def __init__(self):
        """Constructor"""
        threading.Thread.__init__(self)
        #self.__msgs__ = msgs
        self.__thr__ = self.Communicator(self)
        # Start the thread for the communication
        self.__thr__.start()
        
    def run(self):
        raise NotImplementedError('The method run must be implemented by the sub-class.')
    def __str__(self):
        raise NotImplementedError('The method __str__ must be implemented by the sub-class.')

########################################################################
class Init(Daemon):
    """"""
    __prcs__ = {}
    __apps__ = {}
    #----------------------------------------------------------------------
    def __init__(self):
        """Constructor"""
        Daemon.__init__(self)
    #----------------------------------------------------------------------
    def __str__(self):
        """"""
        self.ls('')
        return ''
    
    def connect(self, args):
        """
        Connect the user towards the process.
        Syntax: connect pid
        See also exit help command.
        """
        raise NotImplementedError('The method connect is not implemented yet.')
        try:
            pid = int(args[1])
            proc_cmd, proc = self.__prcs__[pid]
            if len(args)==2:
                info('Changed context.')
                self.stdout = proc.stdin
                self.stdin = proc.stdout
            else:
                raise SyntaxError()
        except:
            error('Arguments are not correct.')
        
        pass
    
    def exit(self, args):
        """
        Exit from a connection towards a process
        """
        raise NotImplementedError('The method exit is not implemented yet.')
        self.stdout = sys.stdout
        self.stdin = sys.stdin
        pass
    
    def signal(self, args):
        """
        Kill a process.
        Syntax: signal pid [signal]
        signal: SIGTERM, SIGUSR1, SIGUSR2, SIGKILL(default), ... for details see 'man kill'
        """
        import signal
        try:
            pid = int(args[1])
            proc_cmd, proc = self.__prcs__[pid]
            if len(args)==2:
                proc.kill()
                info('Killed ('+str(pid)+') '+proc_cmd)
            elif len(args)==3:
                proc.send_signal(args[3], eval('signal.'+args[2]))
            else:
                raise SyntaxError()
        except:
            error('Arguments are not correct.')
        
    def send(self):
        pass
    def store(self):
        pass
    def lsapps(self, args):
        """
        List all the application stored.
        Syntax: lsapps
        """
        raise NotImplementedError('The method lsapps is not implemented yet.')
        info('boot\tdelaytime\t\t\\t\t\tCommand') #Try to make nohup,once and backgroud mandatory
        # try to put a timestamp to check out when was the last time that was opened and/or closed pyshell
        # try module atexit to ensure nohup for the pending processes calling disown -h job
        pass
    
    def ls(self, args):
        """
        List all the processes are executing in the system.
        Syntax: ls
        """
        
        info('PID\tstdout\t\t\tstderr\t\t\tCommand')
        for pid in self.__prcs__:
            proc_cmd , proc = self.__prcs__[pid]
            if proc.stdout is None:
                stdout = None
            else:
                stdout = proc.stdout.name
                
            if proc.stderr is None:
                stderr = None
            else:
                stderr = proc.stderr.name
                
            info(str(pid)+'\t'+\
                 str(stdout)+'\t\t'+str(stderr)+'\t\t'+proc_cmd)

    def stdout(self, args):
        """
        Set the stdout.
        Syntax: stdout pid [path]
        Default path is /dev/null.
        """
        #try:
        pid = int(args[1])
        proc_cmd, proc = self.__prcs__[pid]
        if len(args)==2:
            proc.stdout = open('/dev/null', 'a+')
            info('stdout changed in /dev/null')
        elif len(args)==3:
            path = args[2]
            print('try to change stdou')
            dup2(open(path,'a+').fileno(), proc.stdout.fileno())
            
            proc.stdout = open(path,'a+')
            info('stdout changed in '+path)
        else:
            raise SyntaxError()
        #except:
            #error('Arguments are not correct.')

    def stderr(self, args):
        num_proc = int(args[1])
        k = list(self.__prcs__.keys())[num_proc]
        path = args[2]
        self.__prcs__[k].stderr = open(path,'a')
    
    def run(self):
        def done(p):
            return p.poll() is not None
        
        while(True):
            death = []
            for pid in self.__prcs__:
                proc_cmd , p = self.__prcs__[pid]
                if done(p):
                    death.append(pid)
            
            for pid in death:
                warn('The process '+str(pid)+' has terminated the exectution.')
                del self.__prcs__[pid]                
            time.sleep(1)
            pass
        pass
    
    def execute(self, args):
        #info(self.__execute(list2cmdline(args[1:]))) #
        info(self.__execute(' '.join(args[1:])))
    #----------------------------------------------------------------------
    def __execute(self, proc, sleep_time=0, once=False, background=False, nohup=False):
        """
        This function execute a command and check out if it is already executed when 'once=True'.
        At most only one instance can be executed for each user of the system.
        The function takes the current user in $USER.
        """
        if once and is_already_executed(proc):
            warn('The command '+proc+' has been already executed')
            return 1
    
        # Create the process
        if background: bkg='&'
        else: bkg=''
        if nohup: nhp = 'nohup'
        else: nhp = ''
        
        #cmd_line = 'sleep '+str(sleep_time)+' && '+nhp+' '+proc +\
              #'  '+bkg
        
        p = Popen(shlex.split(proc), stdin=PIPE, stdout=PIPE, stderr=PIPE)

        
        self.__prcs__[p.pid] = (proc, p)
        
            
        return p.pid
    

# Try to make a thread called Jobs that is able to manage a list of Popen Object and introduce the idea of Daemon for the communication

if __name__=='__main__':
    # Create the init process
    Init().start()
    
    
    
