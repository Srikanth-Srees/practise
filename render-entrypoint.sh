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
