FROM debian:bullseye

EXPOSE 80

RUN apt-get update && \
    apt-get install -y --no-install-recommends apache2 php php-mysql wget && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f /var/www/html/index.html

COPY --chmod=644 index.php /var/www/html/index.php

CMD ["apachectl", "-D", "FOREGROUND"]

