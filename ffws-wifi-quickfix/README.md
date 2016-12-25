Workaround for WIFI stop working
================================

Idee:  Wifi-Scan oder Neustart, wenn keine clients und keine Meshes mehr vorhanden, aber mal da waren

Hilfreich:

  iw dev client0 station dump       // WLAN Nachbarn mit Details
  
  iw dev mesh0 station dump | grep -e "^Station " | awk '{ print $2 }  //mesh nachbarn auflisten
  
  iw dev client0 station dump | grep -e "^Station " | awk '{ print $2 }  //wifi clients auflisten

  fix: iw dev mesh0 scan

offen:
  ist client0 immer 2,4 GHz wifi ?
