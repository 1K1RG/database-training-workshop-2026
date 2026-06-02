#!/usr/bin/env bash
# Purpose: Install PostgreSQL 16 (if not present), create the training DB,
#          restore the Chado schema dump, and verify connectivity.
# Usage:   bash setup.sh [DB_NAME] [DUMP_FILE]
# Target:  Ubuntu 22.04.1 LTS x86_64 (6.8.0-111-generic)

set -euo pipefail

DB_NAME="${1:-chado_training}"
DUMP_FILE="${2:-chado_dump.sql}"
PG_USER="${PGUSER:-postgres}"
PG_VERSION="16"

echo "=== 1k1RG Training Environment Setup ==="
echo "Database : $DB_NAME"
echo "Dump file: $DUMP_FILE"
echo "PG user  : $PG_USER"
echo

# --- Install PostgreSQL 16 if not already installed ---
echo "[0/3] Checking PostgreSQL installation ..."
if command -v psql &>/dev/null && psql --version | grep -q "PostgreSQL $PG_VERSION"; then
  echo "      PostgreSQL $PG_VERSION already installed — skipping."
else
  echo "      Installing PostgreSQL $PG_VERSION via PGDG apt repository ..."
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
  echo "      PostgreSQL $PG_VERSION installed and started."
fi
echo

# --- Create database ---
echo "[1/3] Creating database '$DB_NAME' ..."
sudo -u postgres createdb "$DB_NAME" 2>/dev/null \
  && echo "      Created." \
  || echo "      Already exists — skipping."

# --- Restore dump ---
echo "[2/3] Restoring '$DUMP_FILE' into '$DB_NAME' ..."
if [[ ! -f "$DUMP_FILE" ]]; then
  echo "ERROR: Dump file '$DUMP_FILE' not found."
  echo "       Place chado_dump.sql in the current directory and re-run."
  exit 1
fi
sudo -u postgres psql -d "$DB_NAME" -f "$DUMP_FILE"
echo "      Restore complete."

# --- Verify ---
echo "[3/3] Verifying schema ..."
sudo -u postgres psql -d "$DB_NAME" -c "\dn" | grep -q "public" \
  && echo "      Schema 'public' present — OK." \
  || echo "      WARNING: 'public' schema not found. Check restore output above."

echo
echo "Setup complete. Connect with:"
echo "  sudo -u postgres psql -d $DB_NAME"
echo "  # or, if your user has been granted access:"
echo "  psql -U $PG_USER -d $DB_NAME"
