# Use official Odoo image
FROM odoo:17.0

# Set environment variables
ENV ODOO_RC=/etc/odoo/odoo.conf

# Create addons directory
RUN mkdir -p /mnt/extra-addons

# Copy your custom module from local folder to container
COPY ./your-module /mnt/extra-addons/your-module

# Copy Odoo configuration file
COPY ./odoo.conf /etc/odoo/odoo.conf

# Set permissions
RUN chown -R odoo:odoo /mnt/extra-addons && \
    chown odoo:odoo /etc/odoo/odoo.conf

# Expose default Odoo port
EXPOSE 8069

# Start Odoo
USER odoo
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
