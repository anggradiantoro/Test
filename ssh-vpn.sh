#!/bin/bash
# Ssh Ovpn Setup 
# My Telegram : https://t.me/Manternet
# =========================
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                                                                                                                 
NC='\033[0;37m'

# // initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

# // Domain
domain=$(cat /root/domain)

# // detail nama perusahaan
country=MY
state=Malaysia
locality=Malaysia
organization=Manternet
organizationalunit=Manternet
commonname=Manternet.xyz
email=anjan

# // go to root
cd

# // Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# // nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# // Ubah izin akses
chmod +x /etc/rc.local

# // enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# // disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# // update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# // Install Wget And Curl
apt -y install wget curl

# // Install Requirements Tools
apt install ruby -y
apt install python -y
apt install make -y
apt install cmake -y
apt install coreutils -y
apt install rsyslog -y
apt install net-tools -y
apt install zip -y
apt install unzip -y
apt install nano -y
apt install sed -y
apt install gnupg -y
apt install gnupg1 -y
apt install bc -y
apt install jq -y
apt install apt-transport-https -y
apt install build-essential -y
apt install dirmngr -y
apt install libxml-parser-perl -y
apt install neofetch -y
apt install git -y
apt install lsof -y
apt install libsqlite3-dev -y
apt install libz-dev -y
apt install gcc -y
apt install g++ -y
apt install libreadline-dev -y
apt install zlib1g-dev -y
apt install libssl-dev -y
apt install libssl1.0-dev -y
apt install dos2unix -y
apt install curl -y
apt install pwgen openssl netcat cron -y
apt install socat -y
apt install idn -y

# // set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
date

# // set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# // install Fix
apt-get --reinstall --fix-missing install -y linux-headers-cloud-amd64 bzip2 gzip coreutils wget jq screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl git lsof
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n || true
clear
neofetch
END
chmod 644 /root/.profile

# // Nginx
installType='apt -y install'
source /etc/os-release
release=$ID
ver=$VERSION_ID

if [[ "${release}" == "debian" ]]; then
		sudo apt install gnupg2 ca-certificates lsb-release -y 
		echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list 
		echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
		curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key 
		# gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
		sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
		sudo apt update 
                apt -y install nginx

elif [[ "${release}" == "ubuntu" ]]; then
		sudo apt install gnupg2 ca-certificates lsb-release -y 
		echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
		echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
		curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
		# gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
		sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
		sudo apt update 
                apt -y install nginx
fi

systemctl daemon-reload
systemctl enable nginx
touch /etc/nginx/conf.d/alone.conf
cat <<EOF >>/etc/nginx/conf.d/alone.conf
server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 ssl http2 reuseport;	
             server_name ${domain};
             ssl_certificate /etc/mon/tls/xray.crt;
             ssl_certificate_key /etc/mon/tls/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
 #            root /usr/share/nginx/html;

             location = /vless {
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:14016;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location = /vmess {
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:23456;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location = /trojan-ws {
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:25432;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location = /ss-ws {
                      proxy_redirect off;
                      proxy_pass http://127.0.0.1:30300;
                      proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection fff;
             proxy_set_header Host eee;
 }
             location ^~ /vless-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:24456;
 }
             location ^~ /vmess-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:31234;
 }
             location ^~ /trojan-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:33456;
 }
             location ^~ /ss-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host eee;
             grpc_pass grpc://127.0.0.1:30310;
 }
             location  /fallback {
                      proxy_redirect off;
                      proxy_pass http://127.0.0.1:8880;
                      proxy_http_version 1.1;
              proxy_set_header Upgrade ddd;
              proxy_set_header Connection upgrade;
              proxy_set_header Host ccc;
              proxy_cache_bypass ddd;
  }
        }	
EOF

# // Move
sed -i 's/aaa/$remote_addr/g' /etc/nginx/conf.d/alone.conf
sed -i 's/bbb/$proxy_add_x_forwarded_for/g' /etc/nginx/conf.d/alone.conf
sed -i 's/ccc/$host/g' /etc/nginx/conf.d/alone.conf
sed -i 's/ddd/$http_upgrade/g' /etc/nginx/conf.d/alone.conf
sed -i 's/eee/$http_host/g' /etc/nginx/conf.d/alone.conf
sed -i 's/fff/"upgrade"/g' /etc/nginx/conf.d/alone.conf

# // Certv2ray
# generate certificates
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --server https://api.buypass.com/acme/directory \
        --register-account  --accountemail vinstechmyprojectvps@gmail.com
/root/.acme.sh/acme.sh --server https://api.buypass.com/acme/directory --issue -d $domain --standalone -k ec-256			   
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /usr/local/etc/xray/xray.crt --keypath /usr/local/etc/xray/xray.key --ecc

# // Boot Nginx
mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
systemctl daemon-reload
service nginx restart
cd
