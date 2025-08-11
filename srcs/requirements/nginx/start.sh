#!/bin/bash

chown -R www-data:www-data /var/www/inception
chmod -R 755 /var/www/inception

exec nginx -g "daemon off;"
