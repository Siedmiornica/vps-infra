#!/usr/bin/env bash
set -euo pipefail

TARGET_GIB="${1:-20}"
RESERVE_GIB=5
FILL_FILE="/var/tmp/vps-disk-fill-test.bin"

if [[ ! "$TARGET_GIB" =~ ^[1-9][0-9]*$ ]]; then
  echo "Usage: bash scripts/fill-disk-test.sh [target_GiB]" >&2
  exit 2
fi

if ! command -v fallocate >/dev/null 2>&1; then
  echo "Error: fallocate is not installed (Debian package: util-linux)." >&2
  exit 1
fi

if [[ -e "$FILL_FILE" ]]; then
  echo "Error: $FILL_FILE already exists; remove it or inspect it first." >&2
  exit 1
fi

read -r USED_BYTES AVAILABLE_BYTES < <(
  df -B1 --output=used,avail / | awk 'NR == 2 { print $1, $2 }'
)

TARGET_BYTES=$((TARGET_GIB * 1024 * 1024 * 1024))
RESERVE_BYTES=$((RESERVE_GIB * 1024 * 1024 * 1024))

if (( USED_BYTES >= TARGET_BYTES )); then
  echo "Root filesystem already uses at least ${TARGET_GIB} GiB; nothing to allocate."
  df -h /
  exit 0
fi

ALLOCATE_BYTES=$((TARGET_BYTES - USED_BYTES))
MAX_ALLOCATE_BYTES=$((AVAILABLE_BYTES - RESERVE_BYTES))

if (( MAX_ALLOCATE_BYTES <= 0 || ALLOCATE_BYTES > MAX_ALLOCATE_BYTES )); then
  echo "Error: cannot reach ${TARGET_GIB} GiB while preserving ${RESERVE_GIB} GiB free." >&2
  echo "No file was created. Current root filesystem usage:" >&2
  df -h / >&2
  exit 1
fi

printf 'Allocating approximately %s GiB at %s...\n' "$TARGET_GIB" "$FILL_FILE"
fallocate -l "$ALLOCATE_BYTES" "$FILL_FILE"
sync

echo "Done. Current root filesystem usage:"
df -h /
echo "Remove the test file to reclaim space: rm -- '$FILL_FILE'"
