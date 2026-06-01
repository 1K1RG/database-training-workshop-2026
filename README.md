# Database Curation & Loading Training — 1k1RG (June 3–4, 2026)

Static materials repository for the two-day hands-on training workshop. The live site is served via GitHub Pages from the `/docs` folder.

**Live URL pattern:**
```
https://[ORG].github.io/trainingDatabase/
```
Replace `[ORG]` with the GitHub organisation or username that owns this repository.

---

## Repository layout

```
trainingDatabase/
├── docs/                  ← GitHub Pages root — everything served from here
│   ├── .nojekyll          ← Disables Jekyll so files are served verbatim (do not delete)
│   ├── index.html         ← Landing page — start here
│   ├── day1/              ← Day 1 session pages (01–10)
│   ├── day2/              ← Day 2 session pages (11–15)
│   ├── cheatsheets/       ← Printable reference cards (PDF or .md placeholders)
│   ├── scripts/           ← Shell and SQL scripts used in the labs
│   └── data/              ← Sample data files for exercises
└── README.md              ← This file (for the organizing team)
```

All participant-facing content lives inside `/docs` so GitHub Pages can serve it.
All internal links in the HTML files are **relative** (no leading `/`), which is required
for the site to work correctly under the `/<repo>/` subpath on GitHub Pages.

---

## Enabling GitHub Pages

1. Go to **Settings → Pages** in the GitHub repository.
2. Under **Source**, select **Deploy from a branch**.
3. Branch: `main`, Folder: `/docs`.
4. Click **Save**. The site will be live within ~60 seconds.
5. The URL will be shown on the same Settings → Pages screen.

> **Important — `.nojekyll`:** The file `docs/.nojekyll` disables Jekyll processing so
> every file and folder (including those starting with a digit like `01-orientation.html`)
> is served exactly as named, with no build step. **Do not delete this file.**
>
> **Important — relative links:** Every internal `href` in the HTML files uses a relative
> path (e.g. `day1/03-linux-basics.html`, `../scripts/setup.sh`). Never add a leading `/`
> to an internal link; a project Pages site lives under `/<repo>/`, not the domain root,
> so absolute-path links will 404.

---

## How to update materials

### SLIDES (replacing a session placeholder)

**Option A — PDF export (simplest):**
1. Open your slides in PowerPoint or Google Slides.
2. Export: *File → Download → PDF Document*.
3. Name the file using the session number convention, e.g., `03-linux-basics-slides.pdf`.
4. Place it in the correct folder: `docs/day1/` or `docs/day2/`.
5. Edit the session HTML page (e.g., `docs/day1/03-linux-basics.html`) — replace the
   `<div class="slide-box">` placeholder block with a link:
   ```html
   <p><a href="03-linux-basics-slides.pdf" target="_blank">📄 Open Slides (PDF)</a></p>
   ```
6. Commit and push. The PDF is served directly from GitHub Pages.

**Option B — Self-contained HTML export (allows in-browser slide playback):**
1. In Google Slides: *File → Download → Web page (.html, .zip)*.
2. Unzip and rename the folder, e.g., `03-linux-basics-slides/`.
3. Place the folder in `docs/day1/`.
4. Link from the session page to `03-linux-basics-slides/index.html`.
5. Test offline: open `docs/day1/03-linux-basics.html` locally and click the link.

**Option C — Embed a Google Slides published link:**
1. In Google Slides: *File → Share → Publish to web → Embed*.
2. Copy the `<iframe>` snippet.
3. Paste it into the session HTML page, replacing the placeholder div.
4. Note: this requires internet access during the training.

---

### HTML SESSION PAGES

Each session file is a self-contained HTML file with inline CSS — no build step needed.

1. Open the relevant file, e.g., `docs/day1/04-sql-basics.html`, in any text editor.
2. Edit the content inside the `<main>` section.
3. Save. Commit and push.

To add a speaker note or lab instruction, add them inside a `<div class="card">` block
(the styling is already defined inline in each page).

---

### CHEAT SHEETS

The cheat sheets are currently `.md` placeholder files. The download links have been
**removed from `docs/index.html`** until the PDFs are ready. To restore them:

1. Design or typeset the cheat sheet in your tool of choice (Word, Canva, InDesign, etc.)
   using the content in `docs/cheatsheets/psql-commands.md` and `docs/cheatsheets/linux-survival.md`.
2. Export as PDF.
3. Name the files exactly: `psql-commands.pdf` and `linux-survival.pdf`.
4. Place the PDFs in `docs/cheatsheets/`.
5. Add the download links back to the materials grid in `docs/index.html`:
   ```html
   <a class="material-item" href="cheatsheets/psql-commands.pdf" download>
     <div class="material-icon">🐘</div>
     <h4>psql Commands</h4>
     <span>Cheat Sheet (PDF)</span>
   </a>
   <a class="material-item" href="cheatsheets/linux-survival.pdf" download>
     <div class="material-icon">💻</div>
     <h4>Linux Survival</h4>
     <span>Cheat Sheet (PDF)</span>
   </a>
   ```
6. Commit and push.

**Printing tip:** Print double-sided, landscape, one sheet per participant. Laminate if reusing
across multiple trainings.

---

### SCRIPTS

Scripts live in `docs/scripts/` and are served directly by GitHub Pages. Each has a header
comment describing its purpose and `TODO` lines marking what needs to be replaced before use.

| File | Purpose |
|---|---|
| `setup.sh` | Environment setup for participants |
| `load_template.sql` | Bulk-loading template (`\COPY` commands) |
| `pipeline_vcf_to_hdf5.sh` | Full VCF → HDF5 pipeline wrapper |
| `vcftomatrix.sh` | Extracts genotype matrix from a VCF file |
| `make_HDF_dataset.sh` | Converts tabular matrix files to HDF5 |

1. Edit each script in `docs/scripts/` as needed.
2. Remove or replace any `TODO` placeholder lines with real commands.
3. Test locally before the training (see Pre-Training Checklist).
4. Commit and push.

**Pages download links** (participants can click these from the landing page or `wget` them):
```
https://[ORG].github.io/trainingDatabase/scripts/setup.sh
https://[ORG].github.io/trainingDatabase/scripts/load_template.sql
https://[ORG].github.io/trainingDatabase/scripts/pipeline_vcf_to_hdf5.sh
https://[ORG].github.io/trainingDatabase/scripts/vcftomatrix.sh
https://[ORG].github.io/trainingDatabase/scripts/make_HDF_dataset.sh
```

**Raw GitHub fallback** (works even if Pages is not yet enabled):
```
https://raw.githubusercontent.com/[ORG]/trainingDatabase/main/docs/scripts/setup.sh
```

---

### DATA FILES

Data files live in `docs/data/` and are served directly by GitHub Pages.

| File | Purpose |
|---|---|
| `sample_accessions.csv` | 10 placeholder rows for bulk-loading exercises |
| `chado_dump.sql` | PostgreSQL Chado database dump (used in lab 07) |
| `demo.tar.gz` | Hands-on demo archive for pipeline labs |
| `VCFv4.2.pdf` | Official VCF v4.2 format specification (reference) |

To replace `sample_accessions.csv` with real training data:
1. Prepare your CSV with the same column headers (or update the SQL template to match).
2. Overwrite `docs/data/sample_accessions.csv`.
3. Update any references in `docs/scripts/load_template.sql` (`\COPY` path).
4. Commit and push.

---

## Generating the "Download Everything" ZIP

**Option A — GitHub automatic ZIP (no extra work):**
The link in `docs/index.html` points to:
```
https://github.com/[ORG]/trainingDatabase/archive/refs/heads/main.zip
```
This always gives participants the latest state of the `main` branch as a ZIP.
Update the `[ORG]` placeholder in `docs/index.html` once.

**Option B — Tagged release ZIP (recommended for a fixed training snapshot):**
1. Once all materials are final, create a release:
   ```bash
   git tag v2026-06-training
   git push origin v2026-06-training
   ```
2. Go to GitHub → Releases → Draft a new release → select the tag.
3. Attach any extra binary files (e.g., the database dump, large PDFs) as release assets.
4. Publish. The release page has a "Source code (zip)" download.
5. Update the ZIP link in `docs/index.html` to point to the release:
   ```
   https://github.com/[ORG]/trainingDatabase/releases/download/v2026-06-training/trainingDatabase-v2026-06-training.zip
   ```

---

## File naming convention

Session pages are numbered with a two-digit prefix so they sort correctly in file browsers:

```
NN-topic-slug.html
```

- `NN` — two-digit session number (01–15, matching the schedule order).
- `topic-slug` — short lowercase kebab-case description of the session.

Do not skip numbers or reuse them. If a session is removed, leave a gap
(don't renumber the remaining files, as that would break existing links).

Slide exports and lab worksheets follow the same prefix:
```
03-linux-basics-slides.pdf
03-linux-basics-lab.pdf
```

---

## Pre-Training Checklist

Run through this 48 hours before the training.

### Site & links
- [ ] Replace `[ORG]` placeholder in `docs/index.html` (header link, ZIP link, scripts links)
- [ ] GitHub Pages is enabled and the live URL loads correctly
- [ ] All 15 session links on the index page open the correct pages
- [ ] Each session page opens standalone (no broken CSS, no external dependencies)
- [ ] ZIP download link produces a valid archive

### Content
- [ ] All slide placeholders have been replaced with real PDFs or HTML exports
- [ ] Lab worksheets are in place (or embedded in session HTML pages)
- [ ] All scripts in `docs/scripts/` have `TODO` lines replaced with real commands
- [ ] `sample_accessions.csv` contains the intended training data
- [ ] Cheat sheet PDFs added to `docs/cheatsheets/` and download links restored in `index.html`

### USB backup
- [ ] Clone or download the full repository as a ZIP
- [ ] Unzip onto the USB drive, keeping the directory structure intact
- [ ] Open `docs/index.html` from the USB in a browser — all links should work offline
- [ ] Copy the database dump file onto the USB as well
- [ ] Label the USB drives with the training name and date

### Printing
- [ ] Print cheat sheets (one per participant, double-sided landscape)
- [ ] Print lab worksheets (if not embedded in the HTML pages)
- [ ] Test that the index page is readable on a projector at 1920×1080 from 5 m away

### On the day
- [ ] Distribute USB drives at the start of Day 1
- [ ] Confirm Wi-Fi credentials are working for all participants
- [ ] Have a fallback plan if the projector resolution differs (the site is responsive)
