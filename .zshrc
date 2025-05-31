############
# ~/.zshrc #
############

# Exit if not running interactively
[[ $- != *i* ]] && return

# Disable terminal freezing from Ctrl-S
stty -ixon

# --- Zsh modular config: source in logical order ---

# 1. Zsh options
source "$HOME/.config/shell/zsh/options.zsh"

# 2. Environment variables, PATH, editor, colors
source "$HOME/.config/shell/zsh/env.zsh"

# 3. Tools
source "$HOME/.config/shell/zsh/tools.zsh"

# 4. Completion system
source "$HOME/.config/shell/zsh/completions.zsh"

# 5. Keybindings
source "$HOME/.config/shell/zsh/keybindings.zsh"

# 6. Autostart
source "$HOME/.config/shell/zsh/autostart.zsh"

# 7. Aliases (universal/common)
source "$HOME/.config/shell/aliases/common.sh"

# 8. Aliases (context-specific)
source "$HOME/.config/shell/aliases/xrandr.sh"
source "$HOME/.config/shell/aliases/cam.sh"
source "$HOME/.config/shell/aliases/games.sh"

# 9. Functions
for f in "$HOME/.config/shell/functions/"*.sh; do
  [ -f "$f" ] && source "$f"
done

# 10. Plugins
source "$HOME/.config/shell/zsh/plugins.zsh"

# 11. Prompt
source "$HOME/.config/shell/zsh/prompt.zsh"
