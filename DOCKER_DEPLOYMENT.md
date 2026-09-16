# Docker Deployment

## Docker Compose (Recommended)

```bash
git clone https://github.com/lehoangnb/GLM-Free-API.git
cd GLM-Free-API
```

Create `.env`:

```env
AUTH_TOKEN=my-secret-token
ZAI_TOKEN=
PORT=3001
```

Start:

```bash
docker compose up -d --build
```

Check logs:

```bash
docker logs -f glm-free-api
```

## Run from GHCR

```bash
docker pull ghcr.io/lehoangnb/glm-free-api:latest
```

```bash
docker run -d \
  --name glm-free-api \
  -p 3001:3001 \
  -e AUTH_TOKEN=my-secret-token \
  -e ZAI_TOKEN="" \
  -v ./data:/app/data \
  ghcr.io/lehoangnb/glm-free-api:latest
```

## Persistent Data

Mount `/app/data` to keep the SQLite token database:

```bash
-v ./data:/app/data
```

## Test

Health:

```bash
curl http://localhost:3001/health
```

Models:

```bash
curl http://localhost:3001/v1/models \
-H "Authorization: Bearer my-secret-token"
```

Chat:

```bash
curl http://localhost:3001/v1/chat/completions \
-H "Content-Type: application/json" \
-H "Authorization: Bearer my-secret-token" \
-d '{"model":"glm-4.7","messages":[{"role":"user","content":"Hello"}]}'
```
