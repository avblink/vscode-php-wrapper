# php-cs-fixer only works with php 7.1

FROM php:7.1.5-alpine 

ENV FIXER_VERSION v2.3.2

RUN set -ex \
    && apk add --no-cache git \
	&& cd /usr/bin \
	&& curl -fSL "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/$FIXER_VERSION/php-cs-fixer.phar" -o php-cs-fixer \
    && chmod a+x php-cs-fixer

#Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" ; \
    php composer-setup.php \
    php -r "unlink('composer-setup.php');" ; \
	mv composer.phar /usr/local/bin/composer

# Add Drupal coding standards
RUN composer config --global --no-interaction allow-plugins.composer/installers true
RUN composer config --global --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true

RUN composer global require drupal/coder    
RUN ln -s ~/.composer/vendor/drupal/coder/coder_sniffer/Drupal ~/.composer/vendor/squizlabs/php_codesniffer/src/Standards/Drupal \
    ln -s ~/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice ~/.composer/vendor/squizlabs/php_codesniffer/src/Standards/DrupalPractice
    
RUN composer global require wp-coding-standards/wpcs 
RUN ln -s ~/.composer/vendor/wp-coding-standards/wpcs ~/.composer/vendor/squizlabs/php_codesniffer/src/Standards/Wordpress

RUN ln -s /root/.composer/vendor/squizlabs/php_codesniffer/bin/phpcs /usr/bin/phpcs
RUN ln -s /root/.composer/vendor/squizlabs/php_codesniffer/bin/phpcbf /usr/bin/phpcbf

CMD ["php", "-a"]