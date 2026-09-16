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

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /build/glm-free-api /app/glm-free-api

RUN mkdir -p /app/data

ENV HOST=0.0.0.0
ENV PORT=3001

EXPOSE 3001

ENTRYPOINT ["/app/glm-free-api"]
