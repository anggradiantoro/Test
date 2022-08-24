#!/bin/bash
# Script By Vinstechmy
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo -e "Autoscript By Vinstechmy"
echo -e ""
domain=$(cat /usr/local/etc/xray/domain)

# // Vless
xtls="$(cat ~/log-install.txt | grep -w "VLESS TCP XTLS" | cut -d: -f2|sed 's/ //g')"

until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/xtls.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			exit 1
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`

# // Input To Server
sed -i '/#xtls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","flow": "xtls-rprx-direct","email": "'""$user""'"' /usr/local/etc/xray/xtls.json

vless_direct1="vless://${uuid}@${domain}:${xtls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug.com#XRAY_VLESS_DIRECT_$user"
vless_direct2="vless://${uuid}@${domain}:${xtls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct-udp443&sni=bug.com#XRAY_VLESS_DIRECTUDP443_$user"
vless_splice3="vless://${uuid}@${domain}:${xtls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-splice&sni=bug.com#XRAY_VLESS_SPLICE_$user"
vless_splice4="vless://${uuid}@${domain}:${xtls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-splice-udp443&sni=bug.com#XRAY_VLESS_SPLICEUDP443_$user"

# // Restarting Service
systemctl restart xray@xtls
service cron restart
clear
echo -e ""
echo -e "════════════[XRAY VLESS TCP XTLS]════════════"
echo -e "Remarks              : ${user}"
echo -e "Domain               : ${domain}"
echo -e "ID                   : ${uuid}"
echo -e "Port Direct          : ${xtls}"
echo -e "Port Splice          : ${xtls}"
echo -e "Encryption           : None"
echo -e "Network              : TCP"
echo -e "Security             : XTLS"
echo -e "Flow                 : Direct & Splice"
echo -e "AllowInsecure        : True/Allow"
echo -e "═════════════════════════════════════════════"
echo -e "Link Direct          : ${vless_direct1}"
echo -e "═════════════════════════════════════════════"
echo -e "Link Direct UDP 443  : ${vless_direct2}"
echo -e "═════════════════════════════════════════════"
echo -e "Link Splice          : ${vless_splice3}"
echo -e "═════════════════════════════════════════════"
echo -e "Link Splice UDP 443  : ${vless_splice4}"
echo -e "═════════════════════════════════════════════"
echo -e "Created On           : $hariini"
echo -e "Expired On           : $exp"
echo -e "═════════════════════════════════════════════"
echo -e ""
echo -e "Autoscript By Vinstechmy"
echo -e ""