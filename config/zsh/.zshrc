export ZPLUGINDIR=$HOME/.local/share/zsh
export PNPM_HOME=$HOME/Library/pnpm

export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PNPM_HOME/bin:$HOME/go/bin:$HOME/.cargo/bin:/opt/homebrew/bin:$PATH"

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS

fpath=(
  $ZPLUGINDIR/zsh-completions/src
  $HOME/.docker/completions
  $fpath
)

zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload -U compinit; compinit
zmodload zsh/complist
autoload -Uz edit-command-line; zle -N edit-command-line

eval "$(mise activate zsh)"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
