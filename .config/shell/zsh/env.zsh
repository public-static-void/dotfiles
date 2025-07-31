# PATH and environment variables
typeset -U PATH path
path=(
  /usr/bin
  /bin
  /usr/local/bin
  /usr/sbin
  /sbin
  $HOME/.pyenv/bin
  $HOME/perl5/bin
  $HOME/.local/bin
  $HOME/scripts
  $HOME/.cargo/bin
  $HOME/go/bin
  $HOME/.config/composer/vendor/bin
  $HOME/.gem/ruby/*/bin(N)
  $HOME/.local/share/gem/ruby/3.4.0/bin
  ${path}
)
export PATH

# Perl local::lib setup for Neovim provider support
export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB+:$PERL5LIB}"
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

# NVM, pyenv, direnv, Java
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 2>/dev/null
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv &>/dev/null && eval "$(pyenv init --path)"
command -v pyenv &>/dev/null && eval "$(pyenv init -)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
[ -d "/usr/lib/jvm/default" ] && export JAVA_HOME="/usr/lib/jvm/default"

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
