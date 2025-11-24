# Dockerfile (Render single-container: nginx + php-fpm)
FROM php:8.2-fpm

# Install system packages + php extensions
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nginx curl git unzip libpng-dev libonig-dev libxml2-dev zip libzip-dev \
    ca-certificates procps \
 && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions
RUN docker-php-ext-configure zip --with-libzip \
 && docker-php-ext-install -j$(nproc) pdo pdo_mysql mbstring zip bcmath exif

# Copy composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy composer metadata to use cache
COPY composer.json composer.lock ./

# Install PHP deps (fail build if something wrong)
RUN composer install --no-dev --prefer-dist --no-interaction --no-ansi --no-progress --optimize-autoloader

# Copy app files
COPY . .

# Ensure permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy nginx config template and entrypoint (added below)
COPY docker/nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker/render-entrypoint.sh /usr/local/bin/render-entrypoint.sh
RUN chmod +x /usr/local/bin/render-entrypoint.sh

EXPOSE 80

# Start php-fpm and nginx via entrypoint
CMD ["/usr/local/bin/render-entrypoint.sh"]
