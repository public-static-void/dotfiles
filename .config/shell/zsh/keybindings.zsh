bindkey -v
export KEYTIMEOUT=1

# Keybindings
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -v "^?" backward-delete-char
bindkey -M menuselect '^xi' vi-insert
bindkey -M menuselect '^xu' undo
bindkey "^[[2~" yank
bindkey "^[[3~" delete-char
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey -a "^[[2~" yank
bindkey -a "^[[3~" delete-char
bindkey -a "^[[5~" up-line-or-history
bindkey -a "^[[6~" down-line-or-history
bindkey -a "^[[7~" beginning-of-line
bindkey -a "^[[8~" end-of-line
