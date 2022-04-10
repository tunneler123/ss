apt-get update && apt-get -y upgrade
apt-get -y install shadowsocks-libev
wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.2.0/v2ray-plugin-linux-amd64-v1.2.0.tar.gz
tar -xzvf v2ray-plugin-linux-amd64-v1.2.0.tar.gz
mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
rm -rf v2ray-plugin-linux-amd64-v1.2.0.tar.gz
rm /etc/shadowsocks-libev/config.json
cat <<EOF >>/etc/shadowsocks-libev/config.json
{
    "server":"0.0.0.0",
    "server_port":8089,
    "local_port":1080,
    "password":"tunneler123",
    "method":"aes-256-gcm",
    "plugin":"v2ray-plugin",
    "plugin_opts":"server;loglevel=none"
}
EOF
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev
clear
echo "ENJOY, THIS IS PHTUNNELER"
