---
Title: "Reading AS726X and AS7265X Sensors in Micropython"
Date: 2023-02-01
Tags: electronics, i2c, pico, micropython
---
The [AS726X](https://learn.sparkfun.com/tutorials/as726x-nirvi?_ga=2.39829093.73129845.1675284181-552368455.1675284181) and [AS7265X](https://www.sparkfun.com/products/15050) spectral sensors give you the ability to read visible, UV, and IR over an I2C bus, and are relatively cheap ($27-$60 USD). The former focuses on just visible or IR, and the latter is a triad sensor that spans the entire spectrum.  Here are existing micropython libraries for reading these easily on your favorite microcontroller:
* **AS726X**:  [jajberni/AS726X_LoPy](https://github.com/jajberni/AS726X_LoPy) and [rcolistete/MicroPytho_AS7262X_driver](https://github.com/rcolistete/MicroPython_AS7262X_driver)  and [KDUMod](https://git.csic.es/kduino/kdumod/-/blob/88d8f4873201dc97e8c0739d3ef738eb1d6401f3/module/lib/AS726X.py)
* **AS7265X**: [NPC1399/AS7265X_sparkfun_micropython](https://github.com/NPC1399/AS7265X_sparkfun_micropython) and [Theoi-Meteoroi/SpectralESP](https://github.com/Theoi-Meteoroi/SpectralESP/tree/master/Micropython) (which credits the former)
