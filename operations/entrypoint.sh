#!/bin/bash

cd /var/www/html

echo "Test"

if [ ! -e piwik.php ]; then
	tar cf - --one-file-system -C /usr/src/piwik . | tar xf -
	chown -R www-data .
fi

touch /var/www/html/config/config.ini.php
kaigara render config.php | tee /var/www/html/config/config.ini.php
