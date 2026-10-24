export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export PATH="${HOME}/.local/bin:${HOME}/.docker/bin:${PATH}"

export EDITOR="nvim"
export VISUAL="$EDITOR"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZPLUGDIR="${XDG_DATA_HOME}/zsh"
export ZSH="${ZDOTDIR}/.zshrc"

export _ZO_DATA_DIR="${XDG_DATA_HOME}/zoxide"
