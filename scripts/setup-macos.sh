#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VSCODE_APP="/Applications/Visual Studio Code.app"
VSCODE_CLI="$VSCODE_APP/Contents/Resources/app/bin/code"

log() {
  printf '\n==> %s\n' "$1"
}

require_macos() {
  if [ "$(uname -s)" != "Darwin" ]; then
    echo "This script only supports macOS." >&2
    exit 1
  fi
}

load_brew_env() {
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

add_brew_to_zprofile() {
  local line
  line="eval \"\$($(brew --prefix)/bin/brew shellenv)\""
  if ! grep -qs "brew shellenv" "$HOME/.zprofile"; then
    log "Adding Homebrew to ~/.zprofile so new shells and VS Code can find it"
    printf '\n%s\n' "$line" >> "$HOME/.zprofile"
  fi
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew found: $(brew --version | head -n 1)"
    return
  fi
  if [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
    log "Installing Homebrew (it may ask for your password)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  load_brew_env
  add_brew_to_zprofile
}

ensure_tectonic() {
  if brew list --formula tectonic >/dev/null 2>&1; then
    log "Tectonic found: $(tectonic --version)"
  else
    log "Installing Tectonic (the XeLaTeX engine)"
    brew install tectonic
  fi
}

ensure_vscode() {
  if [ -d "$VSCODE_APP" ]; then
    log "VS Code found"
  else
    log "Installing VS Code"
    brew install --cask visual-studio-code
  fi
}

ensure_code_command() {
  if command -v code >/dev/null 2>&1; then
    log "The code command is on PATH"
    return
  fi
  log "Linking the code command into $(brew --prefix)/bin"
  ln -sf "$VSCODE_CLI" "$(brew --prefix)/bin/code"
}

install_vscode_extensions() {
  local id
  for id in $(grep -oE '"[A-Za-z0-9-]+\.[A-Za-z0-9-]+"' "$REPO_DIR/.vscode/extensions.json" | tr -d '"'); do
    log "VS Code extension $id"
    "$VSCODE_CLI" --install-extension "$id"
  done
}

build_resume_once() {
  log "Building the resume once (the first build downloads LaTeX packages and can take a few minutes)"
  make -C "$REPO_DIR" pdf
}

main() {
  require_macos
  ensure_homebrew
  ensure_tectonic
  ensure_vscode
  ensure_code_command
  install_vscode_extensions
  build_resume_once
  log "Done. Open the repo with: code \"$REPO_DIR\""
}

main "$@"
