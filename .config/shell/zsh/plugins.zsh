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

# Auto-regenerate cache if missing
if [[ ! -d ~/.cache/antidote ]]; then
  antidote bundle <${zsh_plugins_file}.txt
fi

# Always regenerate bundle if cache newer OR missing/outdated
if [[ ! -f ${zsh_plugins_file}.zsh || ${zsh_plugins_file}.zsh -ot ~/.cache/antidote ||
  ! ${zsh_plugins_file}.zsh -nt ${zsh_plugins_file}.txt ]]; then
  antidote bundle <${zsh_plugins_file}.txt >|${zsh_plugins_file}.zsh
fi

# Verify bundle works before sourcing (fail-safe)
if [[ -f ${zsh_plugins_file}.zsh ]]; then
  # Test source without errors
  if { source ${zsh_plugins_file}.zsh 2>/dev/null; }; then
    true
  else
    # Bundle broken, regenerate
    antidote bundle <${zsh_plugins_file}.txt >|${zsh_plugins_file}.zsh
    source ${zsh_plugins_file}.zsh
  fi
else
  # Emergency: source plugins.txt directly via antidote load
  antidote load ${zsh_plugins_file}.txt
fi

# Auto-update Antidote plugins once a week
ANTIDOTE_LAST_UPDATE_FILE="${ZDOTDIR:-$HOME}/.antidote/.last_update"
ANTIDOTE_UPDATE_INTERVAL=$((60 * 60 * 24 * 7))
if [[ ! -f $ANTIDOTE_LAST_UPDATE_FILE ]] || (($(date +%s) - $(<$ANTIDOTE_LAST_UPDATE_FILE) > ANTIDOTE_UPDATE_INTERVAL)); then
  (antidote update && date +%s >|$ANTIDOTE_LAST_UPDATE_FILE) &>/dev/null &
fi
