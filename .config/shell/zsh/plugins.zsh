# Path to the plugin list and compiled bundle
zsh_plugins_file="$HOME/.config/shell/zsh/zsh_plugins"

# Ensure the plugins list exists
[[ -f ${zsh_plugins_file}.txt ]] || touch ${zsh_plugins_file}.txt

# Bootstrap Antidote if not already installed
if [[ ! -f ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
fi

# Source the Antidote plugin manager
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh

# Rebuild the static plugins bundle if the list is newer or the bundle is missing
if [[ ! ${zsh_plugins_file}.zsh -nt ${zsh_plugins_file}.txt ]]; then
  antidote bundle <${zsh_plugins_file}.txt >|${zsh_plugins_file}.zsh
fi

# Source the compiled static plugins bundle
source ${zsh_plugins_file}.zsh

# Auto-update Antidote plugins once a week in the background
ANTIDOTE_LAST_UPDATE_FILE="${ZDOTDIR:-$HOME}/.antidote/.last_update"
ANTIDOTE_UPDATE_INTERVAL=$((60*60*24*7))  # 1 week

if [[ ! -f $ANTIDOTE_LAST_UPDATE_FILE ]] || (( $(date +%s) - $(< $ANTIDOTE_LAST_UPDATE_FILE) > ANTIDOTE_UPDATE_INTERVAL )); then
  (antidote update && date +%s >| $ANTIDOTE_LAST_UPDATE_FILE) &> /dev/null &!
fi
