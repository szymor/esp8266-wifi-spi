# esp8266-wifi-spi
WiFi-SPI converter eLua script for NodeMCU on ESP8266

Upload init.lua to your device and enjoy!

Script needs preconfiguration, i.e. you need to set your network's SSID and password. The device connects to a server, then it simply forwards bytes in both directions (full duplex). The device works as a SPI master. Reconnection to the server is supported.

Default SPI speed is 10 MHz.
