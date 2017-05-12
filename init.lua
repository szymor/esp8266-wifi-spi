WIFI_SSID = "urSsid"
WIFI_PASSWORD = "wifiPass"
WIFI_HOSTNAME = "wifi-spi-esp"
SERVER_PORT = 57005
SERVER_IP = "192.168.1.6"

wifi.setmode(wifi.STATION, false) 
wifi.setphymode(wifi.PHYMODE_B)
wifi.sta.config(WIFI_SSID, WIFI_PASSWORD)
wifi.sta.sethostname(WIFI_HOSTNAME)
wifi.sta.connect()

spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 80, spi.FULLDUPLEX)

-- GPIO 4
gpio.mode(2, gpio.OUTPUT)

socket_connected = false
gpio.write(2, gpio.HIGH)

function rcv(sck, data)
    local x, y
    print("Rcv:", data)
    x, y = spi.send(1, data)
    socket:send(y)
    print("Snt:", y)
end

function conn(sck)
    socket_connected = true
    gpio.write(2, gpio.LOW)
    comtimer:stop()
end

function disc(sck, err)
    socket_connected = false
    gpio.write(2, gpio.HIGH)
    comtimer:start()
end

function ctcb(timer)
    print("Reconnection...")
    if not socket_connected then
        socket = net.createConnection(net.TCP, 0)
        socket:on("connection", conn)
        socket:on("disconnection", disc)
        socket:on("receive", rcv)
        socket:connect(SERVER_PORT, SERVER_IP)
    end
end

comtimer = tmr.create()
comtimer:register(1000, tmr.ALARM_AUTO, ctcb)
comtimer:start()
