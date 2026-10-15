export ZPLUGDIR=$HOME/.local/share/zsh
[[ -d "$ZPLUGDIR" ]] && mkdir -p "$ZPLUGDIR"

source "$ZDOTDIR/zsh_functions"
source "$ZDOTDIR/zsh_plugins"

typeset -U PATH path
export PATH="$HOME/.local/bin:$PATH"


setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB
setopt CORRECT

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"

if [[ -d "$ZPLUGDIR/zsh-completions/src" ]]; then
  fpath=(
    $ZPLUGDIR/zsh-completions/src
    $fpath
  )
fi

if command -v docker &>/dev/null; then
  local docker_completion="$ZDOTDIR/tabtab/_docker"
  if [[ ! -f "$docker_completion" ]]; then
    [[ ! -d "${docker_completion:h}" ]] && mkdir -p "${docker_completion:h}"
    docker completion zsh > "$docker_completion"
  fi
fi

zstyle ":completion:*" matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*:warnings" format '%F{red}no matches found%f'

zmodload zsh/complist

autoload -U compinit
if [[ -n "$HOME/.zcompdump"(#qN.mh+24) ]];then
  compinit
else
  compinit -C
fi

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

if command -v pnpm &>/dev/null; then
  export PNPM_HOME="$HOME/Library/pnpm"
  prepend_path "$PNPM_HOME/bin"

  local pnpm_completion="$ZDOTDIR/tabtab/_pnpm"
  if [[ ! -f "$pnpm_completion" ]]; then
    [[ ! -d "${pnpm_completion:h}" ]] && mkdir -p "${pnpm_completion:h}"
    pnpm completion zsh > "$pnpm_completion"
  fi

  source "$pnpm_completion"
fi

if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi
