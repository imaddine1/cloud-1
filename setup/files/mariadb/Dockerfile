FROM debian:buster

RUN apt-get update -y
RUN apt-get install -y mariadb-server

COPY /tools/db.sh ./startup.sh
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

EXPOSE 3306

CMD ["bash", "startup.sh"]
