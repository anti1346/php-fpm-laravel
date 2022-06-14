FROM php:8.1-fpm

ENV COMPOSER_MEMORY_LIMIT='-1'
ENV NODE_VERSION v16.15.1

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt update \
    && apt install -qq -y --no-install-recommends \
        zlib1g-dev \
        libzip-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libxml2-dev \
        libreadline-dev \
        libgmp-dev \
        libmagickwand-dev \
        unzip \
    && apt install -qq -y --no-install-recommends \
        telnet \
        vim \
        git \
        curl \
    && apt install -qq -y --no-install-recommends \
        procps \
        net-tools \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install intl \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && sed -i "s/display_errors = Off/display_errors = On/" /usr/local/etc/php/php.ini \
    && sed -i "s/upload_max_filesize = .*/upload_max_filesize = 10M/" /usr/local/etc/php/php.ini \
    && sed -i "s/post_max_size = .*/post_max_size = 12M/" /usr/local/etc/php/php.ini \
    && sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /usr/local/etc/php/php.ini \
    && sed -i "s/variables_order = .*/variables_order = 'EGPCS'/" /usr/local/etc/php/php.ini
RUN sed -i "s/;error_log =.*/error_log = \/proc\/self\/fd\/2/" /usr/local/etc/php-fpm.conf
RUN sed -i "s/listen = .*/listen = 9000/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.max_children = .*/pm.max_children = 200/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.start_servers = .*/pm.start_servers = 56/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.min_spare_servers = .*/pm.min_spare_servers = 32/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.max_spare_servers = .*/pm.max_spare_servers = 96/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/^;clear_env = no$/clear_env = no/" /usr/local/etc/php-fpm.d/www.conf

RUN groupadd -g 5000 www \
    && useradd -u 1000 -ms /bin/bash -g www www

### Composer Install
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
    && echo "export PATH=${PATH}:~/.composer/vendor/bin" >> ~/.bashrc \
    && source ~/.bashrc
    # && composer install
RUN cd /var/www/html \
    && composer global require laravel/installer \
    && composer create-project laravel/laravel \
    && chown -R www-data:www-data /var/www/html/laravel/storage /var/www/html/laravel/bootstrap/cache/ \
    && chmod -R 775 /var/www/html/laravel/bootstrap/cache/ \
    && chmod -R 755 /var/www/html/laravel/storage

### Install NVM with NODE and NPM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && source ~/.bashrc \
    && nvm install node
    # && nvm install $NODE_VERSION

USER www

EXPOSE 9000

CMD ["php-fpm"]








### docker build
# docker build --no-cache -t anti1346/php-fpm-laravel:8.1 .
#
### docker buildx(m1)
# docker buildx build --platform linux/amd64 --load --no-cache -t anti1346/php-fpm-laravel:8.1-amd64 .
