---
title: "Jubilee Laser"
date: 2025-04-19
tags: diy science laser jubilee
---

[Jubilee](https://science-jubilee.readthedocs.io/en/latest/) is an open-source & extensible multi-tool motion platform which can be used for laboratory automation. **Let's make a laser tool...**

# Science backstory

We've been having fun with a little Wainlux K10 5W diode laser [($150/alibaba)](https://www.alibaba.com/product-detail/Wainlux-K10-Portable-Mini-Enclosed-Laser_1601174792998.html) to make [laser-cut paper microfluidics](https://macdonald-lab.ca/Mahmud-MacDonald-Microscale_features_in_paper-2016.pdf).  To continue the fun, we want to build a [frugal self-driving lab device](https://pubs.rsc.org/en/content/articlelanding/2024/dd/d3dd00223c) to optimize parameters, etc.

# Background info

[Apparently we're not the first to try putting a laser on a Jubilee, but nobody has written about the results](https://jubilee3d.com/index.php?title=Laser_Tool)

Jubilee uses Duet 3 Mini 5+ which [natively support laser engraver/cutter control](https://docs.duet3d.com/User_manual/Machine_configuration/Configuration_laser) --- assumes a standard 12V laser with 5V active-high PWM signal --- so there shouldn't be any electrical fiddling needed to make this work, just mount it. 

# First Step: 5 mW 650 nm laser pointer

**Objective:** Demonstrate that you can successfully operate a laser tool on the Jubilee platform, using a low power Class II laser (glorified laser pointer)

**Supplies:**
- 5 mW 650 nm  TTL laser diode [($19/adafruit)](https://www.adafruit.com/product/1056) -- this is switched in the same way that bigger lasers are
- 5V linear voltage regulator 7805 TO-220 [($1/adafruit)](https://www.adafruit.com/product/2164) --- typical laser engravers supply 12V, but the diode takes a 5V supply, so step down the voltage. Might as well add a [heat sink](https://www.adafruit.com/product/977) too.
- 4x 0.1 uF capacitors [($2/adafruit)](https://www.adafruit.com/product/753) -- [per notional design specs for the 7805 (Figure 8)](https://cdn-shop.adafruit.com/product-files/2164/L7805CV.pdf)
- JST XH 2.5 - 3 pin socket [($1/adafruit)](https://www.adafruit.com/product/4873) --- these are the standard connectors used on TTL lasers
- JST XH2.54-3Pin cable [($7/amazon)](https://amzn.to/42Q9Wmi) --- 80 cm tends to be a common length, but maybe go longer instead?

TODO: Write up circuit diagram
TODO: [Design Jubilee tool](https://science-jubilee.readthedocs.io/en/latest/building/designing_custom_tools.html) to hold it in place.  Good practice in designing tools...good cad practice for students
TODO: Test on Jubilee

# Next Step: 5W 450nm diode laser

**Objective:** After establishing that you can do this safely, go for MORE POWER! 

- LaserTree 5W 450nm laser module [($85/amazon)](https://amzn.to/4isFELd) seems to fit the bill: standard 12V power, 5V PWM control.
- Get some [laser safety glasses](https://www.edmundoptics.com/f/laser-safety-eyewear/39552/) 

TODO: Laser safety consultation
TODO: Design Jubilee tool
TODO: Test