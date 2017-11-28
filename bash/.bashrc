# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.

# editor
export EDITOR='emacsclient -t'

# virtualenvwrapper
if [ -e '/usr/bin/virtualenvwrapper.sh' ]; then
    export WORKON_HOME=~/envs
    source /usr/bin/virtualenvwrapper.sh
fi

# ssh-add
export SSH_ASKPASS=/usr/lib/ssh/ksshaskpass
/usr/bin/ssh-add </dev/null 2>/dev/null

# Disable terminal suspend/resume
stty -ixon

test -s ~/.alias && . ~/.alias || true
