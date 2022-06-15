#!/bin/bash
  
set -m

###laravel initialize(default laravel page)
LDIR="/var/www/html/laravel"
if [[ $(find /var/www/html -name .env -type f | wc -l) -eq 0 ]]; then
    echo "laravel is not found(empty)"
    cd /var/www/html
    composer global require laravel/installer
    composer create-project laravel/laravel laravel --prefer-dist
    # cd $LDIR
    # composer install
    chown -R www-data:www-data $LDIR
    chmod -R 775 $LDIR/bootstrap/cache
    chmod -R 755 $LDIR/storage
    exit 127
else
  echo "laravel found(not empty)"
fi