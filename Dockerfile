FROM odoo:16.0

ARG GITHUB_USER
ARG GITHUB_REPO

ENV GITHUB_USER=${GITHUB_USER}
ENV GITHUB_REPO=${GITHUB_REPO}

USER root
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /mnt/extra-addons

RUN echo "Cloning public repo: https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git" && \
    git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git /mnt/extra-addons/your-module || (echo "Git clone failed" && exit 1)

RUN chown -R odoo:odoo /mnt/extra-addons

USER odoo
EXPOSE 8069
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
