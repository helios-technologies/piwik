FROM php:5.6-apache

RUN apt-get update && apt-get install -y \
      libjpeg-dev \
      libfreetype6-dev \
      libgeoip-dev \
      libpng12-dev \
      libldap2-dev \
      zip \
      && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr \
   && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
   && docker-php-ext-install -j$(nproc) gd mbstring mysql pdo_mysql zip ldap opcache

RUN pecl install APCu geoip

ENV PIWIK_VERSION 3.0.4

RUN curl -fsSL -o piwik.tar.gz \
   "https://builds.piwik.org/piwik-${PIWIK_VERSION}.tar.gz" \
   && tar -xzf piwik.tar.gz -C /usr/src/ \
   && rm piwik.tar.gz

COPY php.ini /usr/local/etc/php/php.ini

RUN curl -fsSL -o /usr/src/piwik/misc/GeoIPCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz \
   && gunzip /usr/src/piwik/misc/GeoIPCity.dat.gz

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME /var/www/html

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
