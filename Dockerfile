# Dockerfile (fixed: ensures storage & bootstrap/cache exist before chown)
FROM php:8.2-fpm

# Install system packages + libraries required for PHP extensions
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nginx curl git unzip libpng-dev libonig-dev libxml2-dev zip libzip-dev \
    libpq-dev ca-certificates procps \
 && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql pdo_pgsql pgsql mbstring zip bcmath exif

# Copy composer binary from official composer image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy composer files for cache
COPY composer.json composer.lock ./

# Install PHP deps but skip scripts (artisan not present yet)
RUN composer install --no-dev --prefer-dist --no-interaction --no-ansi --no-progress --no-scripts

# Copy full application code
COPY . .

# Ensure required writable directories exist and set correct ownership
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
 && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Run optimized autoload and package discovery now that app & vendor exist
RUN composer dump-autoload --optimize \
 && php artisan package:discover --ansi || true

# Copy nginx config template and entrypoint
COPY docker/nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker/render-entrypoint.sh /usr/local/bin/render-entrypoint.sh
RUN chmod +x /usr/local/bin/render-entrypoint.sh

EXPOSE 80

CMD ["/usr/local/bin/render-entrypoint.sh"]
