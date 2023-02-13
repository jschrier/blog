---
Title: "MQTT and ROS2 integration"
Date: 2023-02-10
Tags: ros, ros2, microros raspberrypi, pico, electronics, automation 
---
[My previous failure to successfully compile micro-ros-agent]({{ site.baseurl }}{% post_url 2023-02-04-ROS-Setup-For-Raspberry-Pi-and-Pico %}) illustrates some of the challenges of setting up ROS2 in constrained environments.  First, ROS2 is really complicated  to install and restricts us to running on Ubuntu, which might make it hard to do fancy hardware stuff on the Raspberry Pi host that would be easier in Raspbian.
Second, if we want to use micro-ros on our microcontroller (e.g., pico) , we're back to programming in C/C++, which increases the barrier for students. Third, you need more than 1GB of RAM on the Pi 3B+ to compile the micro-ros-agent that serves as a bridge between these functionalities.  **How can we keep the advantages of the ROS Publish/Subscribe model, but simplify our microcontroller development and interfacing?** *In this post, we'll look at using MQTT as a lightweight publish/subscribe service and how it can be interfaced with ROS2...*

# What is MQTT and why?

[MQTT](https://en.wikipedia.org/wiki/MQTT) is a light-weight publish-subscribe, machine to machine network protocol for message queue/message queuing service. It is designed for connections with remote locations that have devices with resource constraints or limited network bandwidth.  [The MQTT protocol](https://mqtt.org) defines two types of network entities: a *message broker* and a *number of clients*. The broker is a server that receives all messages from the clients and then routes the messages to the appropriate destination clients. Clients can be any device than can connect to a broker.  By default MQTT uses TCP for data transmission; a variant, MQTT-SN, can use UDP or Bluetooth.  [Lots of industrial uses examples, etc.](https://mqtt.org/use-cases/)  
* Hackaday had a [tutorial on MQTT back in 2016](https://hackaday.com/series_of_posts/minimal-mqtt/) and a [bunch of projects using MQTT since then](https://hackaday.com/tag/mqtt/)
* There are [MQTT client apps for your favorite iDevices](https://www.easymqtt.app)
* There's an ecosystem of services for processing MQTT messages, such as building dashboards with [Streamsheets](https://projects.eclipse.org/projects/iot.streamsheets). You might even be able to [use it with Mathematica](https://mathematica.stackexchange.com/questions/269995/channel-based-communication-and-mqtt) ([example](https://community.wolfram.com/groups/-/m/t/1818557)) 
* **MQTT is natively supported by MicroPython.** That is, it is part of [micropython-lib](https://github.com/micropython/micropython-lib), specifically: [umqtt.simple](https://github.com/micropython/micropython-lib/tree/master/micropython/umqtt.simple) and [umqtt.robust](https://github.com/micropython/micropython-lib/tree/master/micropython/umqtt.robust). Only QoS 0 and 1 are supported; the latter adds auto-reconnect to handle networking errors gracefully.  This is great, because it will let us do development on the microcontroller in python, rather than the C++ needed for micro-ros

# Setting up a MQTT+ROS2 bridge

But how do we set it up?  We'll use the [Eclipse Mosquitto broker](https://mosquitto.org) 
[Robofoundry has a Sept 2022 demo](https://robofoundry.medium.com/combining-ros2-and-mqtt-on-esp32-to-send-twist-messages-bab758cf098) which we'll follow along with as well as the [mosquitto documentation](https://mosquitto.org/documentation/using-the-snap/) and the [mqtt-bridge ros2](https://github.com/groove-x/mqtt_bridge/tree/ros2) docuemntation.  
The latter takes care of the serialization of ROS2 standard messages for us. 

0. We've [already got a RPi 3B+ setup with Ubuntu 20.04 and ROS2/Humble]({{ site.baseurl }}{% post_url 2023-02-04-ROS-Setup-For-Raspberry-Pi-and-Pico %}) 
1. We're running Ubuntu so we can [use a snap to install mosquitto]((https://mosquitto.org/documentation/using-the-snap/))---alternatively, instructions for [installing on Raspbian can be found elsewhere](https://peppe8o.com/mqtt-and-raspberry-pi-pico-w-start-with-mosquitto-micropython/)
```bash
sudo snap install mosquitto
```
After installing the Mosquitto snap, the Mosquitto broker will be running with the default configuration, which means it is listening for connections on port 1883 on the local computer only.  We'll configure the connection later.
2. Test the broker:  In one terminal test the subscriber by running:
`mosquitto_sub -h localhost -t 'snap/example' -v` . (The `-t snap/example` option sets the topic to subscribe to, and can be provided multiple times.  `#` or `+` can be used for wildcards, and `$SYS/#` allows you to see topics that the broker publishes about itself. The `-v` option means to print both the topic of the message as well as its payload.) Open up another terminal window and run `mosquitto_pub -h localhost -t 'snap/example' -m 'Hello world!'`  You should see the message get transferred. (`-m` indicates the message to get published on the topic).
3. Once you have finished your testing, you will want to configure your broker to have encrypted connections and use authentication, possibly configuring bridges, which allow different brokers to share topics, or many other options.  To do this: 
```bash
# create and edit config file for mosquitto broker like this
sudo cp /var/snap/mosquitto/common/mosquitto_example.conf /var/snap/
mosquitto/common/mosquitto.conf
# edit the moquitto.conf file as desired...

# stop and start broker as needed
sudo systemctl stop snap.mosquitto.mosquitto.service
sudo systemctl start snap.mosquitto.mosquitto.service
```
4. Install the `mqtt_bridge`
```bash
# setup pre-reqs...
sudo apt-get install python3-pip  # should already have this
sudo apt-get install ros-humble-rosbridge-library
sudo apt-get install mosquitto mosquitto-clients #only if you haven't used the snap above 

# install the bridge
git clone -b ros2 --single-branch https://github.com/groove-x/mqtt_bridge.git
cd mqtt_bridge
pip3 install -r requirement.txt
source /opt/ros/humble/setup.bash 
colcon build # throws an innocuous stderr about a deprecated library
```
5. Test the `mqtt_bridge`.  In a new terminal window run the bridge:
```bash
cd mqtt_bridge
source /opt/ros/humble/setup.bash
source install/local_setup.bash
ros2 launch mqtt_bridge demo.launch.py &
```
This creates interfaces `/ping` and `/pong` which respond to booleans.  
The details of how these get bridged from MQTT to/from ROS are described in the configuration file `mqtt_bridge/config/demo_params.yaml`.
In another terminal window, use mosquitto to watch for MQTT messages:
```bash
mosquitto_sub -t '#' -v  # look ma! no ROS setups sourced!
```
In another terminal window, publish a ROS message...it should show up in our mosquitto subscriber terminal:
```bash
source /opt/ros/humble/setup.bash
ros2 topic pub /ping std_msgs/Bool "data: true"
```
We can see the same message show up in ROS as well if we run the following:
```bash
source /opt/ros/humble/setup.bash
 ros2 topic echo /pong
```
Stop the ros2 publisher and mosquitto subscribers.  And then try the following:
```bash
mosquitto_pub -t 'ping' -m '{"data":false}'
```
This should show up in your ros2 pong subscriber! Warnings: the mqtt_bridge is a bit fragile.  The messages have to be validly formatted JSON for this to work, and if they are not, you'll crash the bridge. 
Other ros data types are also supported, e.g., this demo server also has a channel back that reports strings:
```bash
ros2 topic echo /back  #look for things on the echo topic
``` 
The input channel is called echo:
```bash
mosquitto_pub -t 'echo' -m '{"data": "foo"}'
```

# Publishing MQTT from a Pico to ROS

(We'll largely follow [a tutorial by peppe80](https://peppe8o.com/mqtt-and-raspberry-pi-pico-w-start-with-mosquitto-micropython/), which walks through installing and configuring mosquitto on the Raspberry Pi and running the MQTT code on the Pico W.) 

5. Until now, we've only used MQTT within a given localhost. We need to open it up to the world.  Edit `/var/snap/mosquitto/common/mosquitto.conf` to add the following two lines:
```
allow_anonymous true
listener 1883
```
Then restart the mosquitto server so these changes take place:
```bash
sudo systemctl stop snap.mosquitto.mosquitto.service
sudo systemctl start snap.mosquitto.mosquitto.service
```

6. We'll use a Raspberry Pi Pico W.  If you haven't already loaded micropython onto the device, then [grab the micropython uf2 file for the Pico W](https://micropython.org/download/rp2-pico-w/) and [flash it to the pico](https://www.tomshardware.com/how-to/raspberry-pi-pico-setup). I'll use `v1.19.1-859-g41ed01f13 (2023-02-09).uf2` 

7. Assuming that you are using Thonny: Install `micropython-umqtt.simple` by going to the *Tools>Manage Packages...* menu.  Then run the following program on your PicoW.  Be sure to set the WIFI SSID and PASSWORD values appropriately.  You can look up the IP address of your mosquitto server by running `hostname -I` on the host:

```python
import network
import time
from umqtt.simple import MQTTClient

WIFI_SSID = "#YOUR WIFI SSID"
WIFI_PWD = "#YOUR PASSWORD"

wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(WIFI_SSID, WIFI_PWD)
time.sleep(5)
print("Connected to WIFI?", wlan.isconnected())

mqtt_server = '#YOUR SERVER IP'
client_id = 'pico'
topic_pub = b'ping'
topic_msg = b'{"data":false}'

def mqtt_connect():
    client = MQTTClient(client_id, mqtt_server, keepalive=3600)
    client.connect()
    print('Connected to %s MQTT Broker'%(mqtt_server))
    return client

def reconnect():
    print('Failed to connect to the MQTT Broker. Reconnecting...')
    time.sleep(5)
    machine.reset()

try:
    client = mqtt_connect()
except OSError as e:
    reconnect()
while True:
    print('publishing topic: ', topic_pub, topic_msg)
    client.publish(topic_pub, topic_msg)
    time.sleep(1)
```  

 8. You should be able to see these as MQTT messages on the Pi by `mosquitto_sub -t 'ping'`.  You should also be able to see these as ROS2 topic messages by `ros2 topic echo pong` (Assuming that you're still running the `mqtt_bridge` discussed above...if not then run it).  **Congratulations, you've now successfully used the Pico W as a publisher**

# TODO: Subscribing to ROS messages via MQTT on the Pico W
 
 9. **TODO: Demonstrate PicoW as subscriber** (instructions)[https://peppe8o.com/mqtt-and-raspberry-pi-pico-w-start-with-mosquitto-micropython/]

# Other passing notes

* In principle you can also create a [TTY/MQTT bridge](https://www.metacodes.pro/funcodes/using_tty2mqtt_to_bridge_between_serial_communication_and_mqtt/) that would let us connect USB devices to MQTT to ROS...
* An alternative to using MQTT would be to use the [ROSBridgeSuite](https://wiki.ros.org/rosbridge_suite) which lets you send JSON/Websocket commands to and from ROS.  [ROSBridgeSuite](https://github.com/RobotWebTools/rosbridge_suite) is the modern version of the [ros2-web-bridge](https://github.com/RobotWebTools/ros2-web-bridge) used in the [hadabot](https://www.hadabot.com) project. `mqtt_bridge` is using some of the libraries (JSON <-->ROS conversion) behind the scene.  
* In the end...it seems like have lots of low-end devices on the system is kind of a pain.  It would be far simpler to have a Pi running ROS just drive syringe pumps and spectrometers via its own serial ports, rather than offloading this to microcontrollers.  The insertion of MQTT or rosbridge into the mix just makes it harder to deal wtih quality of service, etc. 
