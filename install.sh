#!/bin/bash
yum update
yum install -y epel-release
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://github.com/quyeticb/nginx_modules/raw/master/webtatic-release.rpm
yum group install -y "Development Tools"
yum install -y nano git composer nano wget mlocate curl-devel libxml2-devel gcc gd-devel GeoIP-devel libtool perl-core zlib-devel gd gd-devel openssl-devel google-perftools google-perftools-devel redis java firewalld php-pecl-ssh2 vsftpd screen glibc.i686 zlib.i686 libstdc++.i686 whois strace the_silver_searcher
yum install -y yum-plugin-replace
yum replace php-common --replace-with=php71w-common
yum install -y php71w-fpm php71w-opcache php71w-cli php71w-common php71w-gd php71w-imap php71w-mbstring php71w-mcrypt php71w-mysql php71w-pdo php71w-pecl-imagick php71w-pecl-mongodb php71w-pecl-redis php71w-pspell php71w-tidy php71w-xml php71w-xmlrpc php71w-intl php71w-interbase php71w-embedded php71w-devel php71w-bcmath php71w-odbc php71w-pdo_dblib php71w-pear php71w-pecl-xdebug php71w-process php71w-soap
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gunzip GeoLiteCity.dat.gz
mv GeoLiteCity.dat /usr/share/GeoIP/

mkdir /usr/local/custom
wget https://github.com/openresty/redis2-nginx-module/archive/master.zip
unzip master.zip
rm -f master.zip
echo -e "y"|mv redis2-nginx-module-master /usr/local/custom/

wget https://github.com/EasyEngine/ngx_http_redis/archive/master.zip
unzip master.zip
rm -f master.zip
echo -e "y"|  mv ngx_http_redis-master /usr/local/custom/

wget https://github.com/simpl/ngx_devel_kit/archive/master.zip
unzip master.zip
rm -f master.zip
echo -e "y"|mv ngx_devel_kit-master /usr/local/custom/

wget https://github.com/FRiCKLE/ngx_cache_purge/archive/master.zip
unzip master.zip
rm -f master.zip
echo -e "y"|mv ngx_cache_purge-master /usr/local/custom/

wget https://github.com/openresty/echo-nginx-module/archive/master.zip
unzip master.zip
rm -f master.zip
echo -e "y"|mv echo-nginx-module-master /usr/local/custom/

wget https://github.com/quyeticb/nginx_modules/raw/master/openssl-1.1.0f.tar.gz
tar -xvzf openssl-1.1.0f.tar.gz
echo -e "y"|mv openssl-1.1.0f /usr/local/custom/

wget https://github.com/quyeticb/nginx_modules/raw/master/pcre-8.41.zip
unzip pcre-8.41.zip
rm -f pcre-8.41.zip
echo -e "y"|mv pcre-8.41 /usr/local/custom/

wget http://nginx.org/download/nginx-1.13.8.tar.gz
tar -xvzf nginx-1.13.8.tar.gz && cd nginx-1.13.8
./configure --with-http_gzip_static_module --with-pcre --with-file-aio --without-http_scgi_module --without-http_uwsgi_module --user=nginx --group=nginx --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_image_filter_module --with-compat --with-threads --with-http_addition_module --with-http_auth_request_module --with-cc-opt="-march=native -mtune=native -O2 -pipe" --with-zlib-asm=pentiumpro --with-pcre=/usr/local/custom/pcre-8.41 --with-pcre-jit --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module --with-http_geoip_module --with-http_sub_module --with-mail --with-mail_ssl_module --with-stream_realip_module --with-stream --with-stream_ssl_module --with-stream_ssl_preread_module --with-http_dav_module --with-http_gunzip_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-google_perftools_module --with-openssl=/usr/local/custom/openssl-1.1.0f/ --add-module=/usr/local/custom/redis2-nginx-module-master --add-module=/usr/local/custom/ngx_http_redis-master --add-module=/usr/local/custom/ngx_devel_kit-master --add-module=/usr/local/custom/ngx_cache_purge-master --add-module=/usr/local/custom/echo-nginx-module-master
make && make install
useradd -r nginx
mkdir /etc/nginx/conf
mkdir /etc/nginx/conf.d
wget https://raw.githubusercontent.com/quyeticb/nginx_modules/master/nginx.service
echo -e "y"|mv nginx.service /lib/systemd/system/nginx.service
wget http://www-eu.apache.org/dist/lucene/solr/7.2.0/solr-7.2.0.tgz
tar xzf solr-7.2.0.tgz solr-7.2.0/bin/install_solr_service.sh --strip-components=2
sudo bash ./install_solr_service.sh solr-7.2.0.tgz

wget https://raw.githubusercontent.com/quyeticb/nginx_modules/master/mongo.repo
echo -e "y"|mv mongo.repo /etc/yum.repos.d/


yum update
sudo yum install -y mongodb-org

echo "#vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
#connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=NO
pasv_enable=YES
pasv_addr_resolve=YES
pasv_address=$(hostname -I | cut -d' ' -f 1)" > /etc/vsftpd/vsftpd.conf
echo "#user_list
# vsftpd userlist
# If userlist_deny=NO, only allow users in this file
# If userlist_deny=YES (default), never allow users in this file, and
# do not even prompt for a password.
# Note that the default vsftpd pam config also checks /etc/vsftpd/ftpusers
# for users that are denied.
#root
bin
daemon
adm
lp
sync
shutdown
halt
mail
news
uucp
operator
games
nobody" > /etc/vsftpd/user_list
echo "# Users that are not allowed to login via ftp
#root
bin
daemon
adm
lp
sync
shutdown
halt
mail
news
uucp
operator
games
nobody" > /etc/vsftpd/ftpusers

sed -i "s%;date.timezone =%date.timezone = America/New_York%g" "/etc/php.ini"
sed -i "s%max_execution_time = 30%max_execution_time = 3600%g" "/etc/php.ini"
sed -i "s%max_input_time = 60%max_input_time = 3600%g" "/etc/php.ini"
sed -i "s%memory_limit = 128M%memory_limit = 2048M%g" "/etc/php.ini"
sed -i "s%upload_max_filesize = 2M%upload_max_filesize = 2048M%g" "/etc/php.ini"
sed -i "s%post_max_size = 8M%post_max_size = 2048M%g" "/etc/php.ini"

