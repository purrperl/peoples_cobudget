FROM perl:5.36-slim

WORKDIR /app


# Install system dependencies for PostgreSQL driver and psql client
RUN apt-get update && apt-get install -y \
    libpq-dev \
    build-essential \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Perl dependencies
COPY cpanfile .
RUN cpanm --notest --installdeps .

# Copy application files
COPY backend/app.pl .
COPY backend/templates ./templates
COPY public ./public

# Copy DB init script and entrypoint
COPY db/init.sql .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 80

ENTRYPOINT ["./entrypoint.sh"]
