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

# Install Node.js for socket-server
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Copy application files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Install socket-server dependencies
WORKDIR /var/www/html/socket-server
RUN npm install --production

# Set proper permissions
WORKDIR /var/www/html
RUN chmod -R 755 storage bootstrap/cache

# Expose ports
EXPOSE 8000 3001

# Start both services using a process manager
CMD ["sh", "-c", "composer run-script post-autoload-dump && \
     (php artisan serve --host=0.0.0.0 --port=8000 &) && \
     (cd socket-server && npm start)"]
