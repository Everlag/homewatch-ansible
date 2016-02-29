#!/bin/sh

# Set database credentials
# Replace user, password stays empty
sed -i -e "s|'DB_USER', ''|'DB_USER', 'root'|g" www/config/config.local.php

# Turn off password authentication with a dirty hack.
sed -i -e '/if ($password/,+1 s/^/\/\//' www/lib/UASmartHome/Auth/DefaultUserProvider.php

# Jump into root for this nasty mysql restoration business
sudo su <<ENDROOT

mysql stonymountain_hw_apts < etc/sql/stonymountain_hw_apts.sql
mysql stonymountain_hw_bas  < etc/sql/stonymountain_hw_bas.sql

ENDROOT