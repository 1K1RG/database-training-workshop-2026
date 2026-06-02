#!/usr/bin/env bash
# Purpose: Install PostgreSQL 16 on Ubuntu 22.04.1 LTS via the official PGDG apt repository.
# Usage:   bash install-db.sh
# Target:  Ubuntu 22.04.1 LTS x86_64 (6.8.0-111-generic)

set -euo pipefail

PG_VERSION="16"

echo "=== PostgreSQL $PG_VERSION Installation ==="

if command -v psql &>/dev/null && psql --version | grep -q "PostgreSQL $PG_VERSION"; then
  echo "PostgreSQL $PG_VERSION is already installed — nothing to do."
  exit 0
fi

echo "Installing PostgreSQL $PG_VERSION via PGDG apt repository ..."
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends gnupg curl ca-certificates

# Add the official PostgreSQL apt repository
sudo install -d /usr/share/postgresql-common/pgdg
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
  | sudo gpg --dearmor -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.gpg
echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.gpg] \
https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
  | sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null

sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends postgresql-$PG_VERSION
sudo systemctl enable --now postgresql

echo
echo "PostgreSQL $PG_VERSION installed and running."
echo "Connect with:  sudo -u postgres psql"
