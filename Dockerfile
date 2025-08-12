# Use official Odoo base image
FROM odoo:16.0

# Set build arguments for GitHub credentials
ARG GITHUB_USER
ARG GITHUB_TOKEN
ARG GITHUB_REPO

# Make sure the args are available as env variables
ENV GITHUB_USER=${GITHUB_USER}
ENV GITHUB_TOKEN=${GITHUB_TOKEN}
ENV GITHUB_REPO=${GITHUB_REPO}

# Install git
USER root
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Create addons directory
RUN mkdir -p /mnt/extra-addons

# Clone repo (private or public depending on whether token is provided)
RUN if [ -n "$GITHUB_USER" ] && [ -n "$GITHUB_TOKEN" ]; then \
      echo "Cloning private repo with authentication..." && \
      git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${GITHUB_REPO}.git /mnt/extra-addons/your-module; \
    else \
      echo "Cloning public repo..." && \
      git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git /mnt/extra-addons/your-module; \
    fi

# Set permissions
RUN chown -R odoo:odoo /mnt/extra-addons

# Switch back to Odoo user
USER odoo
