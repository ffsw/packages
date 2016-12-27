#!/bin/sh
#
#  Wenn kein WIFI-MESH und kein WIFI-Client, aber es schon mal gab,
#   dann WIFI-Scan durchführen (betrifft alles nur 2,4GHz)
#
# zusätzlich:
#	Reboot, wenn respondd oder dropbear nicht laufen
#	Reboot, wenn es kernel (batman) error gab
#

# find 2.4 GHz MESH Device 
if iw dev mesh0 info | grep -q "2... MHz"; then
   DEVm=mesh0   
else
   if iw dev mesh1 info | grep -q "2... MHz"; then
      DEVm=mesh1
   else
      echo no 2.4 GHz mesh device found
      exit 2
   fi
fi

# find 2.4 GHz CLIENT Device 
if iw dev client0 info | grep -q "2... MHz"; then
   DEVc=client0   
else
   if iw dev client1 info | grep -q "2... MHz"; then      
	  DEVc=client1
   else
      echo no 2.4 GHz client device found
      exit 2
   fi
fi

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

# if the router started less than 30 minutes ago, exit
if [ $(cat /proc/uptime | sed 's/\..*//g') -lt 1800 ]; then
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
	exit
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
	logger -s -t "wifi-quickfix" -p 5 "neighbours lost, running iw scan"
	iw dev $DEVm scan >/dev/null
}

MESHFILE="/tmp/wifi-mesh-connection-active"
CLIENTFILE="/tmp/wifi-ff-client-connection-active"
PRIVCLIENTFILE="/tmp/wifi-priv-client-connection-active"
RESTARTINFOFILE="/tmp/wifi-last-restart-marker-file"

# check if there are connections to other nodes via wireless meshing
WIFIMESHCONNECTIONS=0
if [ "$(batctl o | egrep "($DEVm)]" | wc -l)" -gt 0 ]; then
	WIFIMESHCONNECTIONS=1
	echo "found wifi mesh partners."
	if [ ! -f "$MESHFILE" ]; then
		# create file so we can check later if there was a wifi mesh connection before
		touch $MESHFILE
	fi
fi

# check if there are local wifi clients
WIFIFFCONNECTIONS=0
if iw dev $DEVc station dump | grep -q -e "^Station "; then
	WIFIFFCONNECTIONS=1
	echo "found wifi clients."
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


