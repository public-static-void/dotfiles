#!/bin/bash

#############
# ~/.bashrc #
#############

# Exit if not running interactively
[[ $- != *i* ]] && return

# Disable beeps and terminal freezing from Ctrl-S
set bell-style none
stty -ixon

# Enable vi mode and autocd
set -o vi
shopt -s autocd

# History settings
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
PROMPT_COMMAND='history -a; history -n'

# Prompt with Git branch
parse_git_branch() {
  [ ! -d .git ] && return
  local head
  head=$(awk 'NR==1 {print $2; exit}' .git/HEAD 2>/dev/null) || return
  if [[ $head == refs/heads/* ]]; then
    echo " (${head#refs/heads/})"
  elif [[ -n $head ]]; then
    echo " ($head)"
  fi
}
if [ "$(id -u)" -eq 0 ]; then
  PS1='\[\e[31m\]\u@\h:\[\e[36m\]\w\[\e[33m\]$(parse_git_branch)\[\e[0m\] # '
else
  PS1='\[\e[32m\]\u@\h:\[\e[36m\]\w\[\e[33m\]$(parse_git_branch)\[\e[0m\] $ '
fi

# Editor and colors
if [[ -n $SSH_CONNECTION ]]; then
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

# PATH additions (preserve order and uniqueness)
add_to_path() {
  for dir in "$@"; do
    case ":$PATH:" in
      *":$dir:"*) ;; # already in PATH
      *) PATH="$dir:$PATH" ;;
    esac
  done
}
add_to_path "$HOME/.pyenv/bin" "$HOME/perl5/bin" "$HOME/.local/bin" "$HOME/scripts" "$HOME/.cargo/bin" "$HOME/go/bin" "$HOME/.config/composer/vendor/bin"
export PATH

# Autostart (fastfetch)
if command -v fastfetch &>/dev/null; then
  fastfetch --logo-color-2 "22"
fi

# --- Aliases (universal/common) ---
[ -f "$HOME/.config/shell/aliases/common.sh" ] && . "$HOME/.config/shell/aliases/common.sh"

# --- Aliases (context-specific) ---
[ -f "$HOME/.config/shell/aliases/xrandr.sh" ] && . "$HOME/.config/shell/aliases/xrandr.sh"
[ -f "$HOME/.config/shell/aliases/cam.sh" ] && . "$HOME/.config/shell/aliases/cam.sh"
[ -f "$HOME/.config/shell/aliases/games.sh" ] && . "$HOME/.config/shell/aliases/games.sh"

# --- Functions (all) ---
for f in "$HOME/.config/shell/functions/"*.sh; do
  [ -f "$f" ] && . "$f"
done

# Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion
