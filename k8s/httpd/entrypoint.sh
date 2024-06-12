#!/bin/sh

# Exit if a command returns non-zero code
set -e

# Ensure ownership of WebDAV lock DB
chown -R www-data:www-data /var/lib/dav
chmod 700 /var/lib/dav

# chown conf directory?

# Ensure ownership of site content
chown -R www-data:www-data /usr/local/apache2/htdocs
chmod 700 /usr/local/apache2/htdocs

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

# Start Apache in the foreground
exec httpd -DFOREGROUND "$@"