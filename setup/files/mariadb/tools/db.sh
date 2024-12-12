service mysql start
mysql -e "CREATE DATABASE IF NOT EXISTS $MY_DATABASE ;"
mysql -e "CREATE USER IF NOT EXISTS $MY_USER@'%' IDENTIFIED BY '$MY_PASS' ;"
mysql -e "GRANT ALL PRIVILEGES ON $MY_DATABASE.* TO $MY_USER@'%' ;"
#mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MY_ROOT';"
#kill $(cat /var/run/mysqld/mysqld.pid)
echo "database  and user created succesfuly"
service mysql stop
mysqld_safe
