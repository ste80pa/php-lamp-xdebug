#!/bin/sh

CRUDINI=$(which crudini)
MYSQL_CONF='/etc/mysql/my.cnf'
MYSQL_DATA='/var/lib/mysql'

SSL_KEY='/etc/ssl/private/php-lamp-xdebug-selfsigned.key'
SSL_CRT='/etc/ssl/certs/php-lamp-xdebug-selfsigned.crt'
SSL_SUB="/CN=${HOSTNAME}/O=Testing Company/C=IT"

#
# Configure xdebug
#

for i in /etc/php/*
do
	ini_path="${i}/apache2/conf.d/"
	
	mkdir -p "${ini_path}"
	
	ini="${init_path}30-xdebug-debug.ini"
	
	if [ ! -f "${ini}" ]
	then
    touch "${ini}"
	fi

    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_connect_back 1 
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_enable 1
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_handler dbgp
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_host ${XDEBUG_REMOTE_HOST}
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.remote_port ${XDEBUG_REMOTE_PORT}
    ${CRUDINI} --set --format=ini ${ini} '' xdebug.profiler_enable ${XDEBUG_PROFILER_ENABLE}
done

#
# Generate certificate
#

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -subj "${SSL_SUB}" -keyout "${SSL_KEY}" -out "${SSL_CRT}"


#
# Select apache configuration
#

a2dissite 000-default\*

case "$SITE_TYPE" in
    laravel) a2ensite 000-default-laravel ;;
    symfony) a2ensite 000-default-symfony ;;
    *) a2ensite 000-default
esac

#
# Initialize MySQL Data Directory
#

chown -R mysql:mysql ${MYSQL_DATA}
mysql_install_db --datadir=${MYSQL_DATA}
sed -i "s/^key_buffer\w*/key_buffer_size/g" ${MYSQL_CONF}
sed -i "s/.*bind-address.*/bind-address = \*/" ${MYSQL_CONF}
chown -R mysql:mysql ${MYSQL_DATA}
service mysql start

#
# Fix permissions
#
/usr/bin/mysqladmin -u root password 'root'
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;" | mysql -u root --password=root
echo "FLUSH PRIVILEGES;" | mysql -u root --password=root
chown -R www-data:www-data /home/web/

service apache2 start