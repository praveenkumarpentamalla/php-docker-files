FROM php:8.2-cli

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    default-mysql-client \
    netcat-openbsd \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    # Install Redis extension
    && pecl install redis \
    && docker-php-ext-enable redis

RUN echo "memory_limit = 2G" > /usr/local/etc/php/conf.d/memory-limit.ini

COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

COPY . .

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER www-data

EXPOSE 8000

ENTRYPOINT ["docker-entrypoint.sh"]
