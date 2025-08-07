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

## Supplies:
- 5 mW 650 nm  TTL laser diode [($19/adafruit)](https://www.adafruit.com/product/1056) -- this is switched in the same way that bigger lasers are. 
- JST XH 2.5 - 3 pin socket [($1/adafruit)](https://www.adafruit.com/product/4873) --- these are the standard connectors used on TTL lasers
- JST XH2.54-3Pin cable [($7/amazon)](https://amzn.to/42Q9Wmi) --- 80 cm tends to be a common length, but maybe go longer instead? 150cm?
- Build an adapter from Molex KK254 (on the Duet) to JST-XH2.54 


## Laser Hello-World with the Duet Mini 5+

The Duet Mini 5+ has a 3-pin Molex KK254 connector on IO6 which provides 5V power, ground, and a 5V PWM signal. [Wiring diagram.](https://docs.duet3d.com/duet_boards/duet_3_mini_5_plus/duet3_mini5+_v1.03_d1.0_wiring.png).  This is convenient for testing with a low power TLL-controlled laser pointer.

To enable the laser, add the following to your `config.g` file:

```
; Duet 3 Mini 5+
M452 C"out6"    ; Enable Laser mode, on out6, with default max intensity being 255, and default PWM frequency
```

Send a G-command with S options to set laser power (from 0 to 255)---the example below is the lowest power.
```
G1 S1           ; S parameter sets power, use the lowest for this test
```

**Note:** The laser is only on while the motion is taking place, so you need to be making a move to see it (e.g., `G1 X100 S1`).  You can just do a slow move (change the velocity parameter) so that it stay s on for a while. 

## Physical structure

TODO: [Design Jubilee tool](https://science-jubilee.readthedocs.io/en/latest/building/designing_custom_tools.html) to hold it in place.  Good practice in designing tools...good cad practice for students


# Safety-third! 

Everyone gets two changes at laser eye safety.  Don't look into the laser with your remaining eye.

0. Get some [laser safety glasses](https://www.edmundoptics.com/f/laser-safety-eyewear/39552/) 

1. Build an enclosure.  You can buy rated acrylic sheets (laser cut them with a CO2 laser) to construct side panels
- [24"x12" for $35](https://jtechphotonics.com/?product=12x24_laser_safety_sheilding)
- [Various sizes and wavelength ratings](https://lasersafetyindustries.com/collections/windows)

# Next Step: 5W 450nm diode laser

**Objective:** After establishing that you can do this safely, go for MORE POWER! Class 4 laser 

- LaserTree 5W 450nm laser module [($85/amazon)](https://amzn.to/4isFELd) seems to fit the bill: standard 12V power, 5V PWM control.
- JST XH2.54-3Pin cable [($7/amazon)](https://amzn.to/42Q9Wmi) --- if you don't have one already from the last experiment.
- Be sure to get some [laser safety glasses](https://www.edmundoptics.com/f/laser-safety-eyewear/39552/) 

## Build:

- Make an adapter from *two* inputs:  One from the 12V supply and Ground pin; the other from the 5V PWM output that we used above.

## Physical Structure

TODO: Design Jubilee tool

## Test

TODO: Test

# Other things

- [Acmer 10W diode + 2W IR laser module](https://acmerlaser.com/products/10w-diode-2w-ir-dual-laser-module-kit) $659 (but unclear how you interface the mode change)