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
cp /etc/pdns/pdns.conf /etc/pdns/pdns.conf.backup
> /etc/pdns/pdns.conf


echo '
launch=gmysql
gmysql-host=localhost
gmysql-user=pdns
gmysql-password=chaitu@123
gmysql-dbname=powerdns

slave=yes
superslave=yes
disable-axfr=no
allow-notify-from=172.31.31.237  # Master IP

# To have access
api=yes
webserver=yes
webserver-address=127.0.0.1
webserver-port=8081
api-key=supersecretapikey' > /etc/pdns/pdns.conf



systemctl restart pdns

#################

# INSERT INTO supermasters (ip, nameserver, account) VALUES ('172.31.31.237', 'ns1.icic.in', 'admin');

# when ever we create a new zone in master machine, we need to run this on slave machine.


#########################






curl -X POST http://127.0.0.1:8081/api/v1/servers/localhost/zones   -H 'X-API-Key: supersecretapikey'   -H 'Content-Type: application/json'   -d '{
    "name": "icic.in.",
    "kind": "Master",
    "masters": [],
    "nameservers": ["ns1.icic.in.", "ns2.icic.in."]
}'

















