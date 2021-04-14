# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.

# env
export EDITOR='emacsclient -t'
export PATH="$PATH:~/bin"
export LANG='en_US.UTF-8'

# gpg
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye >/dev/null

# git
export GIT_AUTHOR_EMAIL='christian.hernvall@gmail.com'
export GIT_AUTHOR_NAME='Christian Hernvall'
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"

# pass
export PASSWORD_STORE_GENERATED_LENGTH=128
export PASSWORD_STORE_CHARACTER_SET='[:alnum:]'

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

function __color()
{
    local COLOR='\e['
    case "$2" in
        bold)      COLOR+='1'  ;;
        dim)       COLOR+='2'  ;;
        italic)    COLOR+='3'  ;;
        underline) COLOR+='4'  ;;
        blink)     COLOR+='5'  ;;
        blinkfast) COLOR+='6'  ;;
        invert)    COLOR+='7'  ;;
        hidden)    COLOR+='8'  ;;
        strike)    COLOR+='9'  ;;
        overline)  COLOR+='53' ;;
        normal)    COLOR+='0'  ;;
        # Possible to combine. E.g. "5;9"
        *)         COLOR+="$2" ;;
    esac
    COLOR+=';'
    case "$1" in
        black)        COLOR+='30' ;;
        red)          COLOR+='31' ;;
        green)        COLOR+='32' ;;
        yellow)       COLOR+='33' ;;
        blue)         COLOR+='34' ;;
        magenta)      COLOR+='35' ;;
        cyan)         COLOR+='36' ;;
        white)        COLOR+='37' ;;
        lightblack)   COLOR+='90' ;;
        lightred)     COLOR+='91' ;;
        lightgreen)   COLOR+='92' ;;
        lightyellow)  COLOR+='93' ;;
        lightblue)    COLOR+='94' ;;
        lightmagenta) COLOR+='95' ;;
        lightcyan)    COLOR+='96' ;;
        lightwhite)   COLOR+='97' ;;
        none)         COLOR+='0'  ;;
        *)            COLOR+="$1" ;;
    esac
    COLOR+='m'
    echo -e $COLOR
}

function __set_bash_prompt()
{
    local exit="$?" # Save the exit status of the last command

    # Wrap the color codes between \[ and \], so that
    # bash counts the correct number of characters for line wrapping:
    local PreGitPS1="\[$(__color none)\][\u@\h \[$(__color blue bold)\]\W\[$(__color none)\]"
    local PostGitPS1+=']'
    if [[ ! -z "$VIRTUAL_ENV" ]]; then
        PostGitPS1+="\[$(__color yellow)\]( "
        PostGitPS1+=$(basename $VIRTUAL_ENV)
        PostGitPS1+=")\[$(__color none)\]"
    fi
    if which kubectl &>/dev/null; then
        local KUBE_CONTEXT=$(cat ~/.kube/config \
                                 | grep current-context \
                                 | sed -e 's/current-context: //' -e 's/"//g')
        if [[ ! -z "$KUBE_CONTEXT" ]] && [[ ! "$KUBE_CONTEXT" = "''" ]]; then
            PostGitPS1+="\[$(__color blue)\]("
            PostGitPS1+="⎈${KUBE_CONTEXT}"
            PostGitPS1+=")\[$(__color none)\]"
        fi
    fi
    if which gcloud &>/dev/null; then
        local GCLOUD_CONF=$(cat ~/.config/gcloud/active_config)
        if [[ "$GCLOUD_CONF" != "dummy" ]]; then
            PostGitPS1+="\[$(__color magenta)\]( $GCLOUD_CONF)\[$(__color none)\]"
        fi
    fi
    if [[ $exit != 0 ]]; then
        PostGitPS1+="\[$(__color red)\][$exit]\[$(__color none)\]"
    fi
    PostGitPS1+='$ '

    __git_ps1 "$PreGitPS1" "$PostGitPS1" '(\[$(__color green)\] %s)'
}
function __pre_command()
{
    if [[ "$BASH_COMMAND" != "__post_command" ]]; then
        __set_title "$PWD $BASH_COMMAND"
    fi
}
function __set_title()
{
    echo -ne "\e]0;"; echo -n "$TERM bash - $@"; echo -ne "\a"
}
function __post_command()
{
    __set_bash_prompt
    __set_title "$PWD"
}
PROMPT_COMMAND=__post_command

# virtualenvwrapper
if [ -e '/usr/bin/virtualenvwrapper.sh' ]; then
    export WORKON_HOME=~/envs
    . /usr/bin/virtualenvwrapper.sh
fi

# Disable terminal suspend/resume
stty -ixon

# History
shopt -s histappend
HISTCONTROL=ignorespace:ignoredups
HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="$(__color green)%F $(__color yellow)%T$(__color none): "

test -s ~/.alias && . ~/.alias ||:

# Completion
hash kubectl 2>/dev/null && source <(kubectl completion bash) ||:
hash helm 2>/dev/null && source <(helm completion bash) ||:
hash flux 2>/dev/null && source <(flux completion bash) ||:
# added by travis gem
[ -f /home/c/.travis/travis.sh ] && source /home/c/.travis/travis.sh ||:

[[ -f ~/.workrc ]] && . ~/.workrc ||:

# Put this last to avoid spam from initialization above
trap __pre_command DEBUG
