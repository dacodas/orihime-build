#!/bin/bash

set -ueo pipefail 

while read VARIABLE
do 
    echo "export $VARIABLE=${!VARIABLE}" >> /etc/apache2/envvars
done <<EOF
SECRET_KEY
ORIHIME_DJANGO_ENVIRONMENT
ORIHIME_RELEASE
ORIHIME_NAMESPACE
EOF

django-admin makemigrations
django-admin migrate --run-syncdb
( set +o pipefail ; yes yes | django-admin collectstatic )

( cd /usr/local/src/orihime-django/orihime ; django-admin makemessages -l ja )

while read DIRECTORY
do
    ( cd "$DIRECTORY" ; django-admin compilemessages )
done <<EOF
/usr/local/src/orihime-django/orihime
/usr/local/lib/python3.7/site-packages/django_registration
/usr/local/lib/python3.7/site-packages/rest_framework
EOF

echo "Running with the following packages:"
pip freeze

chown -R www-data:www-data /var/lib/orihime-django
apache2ctl -D FOREGROUND
