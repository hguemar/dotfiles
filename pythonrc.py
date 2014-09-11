import os
import sys
import atexit

try:
    import readline
    import rlcompleter
except ImportError as e:
    print('Error: {}'.format(e))
    sys.exit(0)

# completion
readline.parse_and_bind('tab: complete')

# history
home = os.path.expanduser('~')
history_file = os.path.join(home, '.pythonhistory')
try:
    readline.read_history_file(history_file)
except IOError:
    pass

atexit.register(readline.write_history_file, history_file)

# clean modules
del (os, sys, history_file, atexit, readline, rlcompleter, home)

