FROM alpine:3.19

MAINTAINER Sasaya <sasaya@percussion.life>

ENV APP_ROOT /app
ENV PHP_INI_DIR /etc/php83

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk --no-cache add \
      make \
      git \
      curl \
      unzip \
      coreutils \
      mysql-client \
      mariadb-connector-c-dev \
      php83@community \
      php83-pdo_mysql@community \
      php83-pdo_sqlite@community \
      php83-redis@community \
      php83-mbstring@community \
      php83-tokenizer@community \
      php83-json@community \
      php83-bcmath@community \
      php83-zip@community \
      php83-gd@community \
      php83-pcntl@community \
      php83-exif@community \
      php83-sockets@community \
      php83-dom@community \
      php83-phar@community \
      php83-xmlwriter@community \
      php83-simplexml@community \
      php83-fileinfo@community \
      php83-posix@community \
      php83-xml@community \
      php83-ctype@community \
      php83-intl@community \
      php83-iconv@community \
      php83-xmlreader@community \
      php83-curl@community && \
    rm -rf /tmp/* /var/cache/apk/* /var/lib/apt/lists/*

RUN ln -s /usr/bin/php83 /usr/bin/php

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR ${APP_ROOT}

COPY ./composer.json .
COPY ./composer.lock .

RUN composer install --optimize-autoloader --prefer-dist --no-ansi --no-interaction --no-progress --no-scripts --no-cache

COPY ./app ./app
COPY ./bootstrap ./bootstrap
COPY ./config ./config
COPY ./database ./database
COPY ./public ./public
COPY ./resources ./resources
COPY ./routes ./routes
COPY ./storage ./storage
COPY ./artisan ./artisan

CMD ["/bin/sh", "-c", "php /app/artisan backup:run --only-db && php /app/artisan backup:clean"]
