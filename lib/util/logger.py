#!/usr/bin/python3
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

'''
    Library used for pearl logging.
    There are three types of messages:
    *   error, is the message when something was gone wrong in the code (ex.
        division by zero, ...);

    *   warn, is the message when input data are not well formed (ex. bad
        encoding file, ...);

    *   debug, gives some information during the program execution;

    *   info, is exactly the same of a print.

    It could be better that only the error, warn and info messages are be visible in
    all the cases. debug can be visible only when is activated the
    environment variable PEARL_DEBUG by the user.

'''
__author__ = 'Filippo Squillace'
__date__ = '30/09/2010'
__license__   = 'GPL v3'
__copyright__ = '2010'
__docformat__ = 'restructuredtext en'
__version__ = "0.1.2"


__all__ = ["error", "warn", "info", "debug"]

import sys, logging, os
from logging import Formatter, FileHandler, StreamHandler

#----------------------------------------------------------------------
def addHandler(handler=None, stream=None, filename=None, filemode='a', \
               fmt=None, datefmt=None, \
               level=None, max_level=None, filters=(), logger=None):
    """stream, filename, filemode, format, datefmt: as per logging.basicConfig

       handler: use a precreated handler instead of creating a new one
       logger: logger to add the handler to (uses root logger if none specified)
       filters: an iterable of filters to add to the handler
       level: only messages of this level and above will be processed
       max_level: only messages of this level and below will be processed
    """
    # Create the handler if one hasn't been passed in
    if handler is None:
        if filename is not None:
            handler = FileHandler(filename, filemode)
        else:
            handler = StreamHandler(stream)
    # Set up the formatting of the log messages
    formatter = Formatter(fmt, datefmt)
    handler.setFormatter(formatter)
    # Set up filtering of which messages to handle
    if level is not None:
        handler.setLevel(level)
    if max_level is not None:
        class level_ok():
            def filter(self, record):
                return record.levelno <= max_level
        handler.addFilter(level_ok())
    for filter in filters:
        handler.addFilter(filter)
    # Add the fully configured handler to the specified logger
    if logger:
        logger.addHandler(handler)
    else:
        logging.getLogger().addHandler(handler)
    return handler

    
    
__datefmt__ = '%Y-%m-%d %H:%M:%S'
__fmt_norm__='%(asctime)s %(levelname)s: File %(filename)s:%(lineno)d, in %(funcName)s\t%(message)s'
__fmt_err__='%(asctime)s \033[1;31m%(levelname)s\033[1;m: File %(filename)s:%(lineno)d, in %(funcName)s\t\033[1;31m%(message)s\033[1;m'
__fmt_warn__='%(asctime)s \033[1;33m%(levelname)s\033[1;m: File %(filename)s:%(lineno)d, in %(funcName)s\t\033[1;33m%(message)s\033[1;m'
__fmt_debug__='%(asctime)s \033[1;32m%(levelname)s\033[1;m: File %(filename)s:%(lineno)d, in %(funcName)s\t\033[1;32m%(message)s\033[1;m'


# Create an instance of Logger
py_logger = logging.getLogger('pearl')
try:
    if os.environ['PEARL_DEBUG']=='1':
        # Let root logger handlers see all messages.
        py_logger.setLevel(logging.DEBUG)
    else:
        # Let root logger handlers see only messages from INFO level or upper.
        py_logger.setLevel(logging.INFO)
except KeyError:
    # If the environment variable doesn't exist, set the level to DEBUG
    py_logger.setLevel(logging.DEBUG)


    
addHandler(stream=sys.stderr, \
                    level=logging.ERROR, max_level=logging.ERROR, \
                    fmt=__fmt_err__, datefmt=__datefmt__, logger=py_logger)
addHandler(stream=sys.stderr,  \
           level=logging.WARNING, max_level=logging.WARNING, \
           fmt=__fmt_warn__, datefmt=__datefmt__, logger=py_logger)
addHandler(stream=sys.stdout,  \
           level=logging.INFO, max_level=logging.INFO, \
           datefmt=__datefmt__, logger=py_logger)
addHandler(stream=sys.stdout,  \
           level=logging.DEBUG, max_level=logging.DEBUG, \
           fmt=__fmt_debug__, datefmt=__datefmt__, logger=py_logger)

#-----------------------Method for stderr-------------------------------------
# Just abbreviations
error = py_logger.error
warn = py_logger.warn
#-----------------------Method for stdout-------------------------------------
# Just abbreviations
info = py_logger.info
debug = py_logger.debug
    
    

if __name__ == '__main__':
    info("Hello world!") # only displayed once
    warn("Hello world!") # only displayed once
    debug("This is for debug")
