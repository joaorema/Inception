FROM debian:bullseye

EXPOSE 443

RUN apt update && apt install -y --no-install-recommends nginx && \
    rm -rf /var/lib/apt/lists/*

COPY certs/certificate.crt /etc/nginx/certs/certificate.crt
COPY certs/certificate.key /etc/nginx/certs/certificate.key
COPY conf/nginx.conf /etc/nginx/
COPY conf/server.conf /etc/nginx/conf.d/

# Copy the inception files if you want to build them in (optional)
# COPY inception /var/www/inception

# Copy the entrypoint script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]



