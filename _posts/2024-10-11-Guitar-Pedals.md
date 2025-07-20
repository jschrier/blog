---
title: "Guitar Pedals"
date: 2024-10-11
tags: music analog diy electronics dsp pico
---

Going to the [BK Synth and Pedal Expo](https://delicious-audio.com/brooklyn-synth-pedal-expo/) with [Tardio](https://amzn.to/3PNyQ02) last weekend, reminded me about how neat they are.  **A few resources for DIY guitar pedal building...**

# Preliminary thoughts

In a way, there are only about 6 different types of guitar pedals.  Yet, there is tremendous variety in the offerings, most differentiated by microdifferences, user interface, and branding/packaging.  Make of that what you will.

# Analog Circuits 

- Alan Lanterman's [Guitar Amplification and Effects](https://youtube.com/playlist?list=PLOunECWxELQS7JV_KeeTJJpgGjOftoaAH&si=IN01nOACMy-fcZIm) course ([previously mentioned among his other music-EECS courses]({{ site.baseurl }}{% post_url 2024-06-22-Electrical-Engineering-for-Music %})).

- [Electrosmash](https://www.electrosmash.com) has some nice analysis of classic pedals

# DSP

As much as I want to love analog, we live in the digital age.  [Open-source DSP pedal kit](https://clevelandmusicco.com/hothouse-diy-digital-signal-processing-platform-kit/) based on the [daisy seed](https://electro-smith.com/products/daisy-seed)

(26 mar 2025) [Raspberry-Pi Pico multi-effect pedal](https://101-things.readthedocs.io/en/latest/guitar_effects.html) --- very low part count, well explained. Has some  very interesting links including to [musicDSP](https://www.musicdsp.org/en/latest/index.html) "a collection of algorithms, thoughts and snippets, gathered for the music dsp community"

(12 apr 2025) Yet another [Raspberry-Pi pico guitar pedal design](https://www.youtube.com/watch?v=jpfROA2EMzo).   It appears to use a DAC for audio output (maybe better than doing PWM as in the previous one, but doesn't seem as well documented )

# Parerga and paralipomena

- (20 July 2025) [Guitarpedalcourse.com](https://www.guitarpedalcourse.com) offers an online course on pedal circuit design.  Looks a bit pricey, but interesting, particularly if you pair it with a [Labor kit](https://www.ericasynths.lv/shop/diy-kits-1/edu-diy-labor/) to facilitate prototyping the audio circuits.