#!/bin/bash

echo "export SECRET_KEY=$SECRET_KEY" >> /etc/apache2/envvars
django-admin migrate --run-syncdb
django-admin collectstatic
apache2ctl -D FOREGROUND
