#!/usr/bin/env bash
set -e

# Create missing framework subdirs at runtime too
mkdir -p /var/www/html/storage/framework/{cache,sessions,views} \
         /var/www/html/storage/logs \
         /var/www/html/storage/app \
         /var/www/html/bootstrap/cache

chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

php-fpm -D

# Wait for PHP-FPM socket
sleep 3

# Clear Laravel caches
su www-data -s /bin/bash -c "cd /var/www/html && php artisan cache:clear config:clear view:clear route:clear 2>/dev/null || true"

nginx -g 'daemon off;'
