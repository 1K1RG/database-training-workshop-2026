'use strict';

const express = require('express');
const { Pool } = require('pg');

const app  = express();
const PORT = parseInt(process.env.SERVER_PORT) || 8080;

// ── Database connection pool ─────────────────────────────────────────────────
const pool = new Pool({
  host:     process.env.DB_HOST     || 'host.docker.internal',
  port:     parseInt(process.env.DB_PORT) || 5432,
  database: process.env.DB_NAME,
  user:     process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,
});

pool.on('error', (err) => {
  console.error('Unexpected database pool error:', err.message);
});

// ── BrAPI v2 response envelope ───────────────────────────────────────────────
function envelope(data, totalCount, page, pageSize) {
  return {
    '@context': ['https://brapi.org/jsonld/context/metadata.jsonld'],
    metadata: {
      datafiles: [],
      pagination: {
        currentPage:  page,
        pageSize:     pageSize,
        totalCount:   totalCount,
        totalPages:   Math.ceil(totalCount / pageSize),
      },
      status: [{ message: 'Request accepted, response successful', messageType: 'INFO' }],
    },
    result: { data },
  };
}

function errorResponse(message, code = 500) {
  return {
    metadata: {
      status: [{ message, messageType: 'ERROR' }],
    },
  };
}

// ── Routes ───────────────────────────────────────────────────────────────────

// GET /brapi/v2/serverinfo
app.get('/brapi/v2/serverinfo', (_req, res) => {
  res.json({
    metadata: { status: [{ message: 'OK', messageType: 'INFO' }] },
    result: {
      organizationName:   '1k1RG Project',
      serverName:         'BrAPI Local Server',
      serverDescription:  'Lightweight BrAPI v2 proxy for local Chado/PostgreSQL database',
      contactEmail:       '',
      calls: [
        { service: '/serverinfo', dataTypes: ['application/json'], methods: ['GET'], versions: ['2.0'] },
        { service: '/germplasm',  dataTypes: ['application/json'], methods: ['GET'], versions: ['2.0'] },
      ],
    },
  });
});

// GET /brapi/v2/germplasm
app.get('/brapi/v2/germplasm', async (req, res) => {
  const page     = Math.max(parseInt(req.query.page)     || 0, 0);
  const pageSize = Math.min(parseInt(req.query.pageSize) || 1000, 10000);
  const offset   = page * pageSize;

  // Optional filters
  const germplasmName  = req.query.germplasmName  || null;
  const accessionNumber = req.query.accessionNumber || null;

  const whereClauses = [];
  const params = [];

  if (germplasmName) {
    params.push(`%${germplasmName}%`);
    whereClauses.push(`s.name ILIKE $${params.length}`);
  }
  if (accessionNumber) {
    params.push(accessionNumber);
    whereClauses.push(`s.uniquename = $${params.length}`);
  }

  const whereSQL = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';

  try {
    const countResult = await pool.query(
      `SELECT COUNT(*)
         FROM stock s
         JOIN organism o ON s.organism_id = o.organism_id
         ${whereSQL}`,
      params
    );
    const totalCount = parseInt(countResult.rows[0].count);

    const dataParams = [...params, pageSize, offset];
    const result = await pool.query(
      `SELECT
         s.stock_id::text            AS "germplasmDbId",
         s.name                      AS "germplasmName",
         s.uniquename                AS "accessionNumber",
         o.genus                     AS "genus",
         o.species                   AS "species",
         COALESCE(s.description, '') AS "germplasmPUI"
       FROM stock s
       JOIN organism o ON s.organism_id = o.organism_id
       ${whereSQL}
       ORDER BY s.name
       LIMIT $${dataParams.length - 1} OFFSET $${dataParams.length}`,
      dataParams
    );

    const data = result.rows.map(row => ({
      germplasmDbId:      row.germplasmDbId,
      germplasmName:      row.germplasmName,
      accessionNumber:    row.accessionNumber,
      defaultDisplayName: row.germplasmName,
      genus:              row.genus,
      species:            row.species,
      germplasmPUI:       row.germplasmPUI,
      synonyms:           [],
      taxonIds:           [],
    }));

    res.json(envelope(data, totalCount, page, pageSize));
  } catch (err) {
    console.error('/germplasm error:', err.message);
    res.status(500).json(errorResponse(err.message));
  }
});

// GET /brapi/v2/germplasm/:germplasmDbId
app.get('/brapi/v2/germplasm/:germplasmDbId', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT
         s.stock_id::text            AS "germplasmDbId",
         s.name                      AS "germplasmName",
         s.uniquename                AS "accessionNumber",
         o.genus                     AS "genus",
         o.species                   AS "species",
         COALESCE(s.description, '') AS "germplasmPUI"
       FROM stock s
       JOIN organism o ON s.organism_id = o.organism_id
       WHERE s.stock_id = $1`,
      [req.params.germplasmDbId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json(errorResponse('Germplasm not found', 404));
    }

    const row = result.rows[0];
    res.json({
      metadata: { status: [{ message: 'OK', messageType: 'INFO' }] },
      result: {
        germplasmDbId:      row.germplasmDbId,
        germplasmName:      row.germplasmName,
        accessionNumber:    row.accessionNumber,
        defaultDisplayName: row.germplasmName,
        genus:              row.genus,
        species:            row.species,
        germplasmPUI:       row.germplasmPUI,
        synonyms:           [],
        taxonIds:           [],
      },
    });
  } catch (err) {
    console.error('/germplasm/:id error:', err.message);
    res.status(500).json(errorResponse(err.message));
  }
});

// ── Start ────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`BrAPI v2 server running on port ${PORT}`);
  console.log(`  DB host: ${process.env.DB_HOST || 'host.docker.internal'}:${process.env.DB_PORT || 5432}`);
  console.log(`  DB name: ${process.env.DB_NAME}`);
});
