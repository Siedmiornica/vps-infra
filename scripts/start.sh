#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NETWORK_NAME="web"

printf 'Checking Docker network %s...\n' "$NETWORK_NAME"
if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  printf 'Creating Docker network %s...\n' "$NETWORK_NAME"
  docker network create "$NETWORK_NAME"
fi

printf '\nStarting monitoring stack...\n'
(cd "$ROOT_DIR/monitoring" && docker compose up -d)

printf '\nStarting ingress stack...\n'
(cd "$ROOT_DIR" && docker compose up -d)

printf '\nAll services started successfully.\n'
printf 'Check status with: docker compose ps\n'
printf 'Check logs with: docker compose logs -f\n'
