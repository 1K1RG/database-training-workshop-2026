#!/usr/bin/env bash
# Purpose: Two-step pipeline — convert a VCF file to an HDF5 genotype matrix
#          (Step 1) and load variant metadata into the Chado database (Step 2).
# Usage:   bash pipeline_vcf_to_hdf5.sh <step1|step2|all> <input.vcf> [output_prefix]
# TODO: Replace stub commands with the real tool invocations before the training.

set -euo pipefail

STEP="${1:-all}"
VCF_IN="${2:-}"
OUT_PREFIX="${3:-output}"

DB_NAME="${PGDATABASE:-chado_training}"
DB_USER="${PGUSER:-postgres}"
LOGFILE="${OUT_PREFIX}_pipeline.log"

usage() {
  echo "Usage: $0 <step1|step2|all> <input.vcf> [output_prefix]"
  exit 1
}

[[ -z "$VCF_IN" ]] && usage

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOGFILE"; }

# ── STEP 1: Validate and normalise the VCF ────────────────────────────────
run_step1() {
  log "=== STEP 1: VCF validation and normalisation ==="

  VCF_NORM="${OUT_PREFIX}_normalised.vcf.gz"

  log "Input  : $VCF_IN"
  log "Output : $VCF_NORM"

  # TODO: Replace with actual validation tool (e.g. bcftools norm).
  log "TODO - bcftools norm -m -any -o $VCF_NORM -O z $VCF_IN"
  log "TODO - bcftools index $VCF_NORM"

  log "Step 1 placeholder complete. Replace the TODO lines above."
}

# ── STEP 2: Generate HDF5 and load Chado ─────────────────────────────────
run_step2() {
  log "=== STEP 2: HDF5 generation + Chado metadata load ==="

  VCF_NORM="${OUT_PREFIX}_normalised.vcf.gz"
  HDF5_OUT="${OUT_PREFIX}_genotypes.h5"

  log "Input  : $VCF_NORM"
  log "HDF5   : $HDF5_OUT"
  log "DB     : $DB_NAME"

  # TODO: Replace with actual VCF-to-HDF5 conversion tool.
  log "TODO - python vcf_to_hdf5.py --input $VCF_NORM --output $HDF5_OUT"

  # TODO: Replace with actual Chado metadata loader.
  log "TODO - psql -U $DB_USER -d $DB_NAME -f load_variants.sql"

  log "Step 2 placeholder complete. Replace the TODO lines above."
}

# ── MAIN ──────────────────────────────────────────────────────────────────
log "Pipeline started. Log: $LOGFILE"

case "$STEP" in
  step1) run_step1 ;;
  step2) run_step2 ;;
  all)   run_step1; run_step2 ;;
  *)     usage ;;
esac

log "Pipeline finished."
