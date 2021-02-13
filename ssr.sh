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
~/.acme.sh/acme.sh --issue -d $do_name --standalone -k ec-256
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

apt-get install shadowsocks-libev
wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.2.0/v2ray-plugin-linux-amd64-v1.2.0.tar.gz
tar -xzvf v2ray-plugin-linux-amd64-v1.2.0.tar.gz
mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
rm -rf v2ray-plugin-linux-amd64-v1.2.0.tar.gz
rm /etc/shadowsocks-libev/config.json
cat <<EOF >>/etc/shadowsocks-libev/config.json
{
    "server":["::1", "127.0.0.1"],
    "mode":"tcp_and_udp",
    "server_port":8089,
    "local_port":1080,
    "password":"tunneler123",
    "timeout":60,
    "method":"aes-256-gcm",
    "plugin":"v2ray-plugin",
    "plugin_opts":"server;loglevel=none"
}
EOF
systemctl restart nginx
systemctl enable nginx
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev
clear
echo "ENJOY, THIS IS PHTUNNELER"

