# you need to create your own network cause there is no default ip
FROM debian:buster

RUN apt-get -y update --fix-missing  && apt-get -y install nginx

# configuration of nginx
COPY ./conf/nginx.conf /etc/nginx/


# Create a directory for the wordpress
RUN mkdir -p /var/www/wordpress

# Create a directory for the phpmyadmin
RUN mkdir -p /var/www/html

RUN chown -R www-data.www-data /var/www/ \
   && chmod -R 755 /var/www/

#COPY website /var/www/html
# CREATE CERTIFICATE TO USING HTTPS
# RUN apt-get -y install openssl

#index.nginx-debian.html
# RUN mkdir /etc/nginx/ssl

# RUN cd /etc/nginx/ssl && openssl req -x509 -nodes -batch  -newkey rsa:2048 -keyout /etc/nginx/ssl/private.key -out /etc/nginx/ssl/ca.crt

# Expose the port for access
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
