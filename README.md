Docker image for development and debugging purpose.

Source available at <https://github.com/ste80pa/php-lamp-xdebug>.

## Pre-installed Software ##

### WEBGRIND ###

The image comes  with __WebGrind__ pre-installed <https://github.com/jokkedk/webgrind> and accessible under __/webgrind/__ location

### PHP ###

* PHP 5.5.9-1
* Zend Engine v2.5.0
* Zend OPcache v7.0.3
* Xdebug v2.2.3

### MYSQL ###

* MySql 5.5.55

### APACHE ###

* Apache/2.4.7

### COMPOSER ###

* Composer 1.4.2

## Environment Variables ##

### XDEBUG_REMOTE_HOST ###

This is the most critical setting.
On Unix / Linux / MacOs machine must be set to the ip of the network interface card or to an alias ip address.

On MacOs you can create an alias typing

`bash# sudo ifconfig lo0 alias 192.168.1.99 255.255.255.0`

On Linux / Unix (this can vary depending on the distibution / os )

`bash# ifconfig lo0:0 192.168.1.99 netmask 255.255.255.0 up`

On Window machine (requires administrator privileges)

First search for interface alias

`PS C:/>Get-NetIPInterface | Format-Table`

then add alias 

`PS C:/>netsh interface ip add address "Loopback Pseudo-Interface 1" 192.168.1.99 255.255.255.0`

### XDEBUG_REMOTE_PORT ###

Sets the default remote port. By Default it is set to 9000

### SITE_TYPE ###

SITE_TYPE environment variable instruct the stack  about the kind of configuration apache should use, in other words sets the DocumentRoot on web,  public or to the root of the folder you attached to the volume  __/var/www/html__.

The values accepted are:

* laravel
* symfony
* normal
