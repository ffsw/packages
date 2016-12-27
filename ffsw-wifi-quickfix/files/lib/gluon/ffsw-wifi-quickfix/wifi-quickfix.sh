#!/bin/sh
#
#  Wenn kein WIFI-MESH und kein WIFI-CLient, aber es schon mal gab,
#   dann WIFI-Scan durchführen
#
#	Reboot, wenn respondd oder dropbear nicht laufen
#	Reboot, wenn es kernel (batman) error gab
#

# find MESH Device 
DEV="$(iw dev|grep Interface|grep -e 'mesh0' -e 'ibss0'| awk '{ print $2 }')"

#################
# safety checks #
#################

safety_exit() {
	echo safety checks failed, exiting with error code 2
	exit 2
}

# if autoupdater is running, exit
pgrep autoupdater >/dev/null
if [ "$?" == "0" ]; then
	echo "autoupdater is running, aborting."
	safety_exit
fi

# if the router started less than 5 minutes ago, exit
if [ $(cat /proc/uptime | sed 's/\..*//g') -lt 300 ]; then
	echo "runtime too short, aborting."
	safety_exit
fi	

###########
# reboots #
###########

reboot() {
	logger -s -t "wifi-quickfix" -p 5 "rebooting... reason: $@"
	# push log to server here (nyi)
	/sbin/reboot # comment out for debugging purposes
}

# if respondd or dropbear not running, reboot (probably ram was full, so more services might've crashed)
pgrep respondd >/dev/null || reboot "respondd not running"
pgrep dropbear >/dev/null || reboot "dropbear not running"

# reboot if there was a kernel (batman) error
# for example gluon issue #680
dmesg | grep "Kernel bug" >/dev/null && reboot "gluon issue #680"



# check if node has wifi
if [ ! -L /sys/class/ieee80211/phy0/device/driver ] && [ ! -L /sys/class/ieee80211/phy1/device/driver ]; then
		echo "node has no wifi, aborting."
		safety_exit
	exit
fi

echo safety checks done, continuing...

#########
# fixes #
#########

scan() {
	logger -s -t "wifi-quickfix" -p 5 "neighbour lost, running iw scan"
	iw dev $DEV scan >/dev/null
}

MESHFILE="/tmp/wifi-mesh-connection-active"
CLIENTFILE="/tmp/wifi-ff-client-connection-active"
PRIVCLIENTFILE="/tmp/wifi-priv-client-connection-active"
RESTARTINFOFILE="/tmp/wifi-last-restart-marker-file"

# check if there are connections to other nodes via wireless meshing
WIFIMESHCONNECTIONS=0
if [ "$(batctl o | egrep "($DEV)]" | wc -l)" -gt 0 ]; then
	WIFIMESHCONNECTIONS=1
	echo "found wifi mesh partners."
	if [ ! -f "$MESHFILE" ]; then
		# create file so we can check later if there was a wifi mesh connection before
		touch $MESHFILE
	fi
fi

# check if there are local wifi batman clients
WIFIFFCONNECTIONS=0
if [ "$(batctl tl | grep W | wc -l)" -gt 0 ]; then
	# note: this doesn't help if the clients are on 5GHz, which might be unaffected by the bug
	WIFIFFCONNECTIONS=1
	echo "found batman local clients."
	if [ ! -f "$CLIENTFILE" ]; then
		# create file so we can check later if there were batman local clients before
		touch $CLIENTFILE
	fi
fi

# check for clients on private wifi device
WIFIPRIVCONNECTIONS=0
PIPE=$(mktemp -u -t workaround-pipe-XXXXXX)
mkfifo $PIPE
iw dev | grep "Interface wlan" | cut -d" " -f2 > $PIPE &
while read wifidev; do
	iw dev $wifidev station dump 2>/dev/null | grep -q Station
	if [ "$?" == "0" ]; then
		WIFIPRIVCONNECTIONS=1
		echo "found private wifi clients."
		if [ ! -f "$PRIVCLIENTFILE" ]; then
			# create file so we can check later if there were private wifi clients before
			touch $PRIVCLIENTFILE
		fi
		break
	fi
done < $PIPE
rm $PIPE


WIFIRESTART=0
if [ "$WIFIMESHCONNECTIONS" -eq 0 ] && [ "$WIFIPRIVCONNECTIONS" -eq 0 ] && [ "$WIFIFFCONNECTIONS" -eq 0 ]; then
	if [ -f "$MESHFILE" ] || [ -f "$CLIENTFILE" ] || [ -f "$PRIVCLIENTFILE" ]; then
		# no wifi connections but there was one before
		WIFIRESTART=1
	fi
fi

if  [ "$WIFIRESTART" -eq 1 ]; then
	echo "restarting wifi."
	rm -f $MESHFILE
	rm -f $CLIENTFILE
	rm -f $PRIVCLIENTFILE
	touch $RESTARTINFOFILE
	#wifi
	scan
fi


