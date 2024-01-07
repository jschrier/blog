---
title: "Reading AS726X and AS7265X Spectral Sensors in Micropython"
date: 2023-02-01
tags: electronics i2c pico micropython
---
The [AS726X](https://learn.sparkfun.com/tutorials/as726x-nirvi?_ga=2.39829093.73129845.1675284181-552368455.1675284181) and [AS7265X](https://www.sparkfun.com/products/15050) spectral sensors give you the ability to read visible, UV, and IR over an I2C bus, and are relatively cheap ($27-$60 USD). 
The former focuses on just visible or IR, and the latter is a triad sensor that spans the entire spectrum. 
**In this post, we'll walk you through setting this up and reading the sensor values...**

# Github repositories for micropython libraries for interfacing with these sensors:
* **AS726X**:  [jajberni/AS726X_LoPy](https://github.com/jajberni/AS726X_LoPy) and [rcolistete/MicroPytho_AS7262X_driver](https://github.com/rcolistete/MicroPython_AS7262X_driver)  and [KDUMod](https://git.csic.es/kduino/kdumod/-/blob/88d8f4873201dc97e8c0739d3ef738eb1d6401f3/module/lib/AS726X.py)
* **AS7265X**: [NPC1399/AS7265X_sparkfun_micropython](https://github.com/NPC1399/AS7265X_sparkfun_micropython) and [Theoi-Meteoroi/SpectralESP](https://github.com/Theoi-Meteoroi/SpectralESP/tree/master/Micropython) (which credits the former)

# Demonstration with the AS7623 IR sensor

## Bill of materials and hardware

* [Sparkfun AS7263 NIR sensor](https://www.sparkfun.com/products/14351) - $28
* [Sparkfun Pro Micro RP2040](https://www.sparkfun.com/products/18288) - $11 (just a Raspberry Pi Pico with a QWIC connection and some extra blinky lights)
* QWIIC cable - gotta connect them together. Length does not matter

Plug the gadgets together---It will be self-evident. 

## Load a Micro Python boot image

Connect the pico to your computer and [load your favorite Micro python environment bootimage](https://www.raspberrypi.com/documentation/microcontrollers/micropython.html). Here we use `rp2-pico-20220618-v1.19.1.uf2`

## Scan for I2C devices and their addresses

Load [Thonny](https://thonny.org) or your favorite IDE and make sure it finds the pico (be sure that you are in Micropython mode).

As we are using a [Sparkfun MicroPro](https://www.sparkfun.com/products/18288) which comes with a QWIIC connector; the corresponding I2C  pins are GP16 & GP17 (which are on controller I2C0).  If you are using an ordinary Pico, you'll need to wire it up accordingly; GP16 and GP17 are totally legitimate pins for this purpose, but you can choose others if you prefer.

```python
import machine

I2C_SDA_PIN = 16
I2C_SCL_PIN = 17
i2c=machine.I2C(0,sda=machine.Pin(I2C_SDA_PIN), scl=machine.Pin(I2C_SCL_PIN), freq=400000)

print('Scanning I2C bus.')
devices = i2c.scan() # this returns a list of devices

device_count = len(devices)

if device_count == 0:
    print('No i2c device found.')
else:
    print(device_count, 'devices found.')

for device in devices:
    print('Decimal address:', device, ", Hex address: ", hex(device))
```

Our little AS7263 dutifully reports back:
```
Scanning I2C bus.
1 devices found.
Decimal address: 73 , Hex address:  0x49
```
(this is the default for the AS7263; it will be different for another sensor)

## Set up the library and test the light

Let's do this using [jajberni/AS726X_LoPy](https://github.com/jajberni/AS726X_LoPy)'s library.

Clone [the repository]((https://github.com/jajberni/AS726X_LoPy)) and copy the `Device.py` and `AS726X.py` files in `lib/` to a new `lib/` folder that you create on the Pico.  Then create a new file to blink the lights.

```python
from machine import Pin, I2C
from AS726X import AS726X #from https://github.com/jajberni/AS726X_LoPy
from time import sleep

# define the I2C pins
I2C_SDA_PIN = 16
I2C_SCL_PIN = 17

# setup I2C and connect to the sensor; AS726X library will automatically detect the device
i2c = I2C(0, sda=Pin(I2C_SDA_PIN), scl=Pin(I2C_SCL_PIN))
sensor = AS726X(i2c=i2c)
sensor_type = sensor.get_sensor_type()
#print(sensor_type)  #AS7263 

# blink the blue power indicator LED
sensor.enable_indicator_led()
sleep(1)
sensor.disable_indicator_led()
sleep(1)

# ramp up the indicator: integers 0..3 denote the current
sensor.enable_indicator_led()
for i in range(4):
    sensor.set_indicator_current(i)
    sleep(0.5)
sensor.disable_indicator_led()

# ramp up the white LED light source: integers 0..3 denote the current

sensor.enable_bulb()
for i in range(4):
    sensor.set_bulb_current(i)
    sleep(0.5)

# turn it off and go to sleep
sensor.disable_bulb()
```
This should do what the comments tell you. It will also print an acknowledgement about finding the correct sensor type

## Reading a sensor value

Let's demonstrate how to read a sensor value, turning on the light.  
We'll use default settings for the gain and integration time, but obviously you can change these as you see fit.

As described in the [documentation for the library](https://github.com/jajberni/AS726X_LoPy), reading from the sensors is a two-step process. First you use the `take_measurements()` or `take_measurements_with_bulb()` method to have the sensor acquire a value.  Then you retrieve it using `sensor_get_calibrated_values()`, which returns a list of floats.  The sensor light will be turned on to whatever value you set its current to (below we use the default).

```python
from machine import Pin, I2C
from AS726X import AS726X # from https://github.com/jajberni/AS726X_LoPy

# define the I2C pins
I2C_SDA_PIN = 16
I2C_SCL_PIN = 17

# setup I2C and connect to the sensor; AS726X library will automatically detect the device
i2c = I2C(0, sda=Pin(I2C_SDA_PIN), scl=Pin(I2C_SCL_PIN))
sensor = AS726X(i2c=i2c, mode=3, gain=3, integration_time=50)

# return a list of the wavelengths being read
print("wavelengths (nm): ", sensor.get_wavelengths())

# read the sensor with the light on
sensor.take_measurements_with_bulb()
results = sensor.get_calibrated_values()
print("reading w/ light:", results) #same order as the wavelengths

# try it without the light on
sensor.take_measurements()
results = sensor.get_calibrated_values()
print("reading w/o light:", results)
```

For fun, I pointed the sensor at an orange Post-It note, and got the following result:
```
AS7263 online!
wavelengths (nm):  [610, 680, 730, 760, 810, 860]
reading w/ light: [25873.66, 4424.922, 1114.959, 774.937, 1693.204, 1241.406]
reading w/o light: [110.4013, 49.66749, 8.475845, 6.702158, 7.110569, 7.13452]
```
Observe how the reading with the light gives much larger values....we can fiddle with the integration time and the light intensity to modify these values

# Next steps

Now that you know how to get readings porogrammatically, the next step is to read some values in.  Some features might be:
* Wait for a newline from `sys.stdin.read()` to trigger a reading (for example, once you've got a sample in place)
* Read the values and print it in a desired format
* Write a program for your laptop that reads these values and saves them...maybe with some type of annotation as to the sample you are considering?
* Or...add a physical switch to the circuit and read from the switch to trigger the reading. Then [design and print]((({{ site.baseurl }}{% post_url 2022-12-31-Autodidact-guide-to-advanced-manufacturing %}))) a housing to keep everything oriented the way you want. 
