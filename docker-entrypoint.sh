#!/usr/bin/env bash

[ $DEBUG ] && set -x

if [ "`ls -A /app/chandao`" = "" ]; then
  cp -a /var/www/chandao/* /app/chandao
fi

if [ "`cat /app/chandao/VERSION`" != "`cat /var/www/chandao/VERSION`" ]; then
  cp -a /var/www/chandao/* /app/chandao
fi

chmod -R 777 /app/chandao/www/data
chmod -R 777 /app/chandao/tmp
chmod 777 /app/chandao/www
chmod 777 /app/chandao/config
chmod -R a+rx /app/chandao/bin/*

/etc/init.d/apache2 start

chown -R www-data:www-data /app/chandao
chown -R mysql:mysql /var/lib/mysql/
if [ "`ls -A /var/lib/mysql/`" = "" ]; then
  mysql_install_db --defaults-file=/etc/mysql/my.cnf
  /etc/init.d/mysql start
  /usr/bin/mysqladmin -uroot password $MYSQL_ROOT_PASSWORD
  mysql -uroot -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE user='root';FLUSH PRIVILEGES;"
else
  /etc/init.d/mysql start
fi

tail -f /var/log/apache2/zentao_error_log
