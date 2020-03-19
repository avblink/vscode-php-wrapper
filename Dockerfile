# php-cs-fixer only works with php 7.1

FROM php:7.1.5-alpine 

ENV FIXER_VERSION v2.3.2

RUN set -ex \
    && apk add --no-cache git \
	&& cd /usr/bin \
	&& curl -fSL "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/$FIXER_VERSION/php-cs-fixer.phar" -o php-cs-fixer \
    && chmod a+x php-cs-fixer

CMD ["php", "-a"]
