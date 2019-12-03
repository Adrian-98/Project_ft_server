#get the image from debian buster
FROM debian:buster
MAINTAINER amunoz-p <amunoz-p@student.42madrid.com>
#update and install nginx
RUN apt-get update -y &&  install -y  --no-install-recommend apt-utils wget && apt-get -y install nginx
RUN apt-get policy mariadb-server -y &&  apt-get install mariadb-server mariadb-client -y -qq && \
apt-get install cmake libncursesw5-dev libncurses5-dev cmake build-essential libssl-dev pkg-config -y && \
wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz -P /tmp && \
cd /tmp && \
tar xzf boost_1_69_0.tar.gz && \
cd boost_1_69_0 && \
./bootstrap.sh --prefix=/usr/ && \
./b2 && \
./b2 install && \
useradd -r -M -s /bin/false mysql && \
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.16.tar.gz -P /tmp && \
tar xzf mysql-8.0.16.tar.gz && \
cd mysql-8.0.16/ && \
mkdir build && \
cd build && \
cmake ../../mysql-8.0.16 && \
make && \
make install && \
apt-get install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip && \


