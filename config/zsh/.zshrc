source "${ZDOTDIR}/functions.zsh"

setopt AUTO_CD
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt CORRECT

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

_zplug "zsh-users/zsh-completions"
_zplug "zsh-users/zsh-autosuggestions"
_zplug "zsh-users/zsh-history-substring-search"

zmodload zsh/complist

zstyle ":completion:*" matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change

fpath=("${ZDOTDIR}/tabtab" "${fpath[@]}")
if [[ -d "${ZPLUGDIR}/zsh-completions/src" ]]; then
  fpath=("${ZPLUGDIR}/zsh-completions/src" "${fpath[@]}")
fi

_zcomp docker
_zcomp mise
_zcomp pnpm

autoload -Uz compinit
zmodload zsh/stat
zmodload zsh/datetime

_ZCOMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

if [[ ! -f "${_ZCOMPDUMP}" ]] ||
  ((EPOCHSECONDS - $(zstat +mtime "${_ZCOMPDUMP}") >= 86400)); then
  compinit -d "${_ZCOMPDUMP}"
else
  compinit -C -d "${_ZCOMPDUMP}"
fi

unset _ZCOMPDUMP

source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/keymaps.zsh"

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

if command -v fzf >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(fzf --zsh)
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd --hook pwd)"
fi

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

_zplug "zsh-users/zsh-syntax-highlighting"
