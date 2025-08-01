---
title: "Qwiic RGB LEDs"
date: 2025-08-01
tags: diy electronics claude-light
---

The [QWIIC](https://www.sparkfun.com/qwiic)/[STEMMA-QT](https://learn.adafruit.com/introducing-adafruit-stemma-qt/stemma-qt-comparison) ecosystem is kind of neat...standard connectors for I2C gadgets to allow you to solderlessly connect hardware to your microcontroller.  **But it is suprisingly difficult to find an RGB LED in this ecosystem...**

# Goals

- The [current claude-light](https://github.com/jkitchin/claude-light?tab=readme-ov-file#parts-list) relies on some PWM driven RGB LEDs attached by protoboard.

- **Our goal is to turn this into a completely solderless plug-and-play system to make it easy for others to replicate.** Eventually make a 3d-printed case for the sensor, LED, and camera.

- Use a [Sparkfun QWIIC/Stemma-QT  SHIM for the raspberry pi](https://www.sparkfun.com/sparkfun-qwiic-shim-for-raspberry-pi.html)($2, also sold by [Adafruit for $2.50](https://www.adafruit.com/product/4463)) for the electrical connections and send information by I2C. In the Sparkfun reviews, some folks found it to be unreliable, and recommended instead just using a [female jumper to Qwiic](https://www.sparkfun.com/flexible-qwiic-cable-female-jumper-4-pin.html) ($2) connector instead.  Still admits solderless assembly approach with everything on the same digital I2C bus.

# Background on standards

- First, there are many standards for this type of plug-and-play work besides QWIIC and STEMMA-QT---two common ones are Grove and Gravity.  [See comparison chart](https://learn.adafruit.com/introducing-adafruit-stemma-qt/stemma-qt-comparison). **Warning:** While DFRobot Gravity and STEMMA use the same shaped connectors, they are [electrically incompatible (different wiring order)](https://learn.adafruit.com/introducing-adafruit-stemma-qt/dfrobot-gravity)

- The trick is that even the "digital" versions of RGB LED carrier boards are not necessarily I2C based...

# Product landscape (01 Aug 2025)

- [Sparkfun Qwiic LED Strip](https://www.sparkfun.com/sparkfun-qwiic-led-stick-apa102c.html) ($12.50) -- would fit the bill, but out of stock (and has 10 LEDs)
- [Sparkfun Qwiic Green LED button](https://www.sparkfun.com/sparkfun-qwiic-button-green-led.html) ($5) -- only green (and is a button). [Also available in red](https://www.sparkfun.com/sparkfun-qwiic-button-red-led.html)
- [Modulino Pixels](https://store.arduino.cc/products/modulino-pixels) ([$11 on Amazon](https://amzn.to/4flutUH)) -- **best option** 8 addressable RGB on a QWIIC-compatible substrate. ([Modulino is drop-incompatible with QWIIC](https://learn.adafruit.com/introducing-adafruit-stemma-qt/sparkfun-qwiic)) 
- [DFRobotics I2C RGB LED Button](https://wiki.dfrobot.com/SKU_DFR0991_Gravity_I2C_RGB_LED_Button_Module) ($10) -- but note **electrical incompatibility** and also its a button...
- [Sparkfun Qwiic RGB Rotary Encoder](https://www.sparkfun.com/sparkfun-qwiic-twist-rgb-rotary-encoder-breakout.html) (Sparkfun $25) -- but its really a button that happens to glow.
- [M5 Stack RGB LED Unit](https://www.robotshop.com/products/m5stack-rgb-led-unit-sk6812) ($5) --- not what you want; has a grove connector, [but uses some other 1-wire digital signal, not I2C](https://docs.m5stack.com/en/unit/rgb)
- [Adafruit NeoRGB Stemma - NeoPixel to RGB PWM LED](https://www.adafruit.com/product/5888) ($5) --- not what you want, as this is a 3-pin (non-I2C) system
- [Sparkfun BlinkM I2C Controlled RGB](https://www.sparkfun.com/blinkm-i2c-controlled-rgb-led.html) ($25, out of stock at SF, but in stock at [Digikey](https://www.digikey.com/en/products/detail/sparkfun-electronics/08579/7319603)) --- almost right, but not the right connector, so you're back to soldering.  You could always attach it to a [Qwiic adapter board](https://www.adafruit.com/product/4527) ($2) but then you're back to soldering.  
- [Zio Qwiic RGB LED APA02](https://www.tindie.com/products/alexchu/zio-qwiic-rgb-led-apa102/) (Tindie $9, but also [RobotShop](https://www.robotshop.com/products/smart-prototyping-zio-qwiic-rgb-led-apa102)) --- almost right, but only has 5-bit (32 value) settings for the LEDs, which makes it incompatible with the earlier claude-light development (where we want 8-bit settings).
- [Seeed Grove Chainable RGB LED](https://wiki.seeedstudio.com/Grove-Chainable_RGB_LED/) -- uses some other type of digital signal, not I2C
- [Adafruit NeoDriver I2C to Neopixel](https://www.adafruit.com/product/5766) (Adafruit $7.50) --- **second best option** This allows you to drive a (potentially big) Neopixel LED setup. We only need one, so in principle we can get away with powering it over the RPi's STEMMA 5V connection (each pixel requires 10-30 mA of current, and our Pi can reliably give 20x that on the 5V GPIO pin). You'll either need to add a [Neopixel breakout with JST SH connectors](https://www.adafruit.com/product/5975) ($1.50) (and cut devise your own cable to connect it to the terminal blacok) or buy a [Neopixel button PCB](https://www.adafruit.com/product/1612) ($5/5) and solder on wires (which gets us back into soldering territory again)
- [IO Rodeo](https://iorodeo.com/pages/led-boards) sells a variety of single-wavelength LED sources with Stemma-QT connectors, although it looks like they are intended to just be constant on. And they are only a single wavelength.
