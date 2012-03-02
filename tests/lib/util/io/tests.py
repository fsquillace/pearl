#!/usr/bin/python


import unittest
import os
import random

from util.io import append_entry, get_entry, remove_entry, get_list, get_len
from util.io import DirectoryPathError

from util.io import Property

class SerializeTestCase(unittest.TestCase):
    def setUp(self):
        self.path = '/tmp/serial_object'
        self.el1 = [1,3.4, 'ciao']
        self.el2 = {1:['el'], '2':23}
        
    def tearDown(self):
        """
        Deletes the file for the next tests.
        """
        if os.path.exists(self.path):
            os.system('rm '+ self.path)
    
    ########### POSITIVE TESTS ##########
    def test_sanity_check(self):
        """
        Checks out if the initial elements that'll be appended into the file are
        equals to the elements returned by the get_entry method.
        """
        
        append_entry(self.path, self.el1)
        append_entry(self.path, self.el2)
        el1 = get_entry(self.path, 0)
        el2 = get_entry(self.path, 1)
        
        self.assertEqual(el1, self.el1)
        self.assertEqual(el2, self.el2)

    def test_append_and_remove_entry(self):
        """
        Checks out if after removing entries the remained elements are corrects
        """
        
        for i in range(10):
            append_entry(self.path, self.el1)
            append_entry(self.path, self.el2)
        
        num_el_to_remove = random.randint(0,19)
        for i in range(num_el_to_remove):
            remove_entry(self.path, random.randint(0, get_len(self.path)-1))
            
        self.assertEqual(20-num_el_to_remove, get_len(self.path))
        

    
    ########### NEGATIVE TESTS ##########
    def test_path_not_string(self):
        """
        The functions raise AttributeError whether the path is not a string.
        """
        self.assertRaises(AttributeError, append_entry, 2, self.el1)
        self.assertRaises(AttributeError, remove_entry, 2, self.el1)
        self.assertRaises(AttributeError, get_entry, 2, self.el1)
        self.assertRaises(AttributeError, get_list, 2)
        self.assertRaises(AttributeError, get_len, 2)
        
    def test_is_directory(self):
        """
        Checks out if the function raises Exception when the path specified is a directory.
        Test on append_entry, remove_entry, get_index_, get_list
        """
        self.assertRaises(DirectoryPathError, append_entry, '/tmp/', self.el1)
        self.assertRaises(DirectoryPathError, remove_entry, '/tmp/', self.el1)
        self.assertRaises(DirectoryPathError, get_entry, '/tmp/', self.el1)
        self.assertRaises(DirectoryPathError, get_list, '/tmp/')
        self.assertRaises(DirectoryPathError, get_len, '/tmp/')

    def test_out_of_range(self):
        """
        Checks out if the index specified by the user is out of range raising the exception
        """
        append_entry(self.path, self.el1)
        append_entry(self.path, self.el2)
        append_entry(self.path, self.el1)
        append_entry(self.path, self.el2)
        
        self.assertRaises(IndexError, get_entry, self.path, -1)
        self.assertRaises(IndexError, get_entry, self.path, 4)
        
        self.assertRaises(IndexError, remove_entry, self.path, -1)
        self.assertRaises(IndexError, remove_entry, self.path, 4)        
        
        pass
    

class PropertyTestCase(unittest.TestCase):
    def setUp(self):
        self.path = '/tmp/prop_file'
        f = open(self.path, 'w')
        f.write('# qst e\' una prova\n')
        f.write('var = "value"')
        f.close()
        self.prop = Property(self.path)
        
        self.path_sess = '/tmp/prop_file_session'
        self.path_sess_dir = '/tmp/prop_file_session.d'
        f = open(self.path_sess, 'w')
        f.write('# qst e\' una prova\n')
        f.close()
        os.mkdir(self.path_sess_dir)
        f_s = open(self.path_sess_dir+'/test', 'w')
        f_s.write('var = 45')
        f_s.close()
        self.prop_sess = Property(self.path_sess, True)

        
    def tearDown(self):
        """
        Deletes the file for the next tests.
        """
        if os.path.exists(self.path):
            os.system('rm '+ self.path)
        if os.path.exists(self.path_sess_dir):
            os.system('rm -rf '+ self.path_sess_dir)
    
    def test_get_prop(self):
        el = self.prop.get('var')
        self.assertEqual(el, 'value')
        
    def test_get_error(self):
        el = self.prop.get('var_not_exist')
        self.assertEqual(el, None)
    
    def test_get_prop_sess(self):
        el = self.prop_sess.get('var', 'test')
        self.assertEqual(el, 45)
        
    def test_get_error_sess(self):
        el = self.prop_sess.get('var_not_exist')
        self.assertEqual(el, None)
    
if __name__=='__main__':
    unittest.main()
