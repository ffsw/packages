Workaround for WIFI stop working
================================

Idee:  Wifi-Scan oder Neustart, wenn keine clients und keine Meshes mehr vorhanden, aber mal da waren

Umsetztung:
	Wenn es WIFI-Verbundungen (Client/Mesh) gab, und keine mehr gibt, 
	dann WIFI-Scan durchführen
	
	zusätzlich REboot bei folgenden Bedingungen:
		-respondd läuft nicht, oder
		-dropbbear läuft nicht, oder
		-Kernel (batman) error aufgetreten

ToDo: 
	Dualband 2,4Ghz Erkennung !
	z.B. Archer C5: client0=5GHz, client1=2,4GHz


hilfreich:

  iw dev client0 station dump       // WLAN Nachbarn mit Details
  
  iw dev mesh0 station dump | grep -e "^Station " | awk '{ print $2 }  //mesh nachbarn auflisten
  
  iw dev client0 station dump | grep -e "^Station " | awk '{ print $2 }  //wifi clients auflisten

  fix: iw dev mesh0 scan

offen:
  ist client0 immer 2,4 GHz wifi ?
