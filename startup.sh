#!/bin/sh
/usr/sbin/crond
rm -f /tmp/server.pid
if [[ -z "${RAILS_ENV}" ]]; then
    RAILS_ENV=development rails server -b=0.0.0.0 -P /tmp/server.pid
else 
    rails server -b=0.0.0.0 -P /tmp/server.pid
fi

