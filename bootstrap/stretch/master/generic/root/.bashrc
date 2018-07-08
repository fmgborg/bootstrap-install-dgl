
# EOF
# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
# fmg 2015-10-08 01:54
# big ~/.bash_history
export HISTCONTROL=ignoredups
export HISTFILESIZE=8192
export HISTSIZE=8192

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# less as vless in vim style
#alias vless='vim -u /usr/share/vim/vim71/macros/less.vim'							# Lenny
#alias vless='vim -u /usr/share/vim/vim72/macros/less.vim'							# Squeeze
#alias vless='vim -u /usr/share/vim/vim73/macros/less.vim'							# Wheezy
#alias vless='vim -u /usr/share/vim/vim74/macros/less.vim'							# Jessie
alias vless='vim -u /usr/share/vim/vim80/macros/less.vim'							# Stretch

# colored prompt
PS1ORIG=${PS1}
#export PS1='\[\033[30;41m\]\h\[\033[0m\]:\w\$ '								# white on red
#export PS1='\[\033[30;41m\]\h\[\033[0m\]:\w\$ '								# black on red
#export PS1='\[\033[30;42m\]\h\[\033[0m\]:\w\$ '								# black on green
#export PS1='\[\033[35;42m\]\h\[\033[0m\]:\w\$ '								# violet/magenta on green
#
#export PS1='\[\033[30m\]\h\[\033[0m\]:\w\$ '									# black
#export PS1='\[\033[31m\]\h\[\033[0m\]:\w\$ '									# red
#export PS1='\[\033[32m\]\h\[\033[0m\]:\w\$ '									# green
#export PS1='\[\033[33m\]\h\[\033[0m\]:\w\$ '									# yellow/orange
#export PS1='\[\033[34m\]\h\[\033[0m\]:\w\$ '									# dark blue
#export PS1='\[\033[35m\]\h\[\033[0m\]:\w\$ '									# violet/magenta
#export PS1='\[\033[36m\]\h\[\033[0m\]:\w\$ '									# cyan
#export PS1='\[\033[37m\]\h\[\033[0m\]:\w\$ '									# white
#
#export PS1='\[\033[30;41m\]\h\[\033[0m\]:\w\$ '								# black on red
#export PS1='\[\033[30;42m\]\h\[\033[0m\]:\w\$ '								# black on green
#export PS1='\[\033[30;43m\]\h\[\033[0m\]:\w\$ '								# black on yellow/orange
#export PS1='\[\033[30;44m\]\h\[\033[0m\]:\w\$ '								# black on dark blue
#export PS1='\[\033[30;45m\]\h\[\033[0m\]:\w\$ '								# black on magenta
#export PS1='\[\033[30;46m\]\h\[\033[0m\]:\w\$ '								# black on tuerkis
#export PS1='\[\033[30;47m\]\h\[\033[0m\]:\w\$ '								# black on white
#
#export PS1='\[\033[30;41m\]\h\[\033[0m\]:\w\$ '								# black on red
#export PS1='\[\033[33;41m\]\h\[\033[0m\]:\w\$ '								# yellow/orange on red
#export PS1='\[\033[34;41m\]\h\[\033[0m\]:\w\$ '								# dark blue on red
#export PS1='\[\033[36;41m\]\h\[\033[0m\]:\w\$ '								# cyan on red
#
#export PS1='\[\033[33m\]\h\[\033[0m\]:\w\$ '									# yellow (in screen orange-brown)
#export PS1='\[\033[34;43m\]\h\[\033[0m\]:\w\$ '								# dark blue on yellow/orange-brown
#
#export PS1='\[\033[31m\]\u\[\033[0m\]@\[\033[30;41m\]\h\[\033[0m\]:\w\$ '					# black on red, user red
#export PS1='\[\033[31m\]\u\[\033[0m\]@\[\033[33;41m\]\h\[\033[0m\]:\w\$ '					# yellow on red, user red

#export PS1='chroot \[\033[35m\]\h\[\033[0m\]:\w\$ '								# violet/magenta
#export PS1='\[\033[36m\]\h\[\033[0m\]:\w\$ '									# cyan
#export PS1='\[\033[33;41m\]\h\[\033[0m\]:\w\$ '								# yellow on red
#export PS1='\[\033[31m\]\u\[\033[0m\]@\[\033[33;41m\]\h\[\033[0m\]:\w\$ '					# yellow on red, user red
#PS1='\[\033[30;43m\]chroot\[\033[0m\] \[\033[32m\]\u\[\033[0m\]@\[\033[36m\]\h\[\033[0m\]:\w\$ '		# black on yellow chroot, user green, host cyan
RL=`runlevel`
#if [ "${RL}" = "unknown" ] ; then
#	PS1='\[\033[30;43m\]chroot\[\033[0m\] \[\033[32m\]\u\[\033[0m\]@\[\033[36m\]\h\[\033[0m\]:\w\$ '	# black on yellow chroot, user green, host cyan
#else
#	PS1='\[\033[32m\]\u\[\033[0m\]@\[\033[36m\]\h\[\033[0m\]:\w\$ '						# user green, host cyan
#fi
if [ "${RL}" = "unknown" ] ; then
	PS1='\[\033[30;43m\]chroot\[\033[0m\] \[\033[31m\]\u\[\033[0m\]@\[\033[36m\]\h\[\033[0m\]:\w\$ '	# black on yellow chroot, user red, host cyan
else
	PS1='\[\033[31m\]\u\[\033[0m\]@\[\033[36m\]\h\[\033[0m\]:\w\$ '						# user red, host cyan
fi
PS1COLOR=${PS1}

# colored file list
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'

# EOF
