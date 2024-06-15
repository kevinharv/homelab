#!/bin/sh

# Exit if a command returns non-zero code
set -e

# Ensure ownership of WebDAV lock DB
chown -R www-data:www-data /var/lib/dav
chmod -R 777 /var/lib/dav

# Ensure ownership of configuration
# chown -R www-data:www-data /usr/local/apache2/conf
chmod -R o+r /usr/local/apache2/conf

# Ensure ownership of site content
# chown -R www-data:www-data /usr/local/apache2/htdocs
chmod -R o+rw /usr/local/apache2/htdocs

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

# Start Apache in the foreground
exec httpd -DFOREGROUND "$@"