Workaround for WIFI stop working
================================

Wifi-Scan , wenn keine clients und keine Meshes mehr vorhanden, aber mal da waren

Umsetzung:
	Wenn es WIFI-Verbundungen (Client/Mesh/PrivateWiFi) gab, und keine mehr gibt, 
	dann WIFI-Scan durchführen
	
	zusätzlich Reboot bei folgenden Bedingungen:
		-respondd läuft nicht, oder
		-dropbbear läuft nicht, oder
		-Kernel (batman) error aufgetreten


Anm.: 
	Problem tritt nur bei 2,4GHz auf
	ein "iw dev mesh0/1 scan" behebt das Problem
	
	2,4Ghz Erkennung nötig wg:
	z.B. Archer C5: client1 = 2,4 GHz
	     WDR4300: client0 = 2,4 GHz


hilfreich:

  iw dev client0 station dump       // WLAN Nachbarn mit Details
  
  iw dev mesh0 station dump | grep -e "^Station " | awk '{ print $2 }  //mesh nachbarn auflisten
  
  iw dev client0 station dump | grep -e "^Station " | awk '{ print $2 }  //wifi clients auflisten

  fix: iw dev mesh0 scan
