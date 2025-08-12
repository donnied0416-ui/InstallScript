FROM odoo:16.0

# Install extra dependencies (if needed)
USER root
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/odoo

# Add ~/.local/bin to PATH to avoid warnings
ENV PATH="/opt/odoo/.local/bin:${PATH}"

# Clone your custom modules into a separate folder
RUN mkdir -p /mnt/extra-addons && \
    git clone https://github.com/your-repo/your-module.git /mnt/extra-addons/your-module

# Install Python dependencies for your custom modules
RUN pip install --no-cache-dir --user \
    pyserial \
    Babel \
    qrcode \
    libsass \
    ics

# Ensure Odoo owns its folders
RUN chown -R odoo:odoo /mnt/extra-addons /opt/odoo

# Switch back to Odoo user
USER odoo

# Launch Odoo with your custom addons path
CMD ["odoo", "--addons-path=/mnt/extra-addons,/usr/lib/python3/dist-packages/odoo/addons"]
