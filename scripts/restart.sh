#!/usr/bin/env bash
set -e
cd ~/apps/infrastructure && docker compose down
cd monitoring && docker compose down && docker compose up -d
cd .. && docker compose up -d