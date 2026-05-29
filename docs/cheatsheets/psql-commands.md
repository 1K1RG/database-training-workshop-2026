# psql Commands Cheat Sheet
## Database Curation & Loading Training — 1k1RG, June 3–4 2026

> **PLACEHOLDER — PDF not yet generated.**
> Replace this file with the printed/designed PDF before the training.
> To generate a PDF: open this file in any Markdown viewer (e.g. VS Code, Typora, Pandoc)
> and export to PDF, or use the designed PPTX/Canva version.

---

## Connecting

| Command | What it does |
|---|---|
| `psql -U postgres -d mydb` | Connect as user postgres to database mydb |
| `psql -h hostname -p 5432 -U user -d db` | Connect to remote host |
| `\q` | Quit psql |
| `\conninfo` | Show current connection info |

## Navigation meta-commands

| Command | What it does |
|---|---|
| `\l` | List all databases |
| `\dn` | List schemas |
| `\dt` | List tables in current schema |
| `\dt schema.*` | List tables in a specific schema |
| `\d tablename` | Describe table (columns, types, constraints) |
| `\di` | List indexes |
| `\dv` | List views |
| `\df` | List functions |

## Useful queries

```sql
-- Count rows
SELECT COUNT(*) FROM stock;

-- Sample rows
SELECT * FROM organism LIMIT 5;

-- Search for a term
SELECT * FROM cvterm WHERE name ILIKE '%chromosome%';

-- Show table sizes
SELECT relname, pg_size_pretty(pg_total_relation_size(oid))
FROM pg_class WHERE relkind = 'r' ORDER BY pg_total_relation_size(oid) DESC LIMIT 10;
```

## Loading data

```sql
-- Copy from CSV
\COPY mytable FROM '/path/to/file.csv' WITH (FORMAT csv, HEADER true);

-- Copy to CSV
\COPY (SELECT * FROM stock LIMIT 100) TO '/tmp/out.csv' WITH (FORMAT csv, HEADER true);
```

## Transactions

```sql
BEGIN;
-- your SQL here
ROLLBACK;   -- undo everything (safe to practise with)
-- or
COMMIT;     -- make it permanent
```

## Output formatting

| Command | What it does |
|---|---|
| `\x` | Toggle expanded (vertical) display |
| `\timing` | Show query execution time |
| `\o filename` | Send output to file |
| `\i filename` | Run SQL from file |
| `\e` | Open last query in editor |

## pg_restore (shell, not psql)

```bash
# Restore a custom-format dump
pg_restore -U postgres -d mydb --no-owner --no-privileges mydb.dump

# List contents of a dump without restoring
pg_restore -l mydb.dump
```
