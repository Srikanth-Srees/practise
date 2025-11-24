# Dockerfile (fixed ordering)
FROM php:8.2-fpm

# Install system packages + php extensions
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nginx curl git unzip libpng-dev libonig-dev libxml2-dev zip libzip-dev \
    ca-certificates procps \
 && rm -rf /var/lib/apt/lists/*

# Configure & install PHP extensions
RUN docker-php-ext-configure zip --with-libzip \
 && docker-php-ext-install -j$(nproc) pdo pdo_mysql mbstring zip bcmath exif

# Copy composer binary
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# 1) copy composer files for cache layer
COPY composer.json composer.lock ./

# 2) install PHP deps but SKIP composer scripts (avoids calling artisan before app exists)
RUN composer install --no-dev --prefer-dist --no-interaction --no-ansi --no-progress --no-scripts

# 3) copy full application source
COPY . .

# 4) run dump-autoload and then run package discovery with artisan (now artisan & vendor exist)
RUN composer dump-autoload --optimize \
 && php artisan package:discover --ansi || true

# ensure permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy nginx config template and entrypoint
COPY docker/nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker/render-entrypoint.sh /usr/local/bin/render-entrypoint.sh
RUN chmod +x /usr/local/bin/render-entrypoint.sh

EXPOSE 80

CMD ["/usr/local/bin/render-entrypoint.sh"]
