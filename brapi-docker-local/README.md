# brapi-docker-local

A lightweight BrAPI v2 server that connects to your local PostgreSQL (Chado) database and exposes germplasm data over HTTP.

## Prerequisites

- Docker + Docker Compose v2
- A running local PostgreSQL instance with a Chado schema loaded

## Setup

**1. Copy the env template and fill in your credentials:**

```bash
cp .env.example .env
```

Edit `.env`:

```
DB_HOST=host.docker.internal   # resolves to your host machine from inside Docker
DB_PORT=5432
DB_NAME=your_database_name
DB_USER=your_db_user
DB_PASSWORD=your_db_password
SERVER_PORT=8080
```

**2. Build and start the container:**

```bash
docker compose up -d --build
```

**3. Confirm the container is healthy:**

```bash
docker compose ps
```

---

## Testing

**Server info (smoke test):**

```bash
curl -s http://localhost:8080/brapi/v2/serverinfo | jq .
```

**List all germplasm:**

```bash
curl -s "http://localhost:8080/brapi/v2/germplasm" | jq .
```

**Filter by name (partial match):**

```bash
curl -s "http://localhost:8080/brapi/v2/germplasm?germplasmName=IR" | jq .
```

**Paginate (page 1, 50 records per page):**

```bash
curl -s "http://localhost:8080/brapi/v2/germplasm?page=1&pageSize=50" | jq .
```

**Fetch a single germplasm by ID:**

```bash
curl -s "http://localhost:8080/brapi/v2/germplasm/1" | jq .
```

---

## Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/brapi/v2/serverinfo` | Server metadata and available calls |
| GET | `/brapi/v2/germplasm` | List all germplasm (supports `germplasmName`, `accessionNumber`, `page`, `pageSize`) |
| GET | `/brapi/v2/germplasm/:id` | Fetch a single germplasm by `stock_id` |

---

## Stopping

```bash
docker compose down
```

---

## How it works

The server queries the Chado `stock` table joined to `organism` to produce BrAPI v2-compliant germplasm responses. The `host.docker.internal` hostname is mapped to your host machine's gateway via `extra_hosts` in `docker-compose.yml`, so the container can reach your local PostgreSQL without any port forwarding configuration.
