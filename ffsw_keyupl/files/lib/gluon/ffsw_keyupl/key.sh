#!/bin/sh

# this script will upload the nodes fastd key to the gateway server
# provided as the first argument ($1)

UPLOAD_URL=http://services.freifunk-suedwest.de/keyupload.php
WGETC=$(which wget)

MAC=$(sed 's/://g' /lib/gluon/core/sysconfig/primary_mac)
NODE=$(uci get system.@system[0].hostname)
OWNER=$(uci get gluon-node-info.@owner[0].contact)

$WGETC -O - -q "$UPLOAD_URL?mac=${MAC}&node=${NODE}&owner=${OWNER}" &>/dev/null

exit 0