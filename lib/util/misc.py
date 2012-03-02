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

'''Script that contains functions for various type of operations.
'''
__author__ = 'Filippo Squillace'
__date__ = '15/09/2010'
__license__   = 'GPL v3'
__copyright__ = '2010'
__docformat__ = 'restructuredtext en'
__version__ = "1.1.0"

import threading
import sys, os
import hashlib
from types import FunctionType
from util.logger import info, error, debug, warn
import subprocess

#----------------------------------------------------------------------
def get_ttys(user):
    """
    The function returns all the terminal of the user
    """
    lst = []
    out = subprocess.check_output('who')
    out = out.split('\n')
    for ln in out:
        sp = ln.split()
        if len(sp)!=0 and sp[0]==user:
            lst.append(sp[1])
    return lst

#----------------------------------------------------------------------
def is_pack_installed(pkg, system='debian'):
    """
    Check if a package is already installed
    Possible values of system are:
    *    debian
    *    archlinux
    """
    if system=='debian':
        cmd = 'dpkg --get-selections'
    elif system=='archlinux':
        cmd = 'sudo pacman -Qq'

    (st, out) = subprocess.getstatusoutput(cmd)
    return out.find(pkg)!=-1

#----------------------------------------------------------------------
def install_it(pkg, system='debian'):
    """
    Install a package only if it isn't already installed.
    If it was impossible the installation of the package the function return False,
    True otherwise.

    Possible values of system are:
    *    debian
    *    archlinux

    """
    if system=='debian':
        cmd = 'sudo apt-get --assume-yes install '+pkg
    elif system=='archlinux':
        cmd = 'sudo pacman -S '+pkg
    info('Installing the package '+pkg+' ...')
    if is_pack_installed(pkg):
        return True
    
    try:
        (st, out) =  subprocess.getstatusoutput(cmd)
    except OSError:
        error('Maybe apt is not installed in this system.')
        st = 32512 # This the error code of 'command not found'
    return st==0


def extractFunction(func, name = None):
    """Extract a nested function and make a new one.

    Example1>> def func(arg1, arg2):
                   def sub_func(x, y):
                       if x > 10:
                           return (x < y)
                       else:
                           return (x > y)

                   if sub_func(arg1, arg2):
                       return arg1
                   else:
                       return arg2


               func1 = extractFunction(func, 'sub_func')
               assert(func1(20, 15) == True)


    Example2>> class CL:
                   def __init__(self):
                       pass

                   def cmp(self, x, y):
                       return cmp(x, y)


               cmp1 = extractFunction(Cl.cmp)
    """
    if name == None and repr(type(func)) == "<type 'instancemethod'>":
        new_func = FunctionType(func.func_code, func.func_globals)
        return new_func

    if not hasattr(func, 'func_code'):
        raise ValueError #, '%s is not a function.' % func

    code_object = None
    for const in func.func_code.co_consts.__iter__():
        if hasattr(const, 'co_name') and const.co_name == name:
            code_object = const

    if code_object:
        new_func = FunctionType(code_object, func.func_globals)
        return new_func
    else:
        raise ValueError #, '%s does not have %s.' % (func, name)



    


#----------------------------------------------------------------------
def injectArguments(inFunction):
    """
    This function allows to reduce code for initialization of parameters of a method through the @-notation
    You need to call this function before the method in this way: @injectArguments
    """
    def outFunction(*args, **kwargs):
        _self = args[0]
        _self.__dict__.update(kwargs)
        # Get all of argument's names of the inFunction
        _total_names = inFunction.func_code.co_varnames[1:inFunction.func_code.co_argcount]
        # Get all of the values
        _values = args[1:]
        # Get only the names that don't belong to kwargs
        _names = [n for n in _total_names if not kwargs.has_key(n)]
        
        # Match argument names with values and update __dict__
        _self.__dict__.update(zip(_names,_values))

        return inFunction(*args,**kwargs)
        
    return outFunction


#def singleton(cls):
    #instance_container = []
    #def getinstance():
        #if not len(instance_container):
            #instance_container.append(cls())
        #return instance_container[0]
    #return getinstance



#----------------------------------------------------------------------
def printArguments(inFunction):
    """
    This function allows to print the arguments passed in a function through the @-notation.
    It's useful for debug code.
    You need to call this function before the method in this way: @printArguments
    """
    def outFunction(*args, **kwargs):
        sys.stdout('Arguments:\n'+str(args))
        sys.stdout('Arguments with keyword:\n'+str(kwargs))
        pass
    return outFunction

def concurrent_map(function, *args):
    """
    Similar to the bultin function map(). But spawn a thread for each argument
    and apply `function` concurrently.

    Note: unlike map(), we cannot take an iterable argument. `sequence` should be an
    indexable sequence.
    """
    # Check if there is same leght among sequences
    lenght = len(args[0])
    for i in range(1, len(args)):
        seq = args[i]
        if lenght!=len(seq):
            raise TypeError #, 'The sequences need the same length'
        
    N = len(args[0])
    result = [None] * N
    
    # wrapper to dispose the result in the right slot
    def task_wrapper(i):
        result[i] = function(*zip(*args)[i])

    threads = [threading.Thread(target=task_wrapper, args=(i,)) for i in xrange(N)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

    return result


def concurrent_filter(function, sequence):
    """
    Similar to the bultin function filter(). But spawn a thread for each argument
    and apply `function` concurrently.

    Note: unlike map(), we cannot take an iterable argument. `sequence` should be an
    indexable sequence.
    """

    N = len(sequence)
    result = []

    # wrapper to dispose the result in the right slot
    def task_wrapper(i):
        if function(sequence[i])==True:
            result.append(sequence[i])

    threads = [threading.Thread(target=task_wrapper, args=(i,)) for i in xrange(N)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

    return result


def checksum_dir(directory):
    """
    Author: Stephen Akiki
    """
    md5hash = hashlib.md5()
    if not os.path.exists (directory):
        return -1

    try:
        for root, dirs, files in os.walk(directory):
            for names in files:
                filepath = os.path.join(root,names)
                md5hash.update(checksum_file(filepath))

    except:
        import traceback
        # Print the stack traceback
        traceback.print_exc()
        return -2

    return md5hash.digest()


#----------------------------------------------------------------------
def checksum_file(filename):
    """
    Author: Piotr Czapla
    """
    md5 = hashlib.md5()
    if os.access(filename,os.R_OK):
        with open(filename,'rb') as f: 
            for chunk in iter(lambda: f.read(8192), ''): 
                md5.update(chunk)
    return md5.digest()






# -------------------------------------- Cache decorator block --------------------
import types

def cachedmethod(function):
    return types.MethodType(Memoize(function), None)


class Memoize:
    def __init__(self,function):
        self._cache = {}
        self._callable = function
            
    def __call__(self, *args, **kwds):
        cache = self._cache
        key = self._getKey(*args,**kwds)
        try: return cache[key]
        except KeyError:
            cachedValue = cache[key] = self._callable(*args,**kwds)
            return cachedValue
    
    def _getKey(self,*args,**kwds):
        return kwds and (args, ImmutableDict(kwds)) or args    


class ImmutableDict(dict):
    '''A hashable dict.'''

    def __init__(self,*args,**kwds):
        dict.__init__(self,*args,**kwds)
    def __setitem__(self,key,value):
        raise NotImplementedError #, "dict is immutable"
    def __delitem__(self,key):
        raise NotImplementedError #, "dict is immutable"
    def clear(self):
        raise NotImplementedError #, "dict is immutable"
    def setdefault(self,k,default=None):
        raise NotImplementedError #, "dict is immutable"
    def popitem(self):
        raise NotImplementedError #, "dict is immutable"
    def update(self,other):
        raise NotImplementedError #, "dict is immutable"
    def __hash__(self):
        return hash(tuple(self.iteritems()))
# -------------------------------------- End cache decorator block ----------------


def reducedpath(abs_path):
    '''
    This function allows to reduce the lenght of the path so, you can see pretty
    well it in a prompt command.
    For example:
    *   /home/feel/usr/bin --> /home/.../bin
    '''
    abs_path = os.path.normpath(abs_path) # Normalize eliminates double slashes and other things
    if abs_path == os.environ['HOME']:
        return '~'
    
    l = [el for el in abs_path.split('/') if el !='' ]
    if len(l)==0:
        return '/'
    elif len(l)==1:
        return '/'+l[0]
    elif len(l)==2:
        return '/'+l[0]+'/'+l[1]
    elif len(l)==3:
        return '/'+l[0]+'/'+l[1]+'/'+l[2]
    return '/'+l[0]+'/.../'+l[len(l)-1]
    


    
# ----- Example ----------------------------------------------------------------

if __name__=='__main__':
    pass
    #class Test:
        #""""""
        #def __init__(self, name, surname):
            #"""Constructor"""
            #pass
    #@cache
    #def fib(n):
        #if n < 2:
            #return 1
        #return fib(n-1) + fib(n-2)

    #from random import shuffle
    #inputs = list(range(30))
    #shuffle(inputs)
    #results = sorted(fib(n) for n in inputs)
    #print(results)
    #print(fib.cache_info())

    #from math import sqrt,log,sin,cos
        
    #class Example:
        #def __init__(self,x,y):
            ## self._x and self._y should not be changed after initialization
            #self._x = x
            #self._y = y
        
        #@cachedmethod
        #def computeSomething(self, alpha, beta):
            #w = log(alpha) * sqrt(self._x * alpha + self._y * beta)
            #z = log(beta) * sqrt(self._x * beta + self._y * alpha)
            #return sin(z) / cos(w)
    #t = Test('filippo', surname='squillace')
    #print t.name, t.surname
    
    #def f(n1, n2):
        #return n1*n2
    #print concurrent_map(f, [1,2], [3,4])
    #commands = [
    #['ls', '/bin'],
    #['ls', '/usr'],
    #['ls', '/etc'],
    #['ls', '/var'],
    #['ls', '/tmp']
    #]
    #exec_commands(commands)
