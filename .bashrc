# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# We like color
TERM="xterm-256color"
color_prompt=yes

# PS1 settings using 256 colors instead of default ANSI colors
# available from \e[#;#m color codes
# which I haven't been able to get to display everything, even though they should
# Can view all colors by running `show-colors`
CUSER="\[$(tput setaf 33)\]"
# CRUCHI="\[$(tput setaf 220)\]"
CDIR="\[$(tput setaf 123)\]"
CDOLLAR="\[$(tput setaf 31)\]"
CEND="\[$(tput sgr0)\]"
# Putting an escape code in an "echo" call fucks up the formatting for some reason
CENV2="$(tput setaf 51)"
CEND2="$(tput sgr0)"
display_env() {
  if [[ -z "$CONDA_DEFAULT_ENV" ]] || [[ "$CONDA_DEFAULT_ENV" = "base" ]]; then
    echo ""; # base environment isn't worth displaying
  else
    echo "${CENV2}(${CONDA_DEFAULT_ENV}) ${CEND2}";
  fi
}
# NOTE: need to escape shell evaluations like this: \$(function) for them to evaluate
#       every time in the PS1, since it will "echo" $(function) onto the screen
export PS1="\n\$(display_env)${CUSER}\u${CEND}:${CDIR}\w${CEND}\n${CDOLLAR}\$${CEND} "

# enable color support of ls and also add handy aliases
export LS_COLORS='di=1;34:fi=0:ln=33:ex=1;32:mi=31:or=43:*.h=37:*.cuh=90:*.cpp=37:*.jai=37:*.cu=97:*.c=97:*.py=37:*.go=37:*Makefile=96:*.mk=96:*Dockerfile=96:*.txt=90:*.md=90:*LICENSE=90:*.json=90:'

# ignore certain distracting directories that pop up everywhere
alias ls='ls --color=auto -I "*.egg-info" -I "__pycache__"'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# my own highly useful alias
alias grepp="grep -RFIn --exclude='*.ipynb' --exclude='.tags' --exclude-dir='.git' --exclude='__pycache__'"
alias tree="tree -I '__pycache__|*.egg-info'"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'



# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# passwords and such
if [ -f ~/.bash_private ]; then
  . ~/.bash_private
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# export DISPLAY=localhost:0.0

# alias jb=jupyter-notebook-browser
alias v=vi
alias g=git
alias gs="git status"

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.tar.7z)    7z x $1 && tar xvf ${1%.7z} ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *.iso)       7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }


# Graphics!!!!
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
# export LIBGL_ALWAYS_INDIRECT=1


alias vbp='vim    ~/.bashrc'
alias sbp='source ~/.bashrc'


alias e='exit'

# For GCC 10 instead of the default 9
alias gcc='gcc-10'
alias g++='g++-10'


pdf() {
  if [[ $# -ne 1 ]]; then
    echo "usage: pdf <doc.tex>"
  else
    local name="${1%%.*}"
    pdflatex -halt-on-error $1 && okular "$name.pdf"
  fi
}

export PATH="$HOME/local/bin:$PATH"

# For LLVM 11
export PATH="/usr/lib/llvm-11/bin:$PATH"

# Jai
export PATH="$HOME/software/jai/bin:$PATH"
alias jai="jai-linux -x64"

# Opening images and related files
# I have a bash script that processes this so that behavior
# can change subtly for different filetypes if necessary
alias open="open-file"
# alias open="xdg-open"

# for ctags
alias tags="ctags -R -f .tags"


# DOCKER
DOCKER_RUNNING=$(ps aux | grep dockerd | grep -v grep)
if [ -z "$DOCKER_RUNNING" ]; then
  sudo dockerd > /dev/null 2>&1 & disown
fi

# Docker cheatsheet
#  docker system prune -a
#  docker images -a


# GO
export GOROOT=/usr/lib/go

# POSTGRES
######### Start the daemon ##########
# sudo service postgresql start
######### Start psql shell ##########
# sudo -u postgres psql
######### Create database ##########
# >>> create database apalis_dev_local;
######### Enter database ##########
# >>> \c apalis_dev_local;
#########  ##########


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/millerms/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/millerms/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/millerms/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/millerms/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

