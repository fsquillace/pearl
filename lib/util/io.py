#!/usr/bin/python3
#
# Author: Filippo Squillace <sqoox85@gmail.com>
#
# Copyright 2011
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

'''
This library enables your application for accessing in files throught
I/O operations.
'''
__author__ = 'Filippo Squillace'
__date__ = '21/05/2011'
__license__   = 'GPL v3'
__copyright__ = '2011'
__docformat__ = 'restructuredtext en'
__version__ = "0.0.3"

import os
import pickle
import subprocess
import io
import string
from util.misc import debug
from util.threads import future

class DirectoryPathError(Exception):
    """
    The path specified is for a directory but not for a file.
    """
    pass


def append_entry(path, entry):
    """
    Append an entry in a list and store the list in a file.
    """
    
    if not isinstance(path, str):
        raise AttributeError('The path:'+str(path)+' is not a string.')
    if os.path.isdir(path):
        raise DirectoryPathError('The element specified by the path '+path+' is a directory.')
    
    if os.path.exists(path):
        l = pickle.load(open(path,'rb'))
    else:
        l=[]

    l.append(entry)
    pickle.dump(l,open(path,'wb'))
    debug("added: "+str(entry))
    pass

def remove_entry(path,index):
    """
    Remove an entry in a list and store the list in a file.
    """
    
    if not isinstance(path, str):
        raise AttributeError('The path:'+str(path)+' is not a string.')
    if os.path.isdir(path):
        raise DirectoryPathError('The element specified by the path '+path+' is a directory.')
    
    if os.path.exists(path):
        l = pickle.load(open(path,'rb'))
        if l is None or len(l)==0:
            return
        if index<0 or index>len(l)-1:
            raise IndexError('Index '+str(index)+' is out of the range.')
        d = l[index]
        l.remove(d)
        pickle.dump(l,open(path,'wb'))
        debug("removed: "+str(d))
    pass

def get_entry(path, index):
    """
    Get an entry specified by the index.
    On entry: path (string) is path of the file, index (int) is the index of the entry
    On exit: entry
    """
    
    if not isinstance(path, str):
        raise AttributeError('The path:'+str(path)+' is not a string.')
    if os.path.isdir(path):
        raise DirectoryPathError('The element specified by the path '+path+' is a directory.')    
    
    if os.path.exists(path):
        l = pickle.load(open(path,'rb'))
        if l is None or len(l)==0:
            return None
        if index<0 or index>len(l)-1:
            raise IndexError('Index '+str(index)+' is out of the range.')
        return l[index]
    pass

def get_len(path):
    """
    Get a the lenght of the list stored into a the file specified in path.
    On entry: path (string) is the path of the file which is stored the list;
    On exit: the lenght of the list (int).
    """
    if not isinstance(path, str):
        raise AttributeError('The path:'+str(path)+' is not a string.')
    if os.path.isdir(path):
        raise DirectoryPathError('The element specified by the path '+path+' is a directory.')    
    
    debug("Path: "+path)
    if os.path.exists(path):
        l = pickle.load(open(path,'rb'))
    else:
        l=[]
        
    return len(l)


def get_list(path):
    """
    Get a the list stored in the file.
    On entry: path (string) is the path of the file which is stored the list;
    On exit: the list (list).
    """
    
    if not isinstance(path, str):
        raise AttributeError('The path:'+str(path)+' is not a string.')
    if os.path.isdir(path):
        raise DirectoryPathError('The element specified by the path '+path+' is a directory.')    
    
    debug("Path: "+path)
    if os.path.exists(path):
        l = pickle.load(open(path,'rb'))
    else:
        l=[]

    return l

def get_files(path, recursive, pdf):
    file_list = []
    
    list = os.listdir(path)
    for entry in list:
        abs_path = os.path.normpath(path+"/"+entry)
        if os.path.isdir(abs_path) and recursive:
            debug('Sub-directory='+abs_path)
            file_list.extend(get_files(abs_path, recursive, pdf))
        elif os.path.isfile(abs_path):
            debug('Checking the file '+abs_path+'...')
            # Check it is pdf
            if abs_path.split('.')[-1]=='pdf' and pdf:
                debug(abs_path+' is a pdf.')
                file_list.append(abs_path)
            else:
                # Check it is binary
                isBinary = os.system("file \"" + abs_path + "\" | grep text > /dev/null")
                if not isBinary:
                    debug(abs_path+' is not binary')
                    file_list.append(abs_path)
                else:
                    pass
                    debug(abs_path+' is not a file text')
                    
    return file_list

@future
def analyze_files(file_list, keyword, recursive=True, case_sensitive=False,
        whole_words=False, pdf=False):
    dict_out = {}
    for entry in file_list:
        debug('Entry File: '+entry)
        try:
            if entry.split('.')[-1]=='pdf':
                debug('Checking the pdf file '+entry+'...')
                out = subprocess.check_output(['pdftotext', entry,'-'])
                #(st, out) = commands.getstatusoutput('pdftotext "'+entry+'" -')
                file = io.StringIO(out)
            else:
                file = open(entry,'r')

            list_lines = []
            for num, line in enumerate(file):
                if __contains(line, keyword, whole_words, case_sensitive):
                    list_lines.append((num+1, line))

            dict_out[entry] = list_lines
        except UnicodeDecodeError:
            debug(entry+' doesn\'t have a UTF8 encoding.')
            continue
        
    return dict_out

def deep_search(path, keyword, recursive=True, case_sensitive=False,
        whole_words=False, pdf=False):
    
    dict_out = {}
    MAX_THREAD = 300
    file_list = get_files(path, recursive, pdf)
    
    if len(file_list)>MAX_THREAD:
        size = (int)(len(file_list)/MAX_THREAD)+1
    else:
        size = 1   
    
    for ipos in range(0, len(file_list), size):
        o = analyze_files(file_list[ipos:ipos+size], keyword, recursive, case_sensitive,
        whole_words, pdf)
        
    # Update the general dictionary
    dict_all = o.get_all()
    for d in dict_all:
        dict_out.update(d)
        
    return dict_out

#----------------------------------------------------------------------
def __contains(string1, string2, whole_word, case_sensitive):
    """"""
    if not case_sensitive:
        string1 = string1.upper()
        string2 = string2.upper()


    if whole_word:
        pos = string1.find(string2)
        fin_pos = pos + len(string2)-1
        if pos==-1:
            return False;
        if pos!=0 and string.ascii_letters.find(string1[pos-1:pos])!=-1:
            return False
        if fin_pos!=len(string1)-1 and string.ascii_letters.find(string1[fin_pos+1:fin_pos+2])!=-1:
            return False
        return True
    else:
        return string1.find(string2)!=-1
    pass



# ------------------------ Property class ------------------------
########################################################################
class Property:
    """"""
    __conf_dict = {}
    __sessions = {}
    #----------------------------------------------------------------------
    def __init__(self, prop_path, use_sessions=False):
        """
        prop_path: path toward the .conf file
        use_sessions means that the property file is composed by several files
        contained into a directory in prop_path.
        """
        if not os.path.exists(prop_path):
            raise IOError('The property file '+prop_path+' doesn\'t exist.')

        if not os.path.isfile(prop_path):
            raise IOError('The property file '+prop_path+' must be a file.')
        
        exec(open(prop_path).read(), {}, self.__conf_dict)
        debug(self.__conf_dict)

        if use_sessions:
            if prop_path.find('.')==-1:
                conf_dir_path = prop_path + '.d'
            else:
                conf_dir_path = '.'.join(prop_path.split('.')[0:-1]) + '.d'
            
            if os.path.exists(conf_dir_path):
                # Scan all the files inside
                entries = os.listdir(conf_dir_path)
                for e in entries:
                    if os.path.isfile(conf_dir_path +'/'+ e) and e[0]!='.':
                        debug('config file='+e)
                        session_dict = {}
                        exec(open(conf_dir_path+'/'+e).read(), {}, session_dict)
                        debug(session_dict)
                        self.__sessions[e] = session_dict
    #----------------------------------------------------------------------
    def get(self, key, session_name=None):
        """
        This function look for the attribute in the session config file.
        If session_name is None or "" the function looks for the attribute in the
        main config file.
        If there is no key contained into the prop file, it will return None.
        """
        if session_name is None or session_name=='':
            return self.__conf_dict.get(key)

        session = self.__sessions.get(session_name)
        return session.get(key)
       
     #----------------------------------------------------------------------
    def list_sessions(self):
        """
        Lists the sessions in the config directory.
        """
        return list(self.__sessions.keys())



if __name__ == '__main__':
    print(deep_search('/home/feel/usr/','python'))
    pass

