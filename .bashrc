#!/bin/bash

#############
# ~/.bashrc #
#############

####################
# GENERAL SETTINGS #
####################

# Disable beeps.
set bell-style none

# Disable ctrl+s ctrl+q.
stty -ixon

# Enable vi mode.
set -o vi

# Allow to change directory without typing 'cd'.
shopt -s autocd

# History settings.
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
PROMPT_COMMAND='history -a; history -n'

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

###################
# PROMPT SETTINGS #
###################

# Function to get current git branch, if any
parse_git_branch() {
	git rev-parse --is-inside-work-tree &>/dev/null || return
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set prompt with colors and git branch, red for root, cyan for user
if [ "$(id -u)" -eq 0 ]; then
	# Root: Red user/host, cyan path, yellow git branch
	PS1='\[\e[31m\]\u@\h:\[\e[36m\]\w\[\e[33m\]$(parse_git_branch)\[\e[0m\] # '
else
	# User: Green user/host, cyan path, yellow git branch
	PS1='\[\e[32m\]\u@\h:\[\e[36m\]\w\[\e[33m\]$(parse_git_branch)\[\e[0m\] $ '
fi

# Editor and colors
if [[ -n "$SSH_CONNECTION" ]]; then
	export EDITOR="vim"
	export VISUAL="vim"
	export MANPAGER="vim -c 'set ft=man' -"
elif command -v nvim >/dev/null 2>&1; then
	export EDITOR="nvim"
	export VISUAL="nvim"
	export MANPAGER="nvim +Man!"
else
	export EDITOR="vim"
	export VISUAL="vim"
	export MANPAGER="vim -c 'set ft=man' -"
fi

export LS_COLORS="${LS_COLORS}:di=0;36:"

#########
# PATHS #
#########

add_to_path() {
	for dir in "$@"; do
		case ":$PATH:" in
		*":$dir:"*) ;; # already in PATH
		*) PATH="$dir:$PATH" ;;
		esac
	done
}
add_to_path "$HOME/.pyenv/bin" "$HOME/perl5/bin" "$HOME/.local/bin" "$HOME/scripts" "$HOME/.cargo/bin" "$HOME/go/bin" "$HOME/.config/composer/vendor/bin"

# Export the PATH-variable.
export PATH

#############
# AUTOSTART #
#############

# Start fastfetch with terminal.
if command -v fastfetch &>/dev/null; then
	fastfetch --logo-color-2 "22"
fi

###########
# ALIASES #
###########

if [ -f "$HOME/.aliases" ]; then
	. "$HOME/.aliases"
fi

#############
# FUNCTIONS #
#############

if [ -f "$HOME/.functions" ]; then
	. "$HOME/.functions"
fi

##############
# COMPLETION #
##############

[ -f /etc/bash_completion ] && . /etc/bash_completion
