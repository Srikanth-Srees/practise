# Dockerfile (fixed: installs libzip-dev and avoids unsupported configure flag)
FROM php:8.2-fpm

# Install system packages + libraries required for PHP extensions
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nginx curl git unzip libpng-dev libonig-dev libxml2-dev zip libzip-dev \
    libpq-dev ca-certificates procps \
 && rm -rf /var/lib/apt/lists/*

# Install PHP extensions (no separate configure for zip)
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql pdo_pgsql pgsql mbstring zip bcmath exif

# Copy composer binary from official Composer image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy composer files for caching
COPY composer.json composer.lock ./

# Install PHP dependencies but skip composer scripts (artisan not present yet)
RUN composer install --no-dev --prefer-dist --no-interaction --no-ansi --no-progress --no-scripts

# Copy application code
COPY . .

# Now run optimized dump-autoload and package discovery
RUN composer dump-autoload --optimize \
 && php artisan package:discover --ansi || true

# Fix permissions for Laravel writable folders
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy nginx config template and entrypoint for single container
COPY docker/nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker/render-entrypoint.sh /usr/local/bin/render-entrypoint.sh
RUN chmod +x /usr/local/bin/render-entrypoint.sh

EXPOSE 80

CMD ["/usr/local/bin/render-entrypoint.sh"]
