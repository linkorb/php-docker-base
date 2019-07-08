FROM php:7.3.6-apache-stretch

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://localhost:9000/ || exit 1

RUN docker-php-ext-install pdo pdo_mysql

# Install NPM
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --yes nodejs git zip unzip && apt-get clean && rm -rf /var/lib/apt/lists

# Install Composer
RUN curl -sL https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer | php
RUN mv composer.phar /usr/bin/composer
RUN chmod +x /usr/bin/composer

COPY httpd.conf /etc/apache2/sites-enabled/000-default.conf
COPY php.ini /usr/local/etc/php/php.ini
COPY wait-for-it.sh /usr/local/sbin/wait-for-it.sh

RUN chown -R www-data /var/www

EXPOSE 9000
