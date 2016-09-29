#!/bin/sh

# this script will download the reboot conf
# over mysql database of svc

DOWNLOAD_URL=http://services.freifunk-suedwest.de/reboot.php
WGETC=$(which wget)
changed=0

MAC=$(sed 's/://g' /lib/gluon/core/sysconfig/primary_mac)

$WGETC -O - -q "$DOWNLOAD_URL?id=${MAC}" > /tmp/reboot.conf

read reboot < /tmp/reboot.conf
echo "$reboot"

if [ $reboot = 1 ]; then
rm /tmp/reboot.conf
reboot
fi
exit 0




