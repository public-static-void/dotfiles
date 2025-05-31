zmodload zsh/complist
autoload -Uz compinit && compinit

_comp_options+=(globdots)
setopt MENU_COMPLETE
setopt COMPLETE_IN_WORD

zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu select
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 5 )) )'
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true
zstyle ":completion::complete:*" gain-privileges 1

blanktab() {
  if [[ $#BUFFER == 0 ]]; then
    zle list-choices
  else
    zle expand-or-complete
  fi
}
zle -N blanktab
bindkey "^I" blanktab

if command -v ng &>/dev/null; then
  source <(ng completion script)
fi
