FROM php:8.1.7-fpm

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

### Composer Install
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
    && echo "export PATH=${PATH}:~/.composer/vendor/bin" >> ~/.bashrc \
    && source ~/.bashrc
    # && composer install
RUN cd /var/www/html \
    && composer global require laravel/installer \
    && composer create-project laravel/laravel example-app

RUN groupadd -g 5000 www \
    && useradd -u 1000 -ms /bin/bash -g www www

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