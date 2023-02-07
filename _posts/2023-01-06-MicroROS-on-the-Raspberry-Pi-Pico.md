---
Title: "MicroROS on the Rapsberry Pi Pico"
Date: 2023-01-06
Tags: ros, pico, electronics, automation
---

**Goal:** Attach small actuators and sensors to a Rasberry Pi Pico (RP2040) and have it attach to present to a ROS2 network running on some other device.  Build this into a larger project.
**This Post:** Some collected notes on resources. 
**Status:** See [how-to-guide post](({{ site.baseurl }}{% post_url 2023-02-04-ROS-Setup-For-Raspberry-Pi-and-Pico %}))


# Setup ROS2 on a Raspberry Pi

One approach:  setup some Docker containers, etc.  This is a bit beyond what I know how to do and still get reliable access to the USB port


Working approach:  Install ROS2 development environment, on Ubuntu 20 on a Raspberry Pi and then just connect to that.  This is the approach argued for in [this article](https://robofoundry.medium.com/easy-development-setup-for-robotics-using-ros2-and-raspberry-pi-53ecaddd857e) which also provides some helpful tips on configuring Sambda to allow easy access

[How to install ROS2 on Raspberry Pi](https://docs.ros.org/en/foxy/How-To-Guides/Installing-on-Raspberry-Pi.html).  Key take aways are to use the 64-bit Ubuntu

# Configure the Raspberry Pi PICO for MicroROS Development

**Approach 0:  The Official Github for MicroROS on RP2040** [github page](https://github.com/micro-ROS/micro_ros_raspberrypi_pico_sdk) pretty plug and chug, runs micro-ros-agent in a docker container

**Approach 1: Use an Ubuntu snap to run the micro-ros-agent**

* Install some dependencies, etc. assuming you are running an Ubuntu machine [ubuntu blog](https://ubuntu.com/blog/getting-started-with-micro-ros-on-raspberry-pi-pico)
then 
* This guy claimed to have trouble with the VSCode descriptions, but [managed to get it running in the end with a guide](https://robofoundry.medium.com/raspberry-pi-pico-ros2-via-micro-ros-actually-working-in-1-hr-9f7a3782d3e3) using snaps, but not VSCode


# First steps in interfacing Micro-ROS devices 

Demonstration of [how to publish sonar readings](https://canonical.com/blog/hc-sr04-with-the-raspberry-pi-pico-and-micro-ros) with
[sample code for make a a ROS publisher](https://github.com/artivis/mico_ros/blob/master/src/range_node.cpp)

# IR Sensor interfacing

* [Reading I2C on the RP2040 in C](https://www.digikey.com/en/maker/projects/raspberry-pi-pico-rp2040-i2c-example-with-micropython-and-cc/47d0c922b79342779cdbd4b37b7eb7e2)
* [Sparkfun Arduino C libraries for the AS726X](https://github.com/sparkfun/Sparkfun_AS726X_Arduino_Library)
* [How to use Arduino libraries on the RP2040](https://www.hackster.io/fhdm-dev/use-arduino-libraries-with-the-rasperry-pi-pico-c-c-sdk-eff55c?f=1)

# Next Steps

**Status:** See [how-to-guide post](({{ site.baseurl }}{% post_url 2023-02-04-ROS-Setup-For-Raspberry-Pi-and-Pico %}))