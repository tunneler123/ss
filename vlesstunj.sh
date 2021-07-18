#!/bin/bash
set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 domain_name" >&2
	exit 1
fi

do_name=$1

apt-get update && apt-get -y upgrade
mkdir /etc/v2ray
apt-get -y install nginx socat
hostnamectl set-hostname $do_name
curl https://get.acme.sh | sh
systemctl stop nginx
~/.acme.sh/acme.sh --issue --register-account -m example@example.org -d $do_name --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $do_name --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc
cat <<EOF >>/etc/nginx/sites-available/ssl
server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    ssl on;
    ssl_certificate       /etc/v2ray/v2ray.crt;
    ssl_certificate_key   /etc/v2ray/v2ray.key;
    ssl_protocols         TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers           HIGH:!aNULL:!MD5;
    server_name           $do_name;

    location / {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:8089;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
ln -s /etc/nginx/sites-available/ssl /etc/nginx/sites-enabled/
curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
bash install-release.sh
bash install-dat-release.sh
wget https://raw.githubusercontent.com/tunneler123/openvpn/master/config.json
cp config.json /usr/local/etc/v2ray/config.json
systemctl restart nginx
systemctl enable nginx
sudo systemctl restart v2ray
systemctl enable v2ray
clear
echo -e "\e[1;31m THIS IS PHTUNNELER \e[0m"
echo -e "\e[1;31m protocol: vless \e[0m"
echo -e "\e[1;31m ID : ad136a60-af16-4635-89b1-60ef6b899253 \e[0m"
echo -e "\e[1;31m PORT : 443 \e[0m"

