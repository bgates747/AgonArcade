#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.emulator"
exec ./fab-agon-emulator "$@"
