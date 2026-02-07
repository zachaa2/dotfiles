#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# remove the stowed links (update as needed)
stow -D zsh 2>/dev/null || true
stow -D git 2>/dev/null || true
stow -D config 2>/dev/null || true
