#!/bin/bash
# Script By Vinstechmy
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
echo "Autoscript By Vinstechmy"
echo ""
domain=$(cat /usr/local/etc/xray/domain)
uuid=$(cat /proc/sys/kernel/random/uuid)
xrtr="$(cat ~/log-install.txt | grep -w "TROJAN TCP XTLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/akunxtrojan.conf | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /usr/local/etc/xray/akunxtrojan.conf
sed -i '/#trojan-xtls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "xtls-rprx-direct","email": "'""$user""'"' /usr/local/etc/xray/xtrojan.json

trojanlink1="trojan://${uuid}@${domain}:${xrtr}?allowInsecure=1&security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug.com#XRAY_TROJAN_DIRECT_${user}"
trojanlink2="trojan://${uuid}@${domain}:${xrtr}?allowInsecure=1&security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct-udp443&sni=bug.com#XRAY_TROJAN_DIRECTUDP443_${user}"
trojanlink3="trojan://${uuid}@${domain}:${xrtr}?allowInsecure=1&security=xtls&headerType=none&type=tcp&flow=xtls-rprx-splice&sni=bug.com#XRAY_TROJAN_SPLICE_${user}"
trojanlink4="trojan://${uuid}@${domain}:${xrtr}?allowInsecure=1&security=xtls&headerType=none&type=tcp&flow=xtls-rprx-splice-udp443&sni=bug.com#XRAY_TROJAN_SPLICEUDP443_${user}"

systemctl restart xray@xtrojan
service cron restart
clear
echo -e ""
echo -e "════════════[XRAY TROJAN TCP XTLS]════════════"
echo -e "Remarks              : ${user}"
echo -e "Domain               : ${domain}"
echo -e "Password             : ${uuid}"
echo -e "Port Direct          : ${xrtr}"
echo -e "Port Splice          : ${xrtr}"
echo -e "Encryption           : None"
echo -e "Network              : TCP"
echo -e "Security             : XTLS"
echo -e "Flow                 : Direct & Splice"
echo -e "AllowInsecure        : True/Allow"
echo -e "══════════════════════════════════════════════"
echo -e "Link Direct          : ${trojanlink1}"
echo -e "══════════════════════════════════════════════"
echo -e "Link Direct UDP 443  : ${trojanlink2}"
echo -e "══════════════════════════════════════════════"
echo -e "Link Splice          : ${trojanlink3}"
echo -e "══════════════════════════════════════════════"
echo -e "Link Splice UDP 443  : ${trojanlink4}"
echo -e "══════════════════════════════════════════════"
echo -e "Created On           : $hariini"
echo -e "Expired On           : $exp"
echo -e "══════════════════════════════════════════════"
echo -e ""
echo -e "Autoscript By Vinstechmy"
echo -e ""