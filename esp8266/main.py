import network
import time
from umqtt.simple import MQTTClient
from machine import Pin, I2C
import dht
import ssd1306

# OLED connection
i2c = I2C(scl=Pin(4), sda=Pin(5), freq=100000)
display = ssd1306.SSD1306_I2C(128, 64, i2c)

# Sensor connection
d = dht.DHT22( Pin(12) )

# build-in led
led = Pin(2, Pin.OUT)

###############################################
#ssid = 'Phonehotspot'
#password = 'hotspotpassword'
ssid = '@LINPHA-WIFI_2.4GHz'
password = ''
###############################################

# 1 Connect WIFI
station = network.WLAN(network.STA_IF)
station.active(True)

# Show connection status
display.text('Connecting...', 0, 0, 1)
display.text(ssid, 0, 10, 1)
display.text(password, 0, 20, 1)
display.show()


if not station.isconnected():
    print("Connecting...")
    station.connect(ssid, password)
    while not station.isconnected():
        pass
print(station.ifconfig()[0])

display.text('Connected', 0, 30, 1)
display.text(station.ifconfig()[0], 0, 40, 1)
display.show()


# 2 Connect Broker
client_id   = "a4818d92-da7e-4cc3-b49a-8468cfb67b24"
username    = ""
password    = ""

topic       = bytes("/nacademy", "utf-8")

#SERVER = "mqtt.netpie.io"
SERVER = "broker.hivemq.com"


client = MQTTClient(
    client_id,
    SERVER, user=username,
    password=password
)

#3 Publish data to broker
client.connect()


def sub_cb(topic, msg):
    print(topic, msg)
    if (msg == b"ON"):
        led.off()
        client.publish(b"/nacademy/status", b"ON")
    else:
        led.on()
        client.publish(b"/nacademy/status", b"OFF")
    
    
client.set_callback(sub_cb)
client.subscribe(topic, qos=1)


while True:
    try:
        client.wait_msg()
        time.sleep(1)
    except OSError as e:
        print(e)
 
