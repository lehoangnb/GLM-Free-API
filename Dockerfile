FROM golang:1.25-bookworm AS builder

WORKDIR /build

COPY . .

RUN if [ ! -f go.mod ]; then \
        go mod init zai-api; \
    fi \
    && go mod tidy

RUN CGO_ENABLED=0 \
    go build \
    -trimpath \
    -gcflags="all=-l=4" \
    -ldflags="-s -w" \
    -o glm-free-api .

RUN CGO_ENABLED=0 \
    go build \
    -trimpath \
    -ldflags="-s -w" \
    -o token-collector ./cmd/token-collector

FROM mcr.microsoft.com/playwright:v1.55.0-jammy

WORKDIR /app

COPY --from=builder /build/glm-free-api /app/glm-free-api
COPY --from=builder /build/token-collector /app/token-collector
COPY docker-entrypoint.sh /app/docker-entrypoint.sh

RUN chmod +x /app/docker-entrypoint.sh \
    && mkdir -p /app/data

ENV HOST=0.0.0.0
ENV PORT=3001

EXPOSE 3001

ENTRYPOINT ["/app/docker-entrypoint.sh"]
