#!/bin/bash
  
set -m

### WebService Account
RUN groupadd -g 33 www-data \
    && useradd -u 33 -ms /usr/sbin/nologin -g www-data www-data

###php.ini, php-fpm.conf, www.conf setting
PHPINI="/usr/local/etc/php/php.ini"
PHPFPMCONF="/usr/local/etc/php-fpm.conf"
WWWCONF="/usr/local/etc/php-fpm.d/www.conf"

cp /usr/local/etc/php/php.ini-production ${PHPINI}
sed -i "s/display_errors = Off/display_errors = On/" ${PHPINI}
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 10M/" ${PHPINI}
sed -i "s/post_max_size = .*/post_max_size = 12M/" ${PHPINI}
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" ${PHPINI}
sed -i "s/variables_order = .*/variables_order = 'EGPCS'/" ${PHPINI}

sed -i "s/;daemonize\s*=\s*yes/daemonize = no/g" ${PHPFPMCONF}
sed -i "s/;error_log =.*/error_log = \/proc\/self\/fd\/2/" ${PHPFPMCONF}

sed -i "s/;listen.owner = www-data/listen.owner = www-data/g" ${WWWCONF}
sed -i "s/;listen.group = www-data/listen.group = www-data/g" ${WWWCONF}
sed -i "s/user = www-data/user = www-data/g" ${WWWCONF}
sed -i "s/group = www-data/group = www-data/g" ${WWWCONF}
sed -i "s/listen = .*/listen = 9000/" ${WWWCONF}
sed -i "s/pm.max_children = .*/pm.max_children = 200/" ${WWWCONF}
sed -i "s/pm.start_servers = .*/pm.start_servers = 56/" ${WWWCONF}
sed -i "s/pm.min_spare_servers = .*/pm.min_spare_servers = 32/" ${WWWCONF}
sed -i "s/pm.max_spare_servers = .*/pm.max_spare_servers = 96/" ${WWWCONF}
sed -i "s/^;clear_env = no$/clear_env = no/" ${WWWCONF}


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