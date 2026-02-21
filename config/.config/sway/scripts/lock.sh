#!/usr/bin/env bash
set -euo pipefail

# Don’t launch a second lock if one is already running
pgrep -x swaylock >/dev/null && exit 0

exec swaylock -f -C "$HOME/.config/swaylock/config"