#!/bin/bash

set -e

DB="/app/data/tokens.sqlite"

if [ ! -f "$DB" ]; then
    echo "tokens.sqlite not found"
    echo "Running token collector..."

    ./token-collector

    if [ ! -f "$DB" ]; then
        echo "ERROR: token collector did not create $DB"
        exit 1
    fi
fi

echo "Starting GLM-Free-API..."

exec ./glm-free-api --db-path "$DB"
