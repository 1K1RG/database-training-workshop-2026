#!/usr/bin/env bash
# Purpose: Create the training database and restore the Chado schema from a SQL dump.
# Usage:   bash restore.sh [DB_NAME] [DUMP_FILE]
# Requires: PostgreSQL already installed (run install-db.sh first if needed)

set -euo pipefail

DB_NAME="${1:-chado_training}"
DUMP_FILE="${2:-chado_dump.sql}"

echo "=== Chado Training Database Restore ==="
echo "Database : $DB_NAME"
echo "Dump file: $DUMP_FILE"
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
echo "Restore complete. Connect with:"
echo "  sudo -u postgres psql -d $DB_NAME"
