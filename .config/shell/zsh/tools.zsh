# Zoxide integration: smart directory jumping
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  # Remap 'cd' to 'z' for convenience
  alias cd='z'
fi

# fzf integration (from your initial config)
if command -v fzf &>/dev/null; then
  [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
  [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
  [[ -f ~/.fzf/shell/key-bindings.zsh ]] && source ~/.fzf/shell/key-bindings.zsh
  [[ -f ~/.fzf/shell/completion.zsh ]] && source ~/.fzf/shell/completion.zsh
fi

# fd integration for fzf (from your initial config)
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
