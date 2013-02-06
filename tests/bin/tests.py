#!/usr/bin/python


import unittest
import os

p = os.environ['PYTHONPATH']

import todo

#class BackupTestCase(unittest.TestCase):
#    def setUp(self):
#        self.root_tests = '/tmp/pearl-tests/'
#        
#        os.environ["PEARL_HOME"] = self.root_tests + os.environ["PEARL_HOME"]
#        os.environ["HOME"] = self.root_tests + os.environ["HOME"]
#        
#        os.system('mkdir -p '+ self.root_tests + os.environ["PEARL_HOME"]+ '/etc');
#        os.system('mkdir -p '+ self.root_tests + os.environ["PEARL_HOME"]+ '/backups');
#        
#        self.path = self.root_tests + os.environ["PEARL_HOME"] + '/etc/backup.conf'
#        
#        s = """
#paths = ['/boot/grub/menu.lst', '/etc/modprobe.d/my_blacklist.conf', \
#'/etc/autofs/','/etc/fstab','/etc/fonts/','/etc/hosts','/etc/hosts.bak',\
#'/etc/makepkg.conf','/etc/mtab','/etc/pacman.conf','/etc/rc.conf', \
#'/etc/resolv.conf', '/etc/sudoers','/etc/X11/','/etc/network.d/', \
#'/etc/wpa_supplicant.conf', '/etc/mkinitcpio.conf','/etc/suspend.conf',\
#'/etc/hibernate/', '/etc/ppp/options-mobile', '/etc/ppp/peers/',\
#'/etc/ppp/chatscripts/', '/etc/ppp/wait-dialup-hardware']
#
#bkp_dir = '/tmp/pearl/backups'
#
#execs = {'pkglist': 'pacman -Qqe', 'pkglistfull':'pacman -Qq'}
#        """
#        f = open(self.path, 'w')
#        f.write(s)
#        f.close()
#        
#        os.environ["PEARL_HOME"] = '/tmp/pearl/'
#        
#    def tearDown(self):
#        """
#        Deletes the file for the next tests.
#        """
#        if os.path.exists('/tmp/pearl'):
#            os.system('rm -rf /tmp/pearl')
#
#    
#    def test_do_backup(self):
#        backup.do_backup(None, False)
#        lis = os.listdir('/tmp/pearl/backups')
#        print(lis)
#        self.assertEqual(len(lis), 1)
        
        
class TodoTestCase(unittest.TestCase):
    def setUp(self):
        self.root_tests = '/tmp/pearl-tests/'
        
        os.environ["PEARL_HOME"] = self.root_tests + os.environ["PEARL_HOME"]
        os.environ["HOME"] = self.root_tests + os.environ["HOME"]
        
        os.system('mkdir -p '+ self.root_tests + os.environ["PEARL_HOME"]);
        os.system('mkdir -p '+ self.root_tests + os.environ["HOME"] + '.config/ranger/');
        
        
    def tearDown(self):
        """
        Deletes the file for the next tests.
        """
        if os.path.exists(self.root_tests):
            os.system('rm -rf '+self.root_tests)

    
    def test_do_backup(self):
        lis = os.listdir('/tmp/pearl/backups')
        print(lis)
        self.assertEqual(len(lis), 1)
        
if __name__=='__main__':
    unittest.main()
