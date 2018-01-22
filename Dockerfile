FROM ubuntu:bionic

ENV XDEBUG_REMOTE_HOST=172.17.0.1
ENV XDEBUG_REMOTE_PORT=9000
ENV XDEBUG_PROFILER_ENABLE=1
ENV SITE_TYPE='laravel'
ENV DEBIAN_FRONTEND='noninteractive'

VOLUME /var/www/html/ /home/web/cachegrind/ /var/lib/mysql

RUN export LC_ALL=C.UTF-8\
&& apt-get update\
&& apt-get upgrade -y\  
&& apt install -y\
    apt-utils\
    supervisor\
    mariadb-server\
    apache2\
    crudini\
    graphviz\
    git\
    wget2\
    php7.1\
    php7.1-xml\
    php7.1-mbstring\
    php7.1-dom\
    php7.1-gmp\
    php7.1-mcrypt\
    php7.1-pdo-mysql\
    php7.1-xdebug\
    php7.1-curl\
&& mysql_install_db\
&& mkdir -p /home/web/webgrind\
&& mkdir -p /home/web/cachegrind/\
&& git clone https://github.com/jokkedk/webgrind.git /home/web/webgrind\
&& wget2 -O /tmp/installer https://getcomposer.org/installer\
&& php /tmp/installer --filename=composer --install-dir=/bin\
&& rm -f /tmp/installer\
&& chown -R www-data:www-data /home/web/

ADD supervisord.conf /etc/supervisord.conf
ADD xdebug_settings.ini /etc/php/7.1/mods-available
ADD 000-default-laravel.conf /etc/apache2/sites-available/
ADD 000-default-symfony.conf /etc/apache2/sites-available/
ADD webgrind.conf /etc/apache2/sites-available/
ADD lamp_setup.sh /bin/lamp_setup.sh

RUN phpenmod xdebug_settings\
&& phpenmod mcrypt\
&& phpenmod curl\
&& chmod 755 /bin/lamp_setup.sh\
&& a2enmod actions\
&& a2enmod rewrite\
&& a2ensite webgrind\
&& a2dissite 000-default\
&& a2ensite 000-default-laravel

CMD ["/usr/bin/supervisord" , "-c" , "/etc/supervisord.conf"]

EXPOSE 22 80 443 3306