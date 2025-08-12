FROM odoo:17.0

# Install git inside the container
USER root
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Create directory for extra addons
RUN mkdir -p /mnt/extra-addons

# Clone your GitHub module (replace URL with your real repo)
RUN git clone https://<USERNAME>:<TOKEN>@github.com/<USERNAME>/<REPO>.git /mnt/extra-addons/your-module

# Copy Odoo config if you have one
COPY ./odoo.conf /etc/odoo/odoo.conf

# Set permissions
RUN chown -R odoo:odoo /mnt/extra-addons && chmod -R 755 /mnt/extra-addons

# Switch to odoo user
USER odoo

# Expose Odoo port
EXPOSE 8069

# Start Odoo
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
