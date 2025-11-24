#!/usr/bin/env bash
set -e

# Ensure storage directories exist with correct permissions
mkdir -p storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# Start php-fpm in background
php-fpm -D

# Replace nginx config template if you want to inject env values (not required now)
# Start nginx in foreground
nginx -g 'daemon off;'

#fixed the issue with 502 bad gateway by adding php-fpm -D command to start php-fpm in background before starting nginx