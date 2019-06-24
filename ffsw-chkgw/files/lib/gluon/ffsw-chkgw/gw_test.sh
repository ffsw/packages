cat /proc/uptime |cut -d' ' -f2 |cut -d'.' -f1 > /tmp/uptime.txt
UT=$(cat /tmp/uptime.txt)
soll="3600"

if [ $UT -gt $soll ]
then
	ping -c 2 -v6 2a03:2260:300c:300::b > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		logger -t "ping SVC not ok"
		ping -c 2 -v6 2a03:2260:300c:300::4> /dev/null 2>&1
		if [ $? -ne 0 ]
		then
			logger -t chkgw "ping GW4 not ok"
			ping -c 2 -v6 2a03:2260:300c:300::5> /dev/null 2>&1
			if [ $? -ne 0 ]
			then
				logger -t chkgw "ping GW5 not ok"			
				ping -c 2 -v6 2a03:2260:300c:300::6 > /dev/null 2>&1
				if [ $? -ne 0 ]
				then
					logger -t chkgw "ping GW06 not ok - rebooting"
					reboot
				fi
			fi
		fi
	fi
else
	logger -t chkgw uptime $UT
fi
