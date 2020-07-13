#!/bin/sh
/usr/sbin/crond
if [[ -z "${RAILS_ENV}" ]]; then
    RAILS_ENV=development rails server -b=0.0.0.0
else 
    rails server -b=0.0.0.0
fi

