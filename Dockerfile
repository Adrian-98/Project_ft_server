#get the image from debian buster
FROM debian:buster
MAINTAINER amunoz-p <amunoz-p@student.42madrid.com>
#update and install nginx
RUN apt-get update 
Run apt-get -y  install  wget nginx mariadb-server php-fpm php-mysql



