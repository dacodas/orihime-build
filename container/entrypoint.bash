#!/bin/bash

while read VARIABLE
do 
    echo "export $VARIABLE=${!VARIABLE}" >> /etc/apache2/envvars
done <<EOF
SECRET_KEY
ORIHIME_DJANGO_ENVIRONMENT
ORIHIME_RELEASE
ORIHIME_NAMESPACE
EOF

django-admin migrate --run-syncdb
django-admin collectstatic
apache2ctl -D FOREGROUND
