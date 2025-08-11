# Start from official Debian base
FROM debian:bullseye

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    node-less \
    npm \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PostgreSQL client (for testing/psql, optional)
RUN apt-get update && apt-get install -y postgresql-client

# Create odoo user
RUN useradd -m -d /opt/odoo -U -r -s /bin/bash odoo

# Switch to odoo user and clone Odoo 16 Community Edition
USER odoo
WORKDIR /opt/odoo
RUN git clone --branch 16.0 --depth 1 https://github.com/odoo/odoo.git .

# Install Python dependencies
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install -r requirements.txt

# Expose port 8069
EXPOSE 8069

# Environment variables for DB connection, to be set in Render or Docker run:
ENV DB_HOST=postgres
ENV DB_PORT=5432
ENV DB_USER=odoo
ENV DB_PASSWORD=odoo
ENV DB_NAME=postgres
ENV ODOO_CONFIG=/etc/odoo/odoo.conf

# Copy custom config file (optional)
# USER root
# COPY ./odoo.conf /etc/odoo/odoo.conf
# USER odoo

# Start Odoo server
CMD ["python3", "/opt/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]
