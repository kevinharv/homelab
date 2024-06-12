#!/bin/sh

# Exit if a command returns non-zero code
set -e

# Create logs directory
    # mkdir
    # chown

# chown DAV lock directory
# chown conf directory
# chown site contents

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

# Start Apache in the foreground
exec httpd -DFOREGROUND "$@"