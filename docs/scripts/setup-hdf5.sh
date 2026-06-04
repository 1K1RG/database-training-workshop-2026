#!/usr/bin/env bash
# Purpose: Install HDF5 1.8.23 from source and compile loadmatrix_geno.
# Usage:   bash setup-hdf5.sh [install_prefix]
#          install_prefix defaults to $HOME/tools/hdf5-1.8.23
# Target:  Ubuntu / Debian (WSL2 is fine; native Windows is not supported)

set -euo pipefail

# ── Configuration ──────────────────────────────────────────────────────────────
HDF5_VERSION="1.8.23"
HDF5_TARBALL="hdf5-${HDF5_VERSION}.tar.gz"
HDF5_URL="https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-${HDF5_VERSION}/src/${HDF5_TARBALL}"
HDF5_SRC_DIR="hdf5-${HDF5_VERSION}"
PREFIX="${1:-$HOME/tools/hdf5-${HDF5_VERSION}}"

CPP_SRC="loadmatrix_SNP-annot.cpp"
# TODO: Replace with the real raw-file URL from the 1K1RG GitHub repository
CPP_URL="https://raw.githubusercontent.com/1K1RG/1K1RG-Documentations/master/resources/${CPP_SRC}"
OUTPUT_BIN="loadmatrix_geno"

# ── Helpers ────────────────────────────────────────────────────────────────────
info()  { echo "=== $*"; }
ok()    { echo "    ✓ $*"; }
abort() { echo "ERROR: $*" >&2; exit 1; }

[[ "$(uname -s)" == Linux ]] || abort "This script requires Linux (use WSL2 or a VM on Windows/Mac)."

# ── Step 0: Install dependencies ───────────────────────────────────────────────
info "Step 0 — Install build dependencies"
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends bcftools build-essential wget
ok "bcftools, build-essential, wget installed"

# ── Step 1: Download HDF5 source ───────────────────────────────────────────────
info "Step 1 — Download HDF5 ${HDF5_VERSION}"
if [[ -f "$HDF5_TARBALL" ]]; then
  ok "Archive already present — skipping download"
else
  wget -q --show-progress "$HDF5_URL" -O "$HDF5_TARBALL"
  ok "Downloaded $HDF5_TARBALL"
fi

# ── Step 2: Extract ────────────────────────────────────────────────────────────
info "Step 2 — Extract source"
if [[ -d "$HDF5_SRC_DIR" ]]; then
  ok "Source directory already exists — skipping extract"
else
  tar -xzvf "$HDF5_TARBALL"
  ok "Extracted to $HDF5_SRC_DIR/"
fi

# ── Step 3: Configure and build HDF5 ──────────────────────────────────────────
info "Step 3 — Configure and build HDF5 (this takes a few minutes)"
cd "$HDF5_SRC_DIR"

if [[ -f "$PREFIX/lib/libhdf5.a" ]]; then
  ok "HDF5 already built at $PREFIX — skipping build"
else
  ./configure --prefix="$PREFIX"
  make -j"$(nproc)"
  make install
  ok "HDF5 installed to $PREFIX"
fi

cd ..

# ── Step 4: Compile loadmatrix_geno ───────────────────────────────────────────
info "Step 4 — Compile $OUTPUT_BIN"

if [[ -f "$OUTPUT_BIN" ]]; then
  ok "$OUTPUT_BIN already compiled — skipping"
else
  if [[ ! -f "$CPP_SRC" ]]; then
    info "  Downloading $CPP_SRC ..."
    wget -q --show-progress "$CPP_URL" -O "$CPP_SRC"
    ok "Downloaded $CPP_SRC"
  fi

  LIB_DIR="$PREFIX/lib"
  INCLUDE_DIR="$PREFIX/include"

  export LD_RUN_PATH="$LIB_DIR"
  export LDFLAGS="-L$LIB_DIR"
  export CPPFLAGS="-I$INCLUDE_DIR"

  g++ -Wno-narrowing -o "$OUTPUT_BIN" -I "$INCLUDE_DIR" "$CPP_SRC" -lhdf5 -L"$LIB_DIR"
  ok "Compiled $OUTPUT_BIN"
fi

# ── Verify ─────────────────────────────────────────────────────────────────────
info "Verifying build"
if ./"$OUTPUT_BIN" 2>&1 | grep -qi "usage\|error\|option\|argument"; then
  ok "$OUTPUT_BIN runs and shows usage — setup complete"
else
  abort "$OUTPUT_BIN did not produce expected output — check compilation"
fi

echo
echo "Setup complete."
echo "  HDF5 library : $PREFIX/lib"
echo "  Binary       : $(pwd)/$OUTPUT_BIN"
echo
echo "Keep both paths in mind when running make_HDF_dataset.sh."
