# Call PDB when an exception is raised
# USAGE: python -m pdb_on_err script.py arg1 arg2
# FROM: http://stackoverflow.com/questions/242485/starting-python-debugger-automatically-on-error
import sys

def excepthook(type, value, tb):
    if hasattr(sys, 'ps1') or not sys.stderr.isatty():
    # we are in interactive mode or we don't have a tty-like
    # device, so we call the default hook
        sys.__excepthook__(type, value, tb)
    else:
        import traceback, pdb
        # we are NOT in interactive mode, print the exception...
        traceback.print_exception(type, value, tb)
        print
        # ...then start the debugger in post-mortem mode.
        pdb.post_mortem(tb)

if __name__ == '__main__':
    if len(sys.argv) == 1:
        sys.stderr.write('Syntax error: pypdb script.py arg1 arg2 ...\n')
        exit(127)

    sys.excepthook = excepthook
    sys.argv = sys.argv[1:]
    exec(open(sys.argv[0]).read())



