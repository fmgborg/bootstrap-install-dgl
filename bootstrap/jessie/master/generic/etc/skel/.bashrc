# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# fmg
#HISTCONTROL=ignoreboth
HISTCONTROL=ignoredups
#HISTCONTROL=ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# fmg
#HISTSIZE=1000
#HISTFILESIZE=2000
HISTSIZE=6144
HISTFILESIZE=6144

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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
# fmg

# less as vless in vim style
#alias vless='vim -u /usr/share/vim/vim71/macros/less.vim'					# Lenny
#alias vless='vim -u /usr/share/vim/vim72/macros/less.vim'					# Squeeze
#alias vless='vim -u /usr/share/vim/vim73/macros/less.vim'					# Wheezy
alias vless='vim -u /usr/share/vim/vim74/macros/less.vim'					# Jessie

PS1ORIG=${PS1}
#export PS1='\[\033[30m\]\h\[\033[0m\]:\w\$ '							# root	# black
#export PS1='\[\033[31m\]\h\[\033[0m\]:\w\$ '							# root	# red
#export PS1='\[\033[32m\]\h\[\033[0m\]:\w\$ '							# root	# green
#export PS1='\[\033[33m\]\h\[\033[0m\]:\w\$ '							# root	# yellow/orange or in screen orange-brown
#export PS1='\[\033[34m\]\h\[\033[0m\]:\w\$ '							# root	# dark blue
#export PS1='\[\033[35m\]\h\[\033[0m\]:\w\$ '							# root	# violet/magenta
#export PS1='\[\033[36m\]\h\[\033[0m\]:\w\$ '							# root	# cyan
#export PS1='\[\033[37m\]\h\[\033[0m\]:\w\$ '							# root	# white
#
#export PS1='\[\033[30;41m\]\h\[\033[0m\]:\w\$ '						# root	# black on red
#export PS1='\[\033[30;42m\]\h\[\033[0m\]:\w\$ '						# root	# black on green
#export PS1='\[\033[30;43m\]\h\[\033[0m\]:\w\$ '						# root	# black on yellow
#export PS1='\[\033[30;44m\]\h\[\033[0m\]:\w\$ '						# root	# black on dark blue
#export PS1='\[\033[30;45m\]\h\[\033[0m\]:\w\$ '						# root	# black on magenta
#export PS1='\[\033[30;46m\]\h\[\033[0m\]:\w\$ '						# root	# black on cyan
#export PS1='\[\033[30;47m\]\h\[\033[0m\]:\w\$ '						# root	# black on white
#
#export PS1='\[\033[34;43m\]\h\[\033[0m\]:\w\$ '						# root  # dark blue on yellow/orange-brown
#
PS1='\[\033[32m\]\u\[\033[0m\]@\[\033[36m\]\h\[\033[0m\]:\w\$ '					# user green, host cyan
#PS1='\[\033[30;43m\]fmg\[\033[0m \[\033[32m\]\u\[\033[0m\]@\[\033[36m\]\h\[\033[0m\]:\w\$ '	# red on yellow "fmg", user green, host cyan
PS1COLOR=${PS1}

# EOF
