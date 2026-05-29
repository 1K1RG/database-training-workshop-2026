#!/usr/bin/env bash
# Purpose: Prepare the training environment — create the PostgreSQL training DB,
#          restore the Chado schema dump, and verify connectivity.
# Usage:   bash setup.sh [DB_NAME] [DUMP_FILE]
# TODO: Replace with the real setup script before the training.

set -euo pipefail

DB_NAME="${1:-chado_training}"
DUMP_FILE="${2:-chado_training.dump}"
PG_USER="${PGUSER:-postgres}"

echo "=== 1k1RG Training Environment Setup ==="
echo "Database : $DB_NAME"
echo "Dump file: $DUMP_FILE"
echo "PG user  : $PG_USER"
echo

# --- Create database ---
echo "[1/3] Creating database '$DB_NAME' ..."
createdb -U "$PG_USER" "$DB_NAME" 2>/dev/null \
  && echo "      Created." \
  || echo "      Already exists — skipping."

# --- Restore dump ---
echo "[2/3] Restoring '$DUMP_FILE' into '$DB_NAME' ..."
if [[ ! -f "$DUMP_FILE" ]]; then
  echo "ERROR: Dump file '$DUMP_FILE' not found."
  echo "       Place the .dump file in the current directory and re-run."
  exit 1
fi
pg_restore -U "$PG_USER" -d "$DB_NAME" --no-owner --no-privileges "$DUMP_FILE"
echo "      Restore complete."

# --- Verify ---
echo "[3/3] Verifying schema ..."
psql -U "$PG_USER" -d "$DB_NAME" -c "\dn" | grep -q "public" \
  && echo "      Schema 'public' present — OK." \
  || echo "      WARNING: 'public' schema not found. Check restore output above."

echo
echo "Setup complete. Connect with:"
echo "  psql -U $PG_USER -d $DB_NAME"
