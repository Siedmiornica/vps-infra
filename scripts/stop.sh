#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

printf 'Stopping ingress stack...\n'
(cd "$ROOT_DIR" && docker compose down)

printf '\nStopping monitoring stack...\n'
(cd "$ROOT_DIR/monitoring" && docker compose down)

printf '\nAll services stopped successfully.\n'
