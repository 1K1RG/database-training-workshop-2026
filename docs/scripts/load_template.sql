-- Purpose: Template script for bulk-loading accession data into the Chado training database.
-- Usage:   psql -U postgres -d chado_training -f load_template.sql
-- TODO: Replace column mappings and file path with real data before running.

BEGIN;

-- ── 1. Ensure the organism exists ──────────────────────────────────────────
INSERT INTO organism (abbreviation, genus, species, common_name)
VALUES ('O.sat', 'Oryza', 'sativa', 'Rice')
ON CONFLICT (genus, species) DO NOTHING;

-- ── 2. Load accession records from CSV via a staging table ─────────────────
CREATE TEMP TABLE stage_accessions (
    accession_id    TEXT,
    variety_name    TEXT,
    country_origin  TEXT,
    subpopulation   TEXT,
    latitude        NUMERIC,
    longitude       NUMERIC
);

-- TODO: Update the file path below to the actual CSV location on the server.
\COPY stage_accessions (accession_id, variety_name, country_origin, subpopulation, latitude, longitude)
FROM '/path/to/sample_accessions.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

-- ── 3. Insert into the stock table ─────────────────────────────────────────
INSERT INTO stock (organism_id, name, uniquename, type_id)
SELECT
    o.organism_id,
    s.variety_name,
    s.accession_id,
    cv.cvterm_id       -- cvterm for 'accession' — adjust cv name if needed
FROM stage_accessions s
CROSS JOIN organism o
JOIN cvterm cv ON cv.name = 'accession'
JOIN cv ON cv.cv_id = cv.cv_id AND cv.name = 'local'   -- TODO: verify cv name
WHERE o.genus = 'Oryza' AND o.species = 'sativa'
ON CONFLICT (organism_id, uniquename, type_id) DO NOTHING;

-- ── 4. Quick sanity check ──────────────────────────────────────────────────
SELECT COUNT(*) AS loaded_accessions FROM stock
JOIN organism USING (organism_id)
WHERE organism.genus = 'Oryza';

COMMIT;

-- TODO: Add stockprop inserts for country_origin, subpopulation, coordinates.
-- TODO: Wrap in a transaction with explicit ROLLBACK on error for production.
