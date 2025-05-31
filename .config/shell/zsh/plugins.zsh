# Antidote plugin manager and plugins loading
if [[ ! -f ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
fi
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
zsh_plugins_file="${ZDOTDIR:-$HOME}/.zsh_plugins"
[[ -f ${zsh_plugins_file}.txt ]] || touch ${zsh_plugins_file}.txt
if [[ ! ${zsh_plugins_file}.zsh -nt ${zsh_plugins_file}.txt ]]; then
  antidote bundle <${zsh_plugins_file}.txt >|${zsh_plugins_file}.zsh
fi
source ${zsh_plugins_file}.zsh

ANTIDOTE_LAST_UPDATE_FILE="${ZDOTDIR:-$HOME}/.antidote/.last_update"
ANTIDOTE_UPDATE_INTERVAL=$((60*60*24*7))
if [[ ! -f $ANTIDOTE_LAST_UPDATE_FILE ]] || (( $(date +%s) - $(< $ANTIDOTE_LAST_UPDATE_FILE) > ANTIDOTE_UPDATE_INTERVAL )); then
  (antidote update && date +%s >| $ANTIDOTE_LAST_UPDATE_FILE) &> /dev/null &!
fi
