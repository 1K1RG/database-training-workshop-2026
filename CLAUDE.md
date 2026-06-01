# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A static-site materials repository for the **1k1RG Database Curation & Loading Training** (June 3–4, 2026, IRRI Los Baños). There is no build step — all files are served verbatim by GitHub Pages from the `/docs` folder.

Topics covered: SNP-Seek / Chado / HDF5 / brAPI, PostgreSQL, Linux bioinformatics, VCF→HDF5 pipeline, bulk data loading.

## Serving the site locally

Open `docs/index.html` directly in a browser. All internal links are relative, so the full site works offline with no server needed. Google Fonts (`Inter`) requires internet; the page falls back to system fonts automatically.

## Editing content

**Session pages** (`docs/day1/NN-*.html`, `docs/day2/NN-*.html`): self-contained HTML with inline CSS — edit the `<main>` section. Add content inside `<div class="card">` blocks.

**Landing page** (`docs/index.html`): the schedule table, download links, and sidebar are all in this single file. The `[ORG]` placeholder in the ZIP download link and footer GitHub URL must be replaced with the actual GitHub org/username before going live.

**Scripts** (`docs/scripts/`): `setup.sh`, `load_template.sql`, `pipeline_vcf_to_hdf5.sh` — each has `TODO` comments marking lines that need real commands before training.

**Cheat sheets** (`docs/cheatsheets/`): currently `.md` placeholders; replace with PDFs named exactly `psql-commands.pdf` and `linux-survival.pdf` — `docs/index.html` already links to these names.

**Data** (`docs/data/sample_accessions.csv`): 10 placeholder rows; overwrite with real training data keeping the same column headers, or update `load_template.sql`'s `\COPY` path to match.

## Critical constraints

- **Do not delete `docs/.nojekyll`** — it prevents Jekyll from processing the site, which is required for filenames starting with digits (e.g. `01-orientation.html`) to be served correctly.
- **All internal `href` values must be relative** (e.g. `day1/03-linux-basics.html`, `../scripts/setup.sh`). Never add a leading `/`. GitHub Pages serves the site under `/<repo>/`, not the domain root, so absolute paths 404.
- **Session numbering is permanent** — never renumber files once published; leave gaps if a session is removed. Slide exports follow the same prefix: `NN-topic-slug-slides.pdf`.

## GitHub Pages setup

Settings → Pages → Branch: `main`, Folder: `/docs`. The live URL follows the pattern `https://[ORG].github.io/trainingDatabase/`.

For a fixed training snapshot, tag the repo (`git tag v2026-06-training`) and create a GitHub Release so the ZIP link can point to the release asset rather than the rolling `main` branch.
