# Safe file operations: prompt before overwriting or deleting
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Manage dotfiles with a bare Git repository
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Use 'lsd' for colorful directory listing if available, else fallback to GNU ls with colors
if command -v lsd >/dev/null 2>&1; then
  alias ls="lsd -h --group-dirs first"
  alias la="lsd -hA --group-dirs first"
  alias ll="lsd -hlA --group-dirs first"
else
  alias ls="ls --color=auto"
  alias la="ls -A --color=auto"
  alias ll="ls -alF --color=auto"
fi

# Use 'rg' (ripgrep) as grep replacement if available, else grep with color
# if command -v rg >/dev/null 2>&1; then
#   alias grep="rg"
# else
#   alias grep="grep --color=auto"
# fi

# Use 'fd' as a modern, fast alternative to 'find' if available
# if command -v fd >/dev/null 2>&1; then
#   alias find="fd"
#   alias fdf="fd --type f"      # Find files only
#   alias fdd="fd --type d"      # Find directories only
#   alias fdh="fd --hidden"      # Include hidden files
# fi

# Package managers with color output
alias pacman="sudo pacman --color=auto"
alias trizen="trizen --color=auto"
alias yay="yay --color=auto"

# Remove orphaned packages safely
alias remorph="pacman -Qtdq | pacman -Rns -"
