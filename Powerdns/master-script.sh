dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y
dnf install mariadb-server -y
systemctl enable --now mariadb
mysql_secure_installation --set-root-pass RoboShop@1

mysql  -uroot -pRoboShop@1 < user.sql
mysql  -uroot -pRoboShop@1 < powerdns.sql


systemctl start firewalld
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload
dnf install pdns pdns-backend-mysql -y
systemctl enable --now pdns
systemctl status pdns

cp /etc/pdns/pdns.conf /etc/pdns/pdns.conf.backup

> /etc/pdns/pdns.conf

echo '
launch=gmysql
gmysql-host=localhost
gmysql-user=pdns
gmysql-password=chaitu@123
gmysql-dbname=powerdns
master=yes
allow-axfr-ips=172.31.30.128 # slave-ip
also-notify=172.31.30.128   # slave-ip


# ----------- To access api -----
api=yes
webserver=yes
webserver-address=127.0.0.1
webserver-port=8081
api-key=supersecretapikey' > /etc/pdns/pdns.conf


systemctl restart  pdns
