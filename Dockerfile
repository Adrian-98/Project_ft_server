#get the image from debian buster
FROM debian:buster
MAINTAINER amunoz-p <amunoz-p@student.42madrid.com>
#update and install nginx & phpmyadmin & mysql & wegt
RUN apt-get update 
RUN apt-get -y  install  wget nginx mariadb-server php-fpm php-mysql
#Nginx set up
cd 
mkdir -p /var/www/localhost
cp 


