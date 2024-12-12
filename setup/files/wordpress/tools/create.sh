service php7.3-fpm start
service php7.3-fpm stop

# mkdir -p /var/www/html
# cd /var/www/html
# wget https://wordpress.org/latest.tar.gz
# tar xvf latest.tar.gz
# cd /var/www/html
# rm -f latest.tar.gz


cd /var/www/wordpress
#wp core download --allow-root
wp core config --dbname=$MY_DATABASE --dbuser=$MY_USER --dbpass=$MY_PASS --dbhost=$MY_HOST --path=/var/www/wordpress --allow-root

wp core install --url=$IP --title=$BLOG_TITLE --admin_user=$AD_USER --admin_password=$AD_PASS --admin_email=$AD_EMAIL --path=/var/www/wordpress  --allow-root
wp user create $SP_USER $SP_EMAIL --role=subscriber --user_pass=$SP_PASS --path=/var/www/wordpress  --allow-root

php-fpm7.3 -F
