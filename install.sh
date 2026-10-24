#!/usr/bin/env bash

set -Eeuo pipefail

REPO="https://github.com/just100meat/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
MISE_CONFIG="$DOTFILES_DIR/config/mise/config.toml"

usage() {
  cat <<'EOF'
Usage:
  ./install.sh [options]

Options:
  -h, --help   Show this help

Environment:
  DOTFILES_DIR Installation directory (default: ~/.dotfiles)
EOF
}

if (($# > 0)); then
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage >&2
    exit 1
    ;;
  esac
fi

echo "Checking dependencies"

if ! command -v git >/dev/null 2>&1; then
  if [[ "$(uname -s)" == "Darwin" ]]; then
    xcode-select --install || true
    echo "Install the Command Line Tools, then rerun this script." >&2
  else
    echo "Git is required. Install Git, then rerun this script." >&2
  fi
  exit 1
fi

command -v curl >/dev/null 2>&1 || {
  echo "Error: curl is required to install mise." >&2
  exit 1
}

git --version

echo "Installing dotfiles"

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  echo "$DOTFILES_DIR already exists"
elif [[ -e "$DOTFILES_DIR" ]]; then
  echo "Error: $DOTFILES_DIR exists but is not a Git repository" >&2
  exit 1
else
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone "$REPO" "$DOTFILES_DIR"
fi

echo "Installing mise"

if command -v mise >/dev/null 2>&1; then
  mise --version
else
  curl -fsSL https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"

command -v mise >/dev/null 2>&1 || {
  echo "Error: mise is not available on PATH" >&2
  exit 1
}

mise --version

if [[ ! -f "$MISE_CONFIG" ]]; then
  echo "Error: mise config not found: $MISE_CONFIG" >&2
  exit 1
fi

echo "Bootstrapping machine"

env MISE_GLOBAL_CONFIG_FILE="$MISE_CONFIG" \
  mise bootstrap --yes --skip-dirty

echo "Applying dotfiles"

mise trust "$DOTFILES_DIR"

mise -C "$DOTFILES_DIR" bootstrap dotfiles apply --yes

echo "Dotfiles installation complete"
