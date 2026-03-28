FROM perl:5.36-slim

WORKDIR /app

# Install system dependencies for PostgreSQL driver
RUN apt-get update && apt-get install -y \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Perl dependencies
COPY cpanfile .
RUN cpanm --notest --installdeps .

# Copy application files to the locations hypnotoad expects
COPY backend/app.pl .
COPY backend/templates ./templates
COPY public ./public

EXPOSE 8080

CMD ["hypnotoad", "-f", "app.pl"]
