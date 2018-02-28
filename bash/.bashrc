# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.

# env
export EDITOR='emacsclient -t'
export PATH="$PATH:~/bin"
export LANG='en_US.UTF-8'

# git
export GIT_AUTHOR_EMAIL='christian.hernvall@gmail.com'
export GIT_AUTHOR_NAME='Christian Hernvall'
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"

# virtualenvwrapper
if [ -e '/usr/bin/virtualenvwrapper.sh' ]; then
    export WORKON_HOME=~/envs
    source /usr/bin/virtualenvwrapper.sh
fi

# Disable terminal suspend/resume
stty -ixon

test -s ~/.alias && . ~/.alias || true

[[ -f ~/.workrc ]] && . ~/.workrc
