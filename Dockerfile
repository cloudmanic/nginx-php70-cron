FROM alpine:3.5

MAINTAINER Spicer Matthews <spicer@cloudmanic.com>

ARG P_UID=33
ARG P_GID=33

ENV NGINX_VERSION 1.11.10

# Essential pkgs
RUN apk add --no-cache openssh-client git tar php7-fpm curl bash vim

# Essential php magic
RUN apk add --no-cache php7-curl php7-dom php7-gd php7-ctype php7-zip php7-xml php7-iconv php7-sqlite3 php7-mysqli php7-pgsql php7-pdo_pgsql php7-json php7-phar php7-openssl php7-pdo php7-mcrypt php7-pdo php7-pdo_pgsql php7-pdo_mysql php7-opcache php7-zlib php7-mbstring php7-session php7-intl php7-gettext

# Composer
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
      "https://getcomposer.org/installer" \
    | php7 -- --install-dir=/usr/bin --filename=composer

# Reset Password and group files
RUN set -x \
      && echo "root:x:0:0:root:/root:/bin/ash" > /etc/passwd \
      && echo "root:::0:::::" > /etc/shadow \
      && echo "root:x:0:root" > /etc/group 
      
# Ensure www-data user exists
RUN set -x \ 
  && addgroup -g ${P_GID} -S www-data \
  && adduser -u ${P_UID} -D -S -G www-data www-data 
   
# Setup directory and Set perms for document root.
RUN set -x \
  && mkdir /www \   
  && chown -R www-data:www-data /www     

# Copy over default files
COPY php.ini /etc/php7/php.ini
RUN set -x && ln -s /usr/bin/php7 /usr/bin/php

# Copy the file that gets called when we start
COPY start.sh /start.sh
RUN chmod 700 /start.sh && chown www-data:www-data /start.sh

# Copy over the www-data cron-tab file.
RUN set -x && rm /etc/crontabs/root
COPY crontab /etc/crontabs/www-data

# Workint directory
WORKDIR /www   

# Start the server
CMD ["/start.sh"]
