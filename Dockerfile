FROM nickistre/ubuntu-lamp:14.04

ENV XDEBUG_REMOTE_HOST=172.17.0.1
ENV XDEBUG_REMOTE_PORT=9000
ENV XDEBUG_PROFILER_ENABLE=1
ENV SITE_TYPE='laravel'

VOLUME /var/www/html/ /home/web/cachegrind/ /var/lib/mysql

RUN export LC_ALL=C.UTF-8\
&& apt-get install -y python-software-properties software-properties-common\
&& add-apt-repository -y ppa:ondrej/php\
&& apt-get update\  
&& apt install -y\
    php5.6\
    php5.6-xml\
    php5.6-mbstring\
    php5.6-dom\
    php5.6-gmp\
    php5.6-mcrypt\
    php5.6-pdo-mysql\
    php5.6-xdebug\
    php5.6-curl\
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

ADD supervisord.conf /etc/supervisord.conf
ADD xdebug_settings.ini /etc/php5/mods-available/
ADD 000-default-laravel.conf /etc/apache2/sites-available/
ADD 000-default-symfony.conf /etc/apache2/sites-available/
ADD webgrind.conf /etc/apache2/sites-available/
ADD lamp_setup.sh /bin/lamp_setup.sh

RUN php5enmod xdebug_settings\
&& php5enmod mcrypt\
&& php5enmod curl\
&& chmod 755 /bin/lamp_setup.sh\
&& a2enmod actions\
&& a2enmod rewrite\
&& a2ensite webgrind\
&& a2dissite 000-default\
&& a2ensite 000-default-laravel

CMD ["/usr/bin/supervisord" , "-c" , "/etc/supervisord.conf"]

EXPOSE 22 80 443 3306
