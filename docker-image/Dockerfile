
# Seta imagem base UBUNTU 22.04
FROM ubuntu:22.04

# Seta a pasta onde o projeto vai ficar dentro do container.
WORKDIR /var/www

RUN apt update
RUN apt install -y nano 
RUN apt install -y lighttpd
#RUN apt install -y fcgiwrap
RUN apt install -y python3
RUN apt install -y build-essential
RUN apt install -y gnucobol
RUN apt install -y unixodbc unixodbc-dev
#RUN apt install -y systemd
#RUN apt install -y systemctl

# Instala os drivers ODBC dos bancos MariaBD/MYSQL e POSTGRESQL
RUN apt install -y odbc-mdbtools
RUN apt install -y odbc-mariadb 
RUN apt install -y odbc-postgresql

# Instala o CURL
RUN apt install -y curl

# Instala a JVM
RUN apt install -y openjdk-11-jre

# Instala a lib Karate DSL
COPY karate-1.4.0.jar /usr/local/bin


# Instala o driver para DB2
COPY db2clidriver.tar.gz .
RUN tar -xf db2clidriver.tar.gz && mv clidriver db2clidriver
RUN cp -R db2clidriver /home

RUN export DB2_CLI_DRIVER_INSTALL_PATH=/home/db2clidriver
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/db2clidriver/lib
RUN export LIBPATH=LIBPATH:/home/db2clidriver/lib
RUN export PATH=/home/db2clidriver/bin:$PATH
RUN export PATH=/home/db2clidriver/adm:$PATH
RUN echo "/home/db2clidriver/lib" >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf

# Compila o pre-processador de sql para gnucobol
COPY gnu-cobol-sql-2.0.tar.gz .
RUN  tar -xf gnu-cobol-sql-2.0.tar.gz && mv gnu-cobol-sql-2.0 cobol-sql

RUN cobol-sql/configure
RUN make cobol-sql
RUN make install cobol-sql

RUN make cobol-sql/ocsql
RUN make install cobol-sql/ocsql
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf
RUN echo "library_path = /var/www/cgi-bin/dist" >> /etc/gnucobol/runtime.cfg

RUN ldconfig

RUN rm -R *

RUN mkdir /var/www/cgi-bin

COPY cgi.conf /etc/lighttpd/conf-enabled/10-cgi.conf

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
