FROM odoo:17.0

USER root
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Create directory for extra addons
RUN mkdir -p /mnt/extra-addons

# Build arguments (optional for private repos)
ARG GITHUB_USER
ARG GITHUB_TOKEN
ARG GITHUB_REPO

# Clone logic: use token if provided, otherwise public clone
RUN if [ -n "$GITHUB_USER" ] && [ -n "$GITHUB_TOKEN" ]; then \
        echo "Cloning private repo with authentication..." && \
        git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${GITHUB_REPO}.git /mnt/extra-addons/your-module; \
    else \
        echo "Cloning public repo..." && \
        git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git /mnt/extra-addons/your-module; \
    fi

# Copy Odoo config if you have one
COPY ./odoo.conf /etc/odoo/odoo.conf

# Fix permissions
RUN chown -R odoo:odoo /mnt/extra-addons && chmod -R 755 /mnt/extra-addons

USER odoo
EXPOSE 8069
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
