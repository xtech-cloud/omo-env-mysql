#!/bin/bash
if [ ! `id -u` -eq 0 ]; then
    echo 'need root'
    exit
fi

apk add --no-cache mariadb
apk add --no-cache mysql-client

mkdir -p /omo/data/mongodb

chown -R mysql:mysql /omo/data/mysql

#################################################
# Configurate MariaDB
#################################################
cp -f ./mysql/my.cnf /etc/mysql/my.cnf

mysql_install_db --user=mysql --rpm --datadir=/omo/data/mysql
mysqld_safe --nowatch --datadir=/omo/data/mysql
sleep 3
mysqladmin -u root password 'mysql@OMO'
mysqladmin -u root -p'mysql@OMO' shutdown
sleep 3

mysqld_safe --nowatch --datadir=/omo/data/mysql

echo '!!! you need append follow code to /omo/.startup.sh'
echo 'mysqld_safe --nowatch --datadir=/omo/data/mysql'

