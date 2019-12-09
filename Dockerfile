#get the image from debian buster
FROM debian:buster
MAINTAINER amunoz-p <amunoz-p@student.42madrid.com>
#update and install nginx & phpmyadmin & mysql & wegt
RUN apt-get update && apt-get -y  install  wget nginx mariadb-server php-fpm php-mysql
#Nginx set up
RUN mkdir -p /var/www/localhost
COPY srcs/nginx-host-conf  /etc/nginx/sites-available/
RUN ln -fs /etc/nginx/sites-available/nginx-host-conf /etc/nginx/sites-enabled/default

#SSL SETUP
RUN mkdir ~/mkcert && \
	cd ~/mkcert && \
	wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
	mv mkcert-v1.1.2-linux-amd64 mkcert && \
	chmod +x mkcert && \
	./mkcert -install && \
	./mkcert localhost

#DATABASE SETUP
RUN service mysql start && \
echo "CREATE DATABASE wordpress;" | mysql -u root && \
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost';" | mysql -u root && \
echo "FLUSH PRIVILEGES;" | mysql -u root && \
echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root 
#RUN	mysql wordpress -u root --password=  < wordpress.sql

#WORDPRESS INSTALL
RUN wget https://wordpress.org/latest.tar.gz && \
	mv latest.tar.gz /var/www/localhost/
RUN cd /var/www/localhost/ && \
	tar -xf latest.tar.gz && \
	rm latest.tar.gz
COPY srcs/wp-config.php var/www/localhost/wordpress

#PHPMYADMIN INSTALL
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz && \
	mkdir /var/www/localhost/wordpress/phpmyadmin  && \
	tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/localhost/wordpress/phpmyadmin
COPY /srcs/config.inc.php /var/www/localhost/wordpress/phpmyadmin/
RUN rm -rf phpMyAdmin-4.9.0.1-english.tar.gz

#ALLOW NGINX USER
RUN chown -R www-data:www-data /var/www/localhost/* && chmod -R 755 /var/www/localhost/*
EXPOSE 80 443

CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	sleep infinity & wait