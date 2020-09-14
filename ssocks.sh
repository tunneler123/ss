apt-get install shadowsocks
apt-get install screen
apt-get install curl
screen -dmS screen ssserver -p 10 -k tunneler -m aes-256-cfb
MYIP=`curl -s ifconfig.me`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
nano /etc/shadow.txt
sed -i $MYIP2 /etc/shadow.txt
clear
echo -e "\e[1;32m SHADOWSOCKS INSTALLED \e[0m"
echo -e "\e[1;32m CHECK AT /etc/shadow.txt \e[0m"
