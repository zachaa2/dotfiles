#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCK="$SCRIPT_DIR/lock.sh"

pkill -x swayidle 2>/dev/null || true

exec swayidle -w \
  timeout 300 "$LOCK" \
  before-sleep "$LOCK"