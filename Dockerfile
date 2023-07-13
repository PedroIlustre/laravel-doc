FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    openssl \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql zip

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN sed -i 's/DocumentRoot\ \/var\/www\/html/DocumentRoot\ \/var\/www\/public/' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www/html

WORKDIR /var/www/html

RUN composer install --no-interaction --no-plugins --no-scripts

RUN cp .env.example .env
RUN php artisan key:generate

EXPOSE 80

CMD ["apache2-foreground"]