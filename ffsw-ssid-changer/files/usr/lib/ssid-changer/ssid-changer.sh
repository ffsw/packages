#!/bin/sh


# TS: Offline nicht durch Prefix sondern durch Postfix hiner der normalen SSID kennzeichnen
# 01.12.16 TS: Offline-Auswertung vereinfacht -> wenn kein gw vorhanden
# 24.01.18 TS: Parameter "-q" bei uci get an den Anfang verschoben - funzt sonst bei LEDE nicht
# 24.01.18 TS: Schreibfehler in offline-ssid korrigiert und mx Länge auf 32 erhöht

MINUTES=1 # only once every timeframe the SSID will change to OFFLINE (set to 1 minute to change every time the router gets offline)
ONLINE_SSID=$(uci -q get wireless.client_radio0.ssid)
: ${ONLINE_SSID:=FREIFUNK}   # if for whatever reason ONLINE_SSID is NULL
OFFLINE_POSTFIX='(inaktiv)' # Use something short to leave space for the nodename

# TS: Offline SSID aus Online SSID und Postfix generieren
if [ ${#ONLINE_SSID} -gt $((28 - ${#OFFLINE_POSTFIX})) ] ; then #32 would be possible as well
	REST=$(( (32 - ${#OFFLINE_POSTFIX} )  )) #calculate the length of the first part of the SSID in the offline-ssid	
	OFFLINE_SSID=${ONLINE_SSID:0:$REST}$OFFLINE_POSTFIX # erste Zeichen von SSID + Postifx
else
	OFFLINE_SSID="$ONLINE_SSID$OFFLINE_POSTFIX" #passt kommplett
fi
echo "$ONLINE_SSID or $OFFLINE_SSID"

# maximum simplified, no more ttvn rating
CHECK=$(batctl gwl -H|grep -v "gateways in range"|wc -l)
HUP_NEEDED=0
if [ $CHECK -gt 0 ]; then
	echo "node is online"
	for HOSTAPD in $(ls /var/run/hostapd-phy*); do # check status for all physical devices
	CURRENT_SSID="$(grep "^ssid=$ONLINE_SSID" $HOSTAPD | cut -d"=" -f2)"
	if [ "$CURRENT_SSID" == "$ONLINE_SSID" ]
	then
		echo "SSID $CURRENT_SSID is correct, nothing to do"
		break
	fi
	CURRENT_SSID="$(grep "^ssid=$OFFLINE_SSID" $HOSTAPD | cut -d"=" -f2)"
	if [ "$CURRENT_SSID" == "$OFFLINE_SSID" ]; then
		logger -s -t "gluon-offline-ssid" -p 5 "SSID is $CURRENT_SSID, change to $ONLINE_SSID"
		sed -i "s~^ssid=$CURRENT_SSID~ssid=$ONLINE_SSID~" $HOSTAPD
		HUP_NEEDED=1 # HUP here would be to early for dualband devices
	else
		echo "There is something wrong, did not find SSID $ONLINE_SSID or $OFFLINE_SSID"
	fi
done
elif [ $CHECK -eq 0 ]; then
	echo "node is considered offline"
	if [ $(expr $(date "+%s") / 60 % $MINUTES) -eq 0 ]; then
		for HOSTAPD in $(ls /var/run/hostapd-phy*); do
  		CURRENT_SSID="$(grep "^ssid=$OFFLINE_SSID" $HOSTAPD | cut -d"=" -f2)"
  		if [ "$CURRENT_SSID" == "$OFFLINE_SSID" ]; then
  			echo "SSID $CURRENT_SSID is correct, noting to do"
  			break
  		fi
  		CURRENT_SSID="$(grep "^ssid=$ONLINE_SSID" $HOSTAPD | cut -d"=" -f2)"
  		if [ "$CURRENT_SSID" == "$ONLINE_SSID" ]; then
  			logger -s -t "gluon-offline-ssid" -p 5 "SSID is $CURRENT_SSID, change to $OFFLINE_SSID"
  			sed -i "s~^ssid=$ONLINE_SSID~ssid=$OFFLINE_SSID~" $HOSTAPD
  			HUP_NEEDED=1
  		else
  			echo "There is something wrong: did neither find SSID '$ONLINE_SSID' nor '$OFFLINE_SSID'"
  		fi
		done
	fi
fi

if [ $HUP_NEEDED == 1 ]; then
	killall -HUP hostapd # send HUP to all hostapd to load the new SSID
	HUP_NEEDED=0
	echo "HUP!"
fi
