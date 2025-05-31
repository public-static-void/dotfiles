autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
PROMPT='%F{red}%n@%m:%F{cyan}%2~%f${vcs_info_msg_0_}%# '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Cursor shape for vi mode
set_beam_cursor() { echo -ne "\e[5 q"; }
zle-keymap-select() {
  case ${KEYMAP} in
    vicmd) echo -ne "\e[1 q" ;;
    main|viins|"") set_beam_cursor ;;
  esac
}
zle-line-init() { zle -K viins; set_beam_cursor; }
zle -N zle-keymap-select
zle -N zle-line-init
set_beam_cursor
preexec() { set_beam_cursor; }
