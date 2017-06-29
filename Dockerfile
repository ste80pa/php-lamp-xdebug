
FROM nickistre/ubuntu-lamp:14.04

ENV XDEBUG_REMOTE_HOST=172.17.0.1
ENV XDEBUG_REMOTE_PORT=9000
ENV SITE_TYPE='laravel'

VOLUME /var/www/html/ /home/web/cachegrind/

RUN apt-get -y update\
&& apt-get install -y\
    php5-xdebug\
    crudini\
    graphviz\
    git\
&& mkdir -p /home/web/webgrind\
&& mkdir -p /home/web/cachegrind/\
&& git clone https://github.com/jokkedk/webgrind.git /home/web/webgrind\
&& wget -O /tmp/installer https://getcomposer.org/installer\
&& php /tmp/installer --filename=composer --install-dir=/bin\
&& rm -f /tmp/installer\
&& chown -R www-data:www-data /home/web/

ADD xdebug_settings.ini /etc/php5/mods-available/
ADD 000-default-laravel.conf /etc/apache2/sites-available/
ADD 000-default-symfony.conf /etc/apache2/sites-available/
ADD webgrind.conf /etc/apache2/sites-available/
ADD lamp_setup.sh /bin/lamp_setup.sh

RUN php5enmod xdebug_settings\
&& chmod 755 /bin/lamp_setup.sh\
&& a2enmod actions\
&& a2enmod rewrite\
&& a2ensite webgrind\
&& a2dissite 000-default\
&& a2ensite 000-default-laravel

CMD /bin/lamp_setup.sh

EXPOSE 80 443 22