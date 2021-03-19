#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

xray_qr_config_file="/usr/local/vmess_qr.json"
domain=$(grep '\"add\"' $xray_qr_config_file | awk -F '"' '{print $4}')

systemctl stop nginx &> /dev/null
sleep 1
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /dev/null
"/root/.acme.sh"/acme.sh --installcert -d ${domain} --fullchainpath /data/xray.crt --keypath /data/xray.key --ecc
sleep 1
cert_group="nobody"
idleleo_commend_file="/usr/bin/idleleo"
if [[ $(grep "nogroup" /etc/group) ]]; then
    cert_group="nogroup"
fi
chmod -f a+rw /data/xray.crt
chmod -f a+rw /data/xray.key
chown -R nobody:${cert_group} ${idleleo_commend_file}/data/*
sleep 1
systemctl start nginx &> /dev/null
