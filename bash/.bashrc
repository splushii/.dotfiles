# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.

# env
export EDITOR='emacsclient -t'
export PATH="$PATH:~/bin"
export LANG='en_US.UTF-8'
export GPG_TTY=$(tty)

# git
export GIT_AUTHOR_EMAIL='christian.hernvall@gmail.com'
export GIT_AUTHOR_NAME='Christian Hernvall'
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"

# completion
. /usr/share/bash-completion/completions/pass
complete -o filenames -F _pass pw

# prompt
. /usr/share/git/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=y
export GIT_PS1_SHOWSTASHSTATE=y
export GIT_PS1_SHOWUNTRACKEDFILES=y
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_STATESEPARATOR=
export GIT_PS1_SHOWCOLORHINTS=1

__set_bash_prompt()
{
    local exit="$?" # Save the exit status of the last command

    # Wrap the colour codes between \[ and \], so that
    # bash counts the correct number of characters for line wrapping:
    local Red='\[\e[0;31m\]'; local BRed='\[\e[1;31m\]'
    local Gre='\[\e[0;32m\]'; local BGre='\[\e[1;32m\]'
    local Yel='\[\e[0;33m\]'; local BYel='\[\e[1;33m\]'
    local Blu='\[\e[0;34m\]'; local BBlu='\[\e[1;34m\]'
    local Mag='\[\e[0;35m\]'; local BMag='\[\e[1;35m\]'
    local Cya='\[\e[0;36m\]'; local BCya='\[\e[1;36m\]'
    local Whi='\[\e[0;37m\]'; local BWhi='\[\e[1;37m\]'
    local None='\[\e[0m\]' # Return to default colour

    local PreGitPS1="[\u@\h $BBlu\W$None"
    local PostGitPS1+=']'
    if [[ ! -z "$VIRTUAL_ENV" ]]; then
        PostGitPS1+="$Yel("
        PostGitPS1+=$(basename $VIRTUAL_ENV)
        PostGitPS1+=")$None"
    fi
    if [[ $exit != 0 ]]; then
        PostGitPS1+="$Red[$exit]$None"
    fi
    PostGitPS1+='$ '

    __git_ps1 "$PreGitPS1" "$PostGitPS1" '(%s)'
}
PROMPT_COMMAND=__set_bash_prompt

# virtualenvwrapper
if [ -e '/usr/bin/virtualenvwrapper.sh' ]; then
    export WORKON_HOME=~/envs
    source /usr/bin/virtualenvwrapper.sh
fi

# Disable terminal suspend/resume
stty -ixon

test -s ~/.alias && . ~/.alias || true

source <(kubectl completion bash)
source <(helm completion bash)

[[ -f ~/.workrc ]] && . ~/.workrc || true
