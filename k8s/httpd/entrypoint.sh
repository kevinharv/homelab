#!/bin/sh

# Exit if a command returns non-zero code
set -e

# Create logs directory
    # mkdir
    # chown

# Create DAV lock directory

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

# Start Apache in the foreground
exec httpd -DFOREGROUND "$@"