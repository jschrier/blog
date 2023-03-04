---
Title: "ROS Setup for Raspberry Pi and Pico"
Date: 2023-01-06
Tags: ros ros2 microros raspberrypi pico electronics automation
---

[Last time, we collected some resources about the process.]({{ site.baseurl }}{% post_url 2023-01-06-MicroROS-on-the-Raspberry-Pi-Pico %}) In this post we'll take you step-by-step on installing ROS2 on a Raspberry Pi 3B+, configuring the ROS and MicroROS development environment, and getting to 'hello world'... **STATUS:  Successfully installed ROS2, but configuring the micro-ros-agent on Raspberry Pi 3B+ has some problems.**

# Install Ubuntu on your Raspberry Pi

1. Download [Ubuntu 22.04 LTS 64 bit server](https://ubuntu.com/download/raspberry-pi) -- this is [recommended for ROS Humble Hawkbill](https://www.ros.org/reps/rep-2000.html), which is the current stable version of ROS.  I'm not going to bother with the GUI, etc.
2. Download the [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
3. Using the Raspberry Pi Imager software: (i) select *Operating System>Use Custom...* and select your downloaded Ubuntu Image; (ii) Click the gear and configure an SSH user name/password and WiFi network and password.  Make this the same WiFi that your laptop is on.  Then press *Write* and let it rip. It will take about 5-10 minutes.  Transfer the SD card to the Pi and give it a minute to boot up.
4. `ssh` into your machine using the username and password you set.  It should appear on your network as `ros.local`.

# Install ROS

5. Install ROS on the Pi, following these the instructions for [Humble Hawkbill](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html)  (or whatever distro you decide to use). When prompted, just say "yes" (by typing enter). You can ignore the comments prefaced by `#`.  This will take about an hour, so put on some tunes (e.g., [Tangerine Dream, Portsmouth 1976](https://www.youtube.com/watch?v=OfI-6s4llzc) and do some grading while you wait...

```bash
# ensure that the Ubuntu Universe repository is enabled.
sudo apt install software-properties-common
sudo add-apt-repository universe
# add the ROS 2 GPG key with apt.
sudo apt update && sudo apt install curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# add the repository to your sources list.
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Update your apt repository caches after setting up the repositories; the latter takes about 25 minutes and will require a restart
sudo apt update
sudo apt upgrade
sudo reboot

# ssh back in and perform the ROS desktop and developer tool install
# not sure if the desktop version is strictly necessary, and it will take up 3GB, FYI...and about 30 min
# dev tool install is pretty quick
sudo apt install ros-humble-desktop
sudo apt install ros-dev-tools
```

6. Test the ros install.  Run the following (in two separate terminals). You should see the talker saying that it’s Publishing messages and the listener saying I heard those messages.  This verifies both the C++ and Python APIs are working properly.

```bash
# In one terminal, source the setup file and then run a C++ talker:
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_cpp talker

# In another terminal source the setup file and then run a Python listener:
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_py listener
```

# Install Micro-ROS Development Environment

There are two separate things here.  First is relevant micro-ros SDK for the client MCU, and the second is the micro-ros-agent that runs on the host Pi.

7. [Follow the instructions to install the microROS development environment on Ubuntu](https://ubuntu.com/blog/getting-started-with-micro-ros-on-raspberry-pi-pico)

```bash
# another two gigs of dependencies, and about 10 minutes
sudo apt install build-essential cmake g++ gcc-arm-none-eabi libnewlib-arm-none-eabi doxygen git python3

#fetch the sources for the Pi Pico SDK and the MicroROS sources
mkdir -p ~/micro_ros_ws/src
cd ~/micro_ros_ws/src
git clone --recurse-submodules https://github.com/raspberrypi/pico-sdk.git
git clone https://github.com/micro-ROS/micro_ros_raspberrypi_pico_sdk.git
```

8. Configure the environment (as described in the [MicroROS documentation](https://github.com/micro-ROS/micro_ros_raspberrypi_pico_sdk/blob/humble/README.md).  By default `arm-none-eabi-gcc` should be in `/usr/bin/arm-none-eabi-gcc`, but if this is breaking, check `which arm-none-eabi-gcc` to confirm:

```bash
echo "export PICO_TOOLCHAIN_PATH=/usr/bin/" >> ~/.bashrc
source ~/.bashrc

#... or wherever path you place this...
echo "export PICO_SDK_PATH=$HOME/micro_ros_ws/src/pico-sdk" >> ~/.bashrc
source ~/.bashrc
```

9. Compile the example:

```bash
cd micro_ros_ws/src/micro_ros_raspberrypi_pico_sdk/
mkdir build
cd build
cmake ..
make
```

10. Copy it to the pico and run. Connect the pico by usb while holding the BOOTSEL button.  If you are running the desktop Ubuntu then it would automount, but [by default, Ubuntu Server does not automount USB mass sotrage devices](https://help.ubuntu.com/community/Mount/USB#Auto-mounting_.28Ubuntu_Server.29)  You used to be able to use `usbmount` but [this is no longer included in Ubuntu 20.04](https://askubuntu.com/questions/1308084/upstart-to-automount-usb-in-ubuntu-server-20-04).  You could try building `usbmount` from source, but we're probably not so interested in this functionality for now.  So let's just do it the old-fashioned way.   Confirm the device is present by running `lsusb` (you should see a device ` Raspberry Pi RP2 Boot`).  It should be present (but not mounted as) `/dev/sda1` (confirm this by running `blkid - o list` ), then manually mount it with:

```bash
sudo mkdir /media/pico              # create a location for this 
sudo mount /dev/sda1 /media/pico    # mount it to the location
```

Regardless of how you get the device mounted, now go ahead and copy the generated `uf2` file to the device (Because I was lazy, I didn't bother with setting user write access to the drive when manually mounting it, so you need super user)

```bash 
sudo cp pico_micro_ros_example.uf2 /media/pico
```

After you do this, the Pico will reboot and present as a USB serial device.  You'll see it is still there (via `lsusb`), but instead of identifying as ` Raspberry Pi RP2 Boot` it will identify as merely `Raspberry Pi Pico`, and it won't have a ` blkid -o list` entry (because it is no longer identifying as a USB mass storage device).  Congratulations! You're now running your first MicroROS program.  But what is it saying?

# Installing the Micro-Ros-Agent

11. **FAIL** I tried to [install micro-ros-agent](https://ubuntu.com/blog/getting-started-with-micro-ros-on-raspberry-pi-pico)...With Ubuntu it is supposed to be a `snap`  (*You see what I did there...*)...except there is no support for arm64. So it looks like we've gotta [build micro-ros-agent from scratch](https://github.com/micro-ROS/micro_ros_setup#building).  I guess it will set up a bunch of other things for ROS development later on so we might as well:

```bash
source /opt/ros/humble/setup.bash  # assuming that we use ros2/humble distro
sudo rosdep init
rosdep update

# build the microros setup...not sure how necessary this is
cd $HOME/micro_ros_ws/
git clone -b $ROS_DISTRO https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup
rosdep update && rosdep install --from-paths src --ignore-src -y
colcon build
source install/local_setup.bash

# build microros agent 
ros2 run micro_ros_setup create_agent_ws.sh
ros2 run micro_ros_setup build_agent.sh  # really slow...8 hours plus...
source install/local_setup.sh
```
**STATUS**:  Waited for the micro-ros-agent build to complete :-( 11 hours and counting, and the Rapsberry Pi has been throttled the whole time.  This is probably not the way....[Someone else raised this issue Dec 2022. tl;dr is that there is not enough memory/swap space on the Pi 3B+ (1GB total) to directly compile micro-ros-agent](https://github.com/micro-ROS/micro-ROS-Agent/issues/178) So maybe the easy fix is to use a heartier (better provisioned Pi as the host.)

11. **FAIL** Let's [try another way](https://answers.ros.org/question/373503/micro-ros-agent-on-raspberry-pi-3/).  In the end, micro-ros-agent is just a wrapper around XRCE-DDS, so try to go directly there:

```bash
sudo snap install micro-xrce-dds-agent
sudo snap set core experimental.hotplug=true  #enable usb hot plugging
sudo systemctl restart snapd # restart  snapd so changes take place
snap interface serial-port
sudo snap connect micro-xrce-dds-agent:serial-port snapd:pico 
# unplug the device, then plug it in again
 micro-xrce-dds-agent serial --dev /dev/ttyACM0 -v6
```
**STATUS**: This appears to establish a connection, but I'm not sure what is supposed to happen next...



# Other Pi setup notes

* You might as well [set up additional WiFi networks to connect to.](https://askubuntu.com/questions/1245253/set-multiple-wifi-access-points-in-ubuntu-20-04)  Do this by editing the `/etc/netplan/50-cloud-init.yaml` file to add additional lines, then [reset netconfig](https://askubuntu.com/questions/1083390/netplan-apply-does-not-change-the-ip-address/1083497#1083497) by running:

```bash
sudo nano /etc/netplan/50-cloud-init.yaml
sudo netplan generate          # generate the config files
sudo netplan apply             # apply the new configuration
reboot                         # optional reboot the computer to confirm persistence
```

# Other passing thoughts

* Given what a pain it is to compile micro-ros-agent on the Raspberry Pi, and the inconvenience of writing MicroROS code for the pico in C (instead of Python), perhaps there are other, better alternatives for this purpose?  For example [MQTT](https://www.tomshardware.com/how-to/send-and-receive-data-raspberry-pi-pico-w-mqtt) is a lightweight publish/subscribe architcture, and using the [mosquitto broker it can be connected to ROS](https://robofoundry.medium.com/combining-ros2-and-mqtt-on-esp32-to-send-twist-messages-bab758cf098).  We'll [explore this in the next post](({{ site.baseurl }}{% post_url 2023-02-11-MQTT-and-ROS2-integration %}) ).
* In the end, `micro-ros-agent` is just a wrapper around `DDS-XRCE` so [apparently you can just use that instead](https://answers.ros.org/question/373503/micro-ros-agent-on-raspberry-pi-3/)

