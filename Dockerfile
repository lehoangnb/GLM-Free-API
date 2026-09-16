FROM golang:1.24-alpine AS builder

WORKDIR /app
COPY . .

RUN go mod init zai-api \
    && go mod tidy \
    && go build -trimpath -gcflags="all=-l=4" -ldflags="-s -w" -o glm-free-api .

FROM alpine:3.22

WORKDIR /app

COPY --from=builder /app/glm-free-api /app/glm-free-api

RUN mkdir -p /app/data

ENV HOST=0.0.0.0
ENV PORT=3001
ENV AUTH_TOKEN=Waguri

EXPOSE 3001

ENTRYPOINT ["/app/glm-free-api"]
