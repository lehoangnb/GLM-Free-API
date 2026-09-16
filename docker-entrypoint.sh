#!/bin/bash

set -e

DB="/app/data/tokens.sqlite"

TOKEN_COUNT="${TOKEN_COUNT_PER_BATCH:-850}"
TOKEN_BATCHES="${TOKEN_BATCHES:-5}"
TOKEN_PARALLEL="${TOKEN_PARALLEL:-2}"

mkdir -p /app/data

if [ -n "${ZAI_TOKEN:-}" ]; then
    echo "=============================================="
    echo "ZAI_TOKEN detected"
    echo "Using provided ZAI_TOKEN, skipping guest token collector."
    echo "=============================================="
else
    if [ ! -f "$DB" ]; then
        echo "=============================================="
        echo "No ZAI_TOKEN found and tokens.sqlite not found"
        echo "Running token collector in non-interactive mode..."
        echo "Tokens per batch: $TOKEN_COUNT"
        echo "Batches: $TOKEN_BATCHES"
        echo "Parallel workers: $TOKEN_PARALLEL"
        echo "=============================================="

        ./token-collector \
            --tokens "$TOKEN_COUNT" \
            --batch "$TOKEN_BATCHES" \
            --parallel "$TOKEN_PARALLEL" \
            --no-tui

        # collector creates database in current working directory
        if [ -f "/app/tokens.sqlite" ] && [ ! -f "$DB" ]; then
            mv /app/tokens.sqlite "$DB"
        fi

        if [ ! -f "$DB" ]; then
            echo "ERROR: token collector did not create $DB"
            exit 1
        fi
    else
        echo "Using guest tokens from existing tokens.sqlite"
    fi
fi

echo "Starting GLM-Free-API..."

exec ./glm-free-api --db-path "$DB"
