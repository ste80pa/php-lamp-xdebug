#!/bin/sh

CRUDINI=$(which crudini)

#
# Configure xdebug
#

for ini in /etc/php5/apache2/conf.d/*xdebug_settings.ini
do    
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_connect_back 0 
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_enable 1
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_handler dbgp
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_host ${XDEBUG_REMOTE_HOST}
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_port ${XDEBUG_REMOTE_PORT}
done

#
# Select 
#

a2dissite 000-default\*

case "$SITE_TYPE" in
    laravel) a2ensite 000-default-laravel ;;
    symfony) a2ensite 000-default-symfony ;;
    *) a2ensite 000-default
esac

#
# Fix permissions
#
chown -R www-data:www-data /home/web/

#
# Run supervisord in foreground 
#
/usr/bin/supervisord -n