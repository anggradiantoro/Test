#!/bin/bash
# Script By Vinstechmy
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo "Autoscript By Vinstechmy"
echo ""
uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /usr/local/etc/xray/domain)
xtr="$(cat ~/log-install.txt | grep -w "TROJAN TCP TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		user_EXISTS=$(grep -w $user /usr/local/etc/xray-mini/trojan.json | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			exit 1
		fi
	done
read -p "Expired (days): " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#tr$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'"' /usr/local/etc/xray-mini/trojan.json
trojanlink="trojan://${uuid}@${domain}:${xtr}?security=tls&type=tcp&allowInsecure=1&sni=bug.com#XRAY_TROJAN_TCP_${user}"
# // Restarting Service
systemctl restart xray-mini@trojan
service cron restart
clear
echo -e ""
echo -e "════════════[XRAY TROJAN TCP]════════════"
echo -e "Remarks           : ${user}"
echo -e "Domain            : ${domain}"
echo -e "Port              : ${xtr}"
echo -e "Key               : ${uuid}"
echo -e "Network           : Tcp"
echo -e "Security          : Tls"
echo -e "AllowInsecure     : True"
echo -e "═════════════════════════════════════════"
echo -e "Link XRAY Trojan  : ${trojanlink}"
echo -e "═════════════════════════════════════════"
echo -e "Created On        : $hariini"
echo -e "Expired On        : $exp"
echo -e "═════════════════════════════════════════"
echo -e ""
echo -e "Autoscript By Vinstechmy"
echo -e ""

