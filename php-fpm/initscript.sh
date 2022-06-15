#!/bin/bash
  
set -m

###laravel initialize
cd /var/www/html
composer global require laravel/installer
composer create-project --prefer-dist laravel/laravel laravel
composer install
chown -R www-data:www-data /var/www/html/laravel
chmod -R 775 /var/www/html/laravel/bootstrap/cache
chmod -R 755 /var/www/html/laravel/storage