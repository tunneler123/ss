apt-get install shadowsocks
apt-get install screen
apt-get install curl
screen -dmS screen ssserver -p 10 -k tunneler -m aes-256-cfb
MYIP=`curl -s ifconfig.me`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
wget -O /etc/shadows.txt "https://raw.githubusercontent.com/tunneler123/ss/master/shadows.txt"
sed -i $MYIP2 /etc/shadows.txt
clear
echo -e "\e[1;32m SHADOWSOCKS INSTALLED \e[0m"
echo -e "\e[1;32m CHECK AT /etc/shadows.txt \e[0m"
