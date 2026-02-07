#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$REPO_ROOT/bootstrap/packages"

APT_LIST="$PKG_DIR/apt.txt"
PACMAN_LIST="$PKG_DIR/pacman.txt"
FLATPAK_LIST="$PKG_DIR/flatpak.txt"

log() { printf "\n\033[1m%s\033[0m\n" "$*"; }

# Read a package list
read_list() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$file"
}


need_sudo() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    command -v sudo >/dev/null 2>&1 || { echo "sudo not found; install it or run as root."; exit 1; }
    echo "sudo"
  fi
}

# install thelist of apt packages via apt
install_apt() {
  [[ -f "$APT_LIST" ]] || { echo "Missing $APT_LIST"; exit 1; }
  local SUDO; SUDO="$(need_sudo)"

  log "Using APT (Debian/Ubuntu/Mint)"
  $SUDO apt-get update -y

  # shellcheck disable=SC2046
  $SUDO apt-get install -y $(read_list "$APT_LIST")

  log "APT install complete"
}

# install the list of pacman packages via pacman
install_pacman() {
  [[ -f "$PACMAN_LIST" ]] || {
    echo "Detected pacman, but missing $PACMAN_LIST"
    echo "Create it (on Arch): pacman -Qqe | sort -u > $PACMAN_LIST"
    exit 1
  }
  local SUDO; SUDO="$(need_sudo)"

  log "Using pacman (Arch)"
  $SUDO pacman -Syu --noconfirm

  # shellcheck disable=SC2046
  $SUDO pacman -S --noconfirm --needed $(read_list "$PACMAN_LIST")

  log "pacman install complete"
}

# FLATPACK INSTALL
ensure_flatpak() {
  if command -v flatpak >/dev/null 2>&1; then
    return 0
  fi

  log "Flatpak not found; installing it"
  if command -v apt-get >/dev/null 2>&1; then
    local SUDO; SUDO="$(need_sudo)"
    $SUDO apt-get update -y
    $SUDO apt-get install -y flatpak
  elif command -v pacman >/dev/null 2>&1; then
    local SUDO; SUDO="$(need_sudo)"
    $SUDO pacman -Syu --noconfirm --needed flatpak
  else
    echo "No supported package manager found to install flatpak."
    exit 1
  fi
}

install_flatpaks() {
  log "Flatpak install disabled (temporary)"
  return 0  

  [[ -f "$FLATPAK_LIST" ]] || { log "No flatpak list found (skipping)"; return 0; }

  ensure_flatpak

  log "Configuring Flathub (if needed)"
  if ! flatpak remote-list --columns=name | grep -qx "flathub"; then
    local SUDO; SUDO="$(need_sudo)"
    $SUDO flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi

  log "Installing Flatpak apps"
  # shellcheck disable=SC2046
  flatpak install -y flathub $(read_list "$FLATPAK_LIST") || true

  log "Flatpak install complete"
}


main() {
  log "Bootstrap starting"
  echo "Repo: $REPO_ROOT"

  if command -v apt-get >/dev/null 2>&1; then
    install_apt
  elif command -v pacman >/dev/null 2>&1; then
    install_pacman
  else
    echo "No supported package manager detected (apt-get/pacman)."
    echo "Add support here if you need dnf/zypper/etc."
    exit 1
  fi

  install_flatpaks

  log "Bootstrap finished"
}

main "$@"
