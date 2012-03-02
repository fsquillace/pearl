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

'''Module for debugging activities.
'''
__author__ = 'Filippo Squillace'
__date__ = '09/01/2011 - 10:13'
__license__   = 'GPL v3'
__copyright__ = '2011'
__docformat__ = 'restructuredtext en'
__version__ = "0.0.1"


def counter(fn):
    def _counted(*largs, **kargs):
        _counted.invocations += 1
        fn(*largs, **kargs)
    _counted.invocations = 0
    return _counted

