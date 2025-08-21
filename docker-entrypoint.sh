#!/bin/sh
set -e

echo "Installing Composer dependencies..."
if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-interaction --prefer-dist --optimize-autoloader --no-scripts
fi

echo "Waiting for database connection..."
while ! nc -z db 3306; do
  sleep 1
done

echo "Database is ready! Running migrations..."

# Run migrations but continue even if some fail
php artisan migrate --force || echo "Migrations completed with some errors, continuing..."

echo "Starting PHP server..."
php artisan serve --host=0.0.0.0 --port=8000
