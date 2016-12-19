ssid-changer
============

Script to change the SSID when there is no suffic sufficient connection to the selected Gateway.

It is quite basic, it just checks the Quality of the Connection and decides if a change of the SSID is necessary.

SSID is changed to original-ssid + "(inaktiv)", if the connection is below the lower-limit. 
If the connection is above the upper limit the SSID is changed back to the original SSID (wireless.client_radio0.ssid) 

-------------------
Update:
No more connection quality limits are used to decide if offline. SSID depends on at least one gateway in range.
