#!/bin/bash
set -e

echo "Running database migrations..."
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f /app/init.sql && echo "Database ready." || echo "Migration failed!"

exec hypnotoad -f app.pl
