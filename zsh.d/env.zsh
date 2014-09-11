# environment variables
export PYTHONSTARTUP=~/.pythonrc.py
export EDITOR='emacs'
export VISUAL='emacs'
export ALTERNATE_EDITOR=$(select_binary zile mg vim vi)
export LD_LIBRARY_PATH=/usr/lib64/mpich2/lib:$LD_LIBRARY_PATH
[ ! $VIRTUALENVWRAPPER_HOOK_DIR ] && which virtualenvwrapper.sh &>/dev/null && source virtualenvwrapper.sh
