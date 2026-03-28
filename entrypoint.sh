#!/bin/bash
set -e

echo "Running database migrations..."
psql "$DATABASE_URL" -f /app/init.sql
echo "Database ready."

exec hypnotoad -f app.pl
