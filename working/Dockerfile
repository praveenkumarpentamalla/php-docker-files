# Use a lightweight PHP CLI image
FROM php:8.2-cli

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    redis-server \
    supervisor \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    zip \
    gd \
    bcmath \
    exif \
    mbstring \
    xml

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy application files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Install Node.js dependencies for socket-server
WORKDIR /var/www/html/socket-server
RUN npm install --production

# Set proper permissions
WORKDIR /var/www/html
RUN chmod -R 755 storage bootstrap/cache


# Create supervisor configuration directory
RUN mkdir -p /etc/supervisor/conf.d

# Copy supervisor configuration (try both locations)
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN ln -sf /etc/supervisor/supervisord.conf /etc/supervisord.conf

# Or alternatively, copy to the traditional location:
# COPY supervisord.conf /etc/supervisord.conf

# Expose ports
EXPOSE 8000 3001 6379

# Start all services using supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
