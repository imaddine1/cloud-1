FROM debian:buster

RUN apt-get update -y --fix-missing
           
RUN apt-get install -y wget php php-fpm  php-mysql mariadb-client

RUN mkdir -p /var/www

RUN cd /var/www/ && wget https://wordpress.org/latest.tar.gz && tar xvf latest.tar.gz
 
RUN cd /var/www && rm -f latest.tar.gz

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

COPY ./conf/wp /usr/local/bin/

RUN cd /usr/local/bin && chmod +x wp

COPY /tools/create.sh .

EXPOSE 9000

# this command make php work in foreground
CMD ["bash", "create.sh"]
