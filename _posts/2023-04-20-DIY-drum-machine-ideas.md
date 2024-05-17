---
title: "DIY drum machine ideas"
date: 2023-04-20
tags: audio synth pico drum electronics
---

[My analog synthesizer](({{ site.baseurl }}{% post_url 2023-01-16-Building-the-mki-x-es.edu-synthesizer %})) lacks a drum machine.  I suppose you could just [Moog DFAM](https://www.moogmusic.com/products/dfam-drummer-another-mother) or ([clone](https://www.synthtopia.com/content/2023/05/26/behringer-edge-now-shipping-with-199-list-price/)), but... **A few thoughts towards a project, assuming you are not an analog purist and have a Raspberry Pi Pico floating around...**

# Circuit design

* A handful of 2k resistors is enough to build a [two-channel 1 Hz-20 MHz wavegenerator](https://www.instructables.com/Arbitrary-Wave-Generator-With-the-Raspberry-Pi-Pic/) using the programmable IO pins. 
* Or drive the good-old [MCP4728 Quad DAC](https://www.adafruit.com/product/4470) [DATASHEET](https://ww1.microchip.com/downloads/en/DeviceDoc/22187E.pdf) at 100 kHz, which is far beyond what I can hear.  Heck, I've even got three free channels left on my [MIDI-to-CV project](({{ site.baseurl }}{% post_url 2023-01-21-MIDI-to-CV-on-RP2040-part-2 %})) that could be used for separate drum signals.  This type of [direct digital synthesis can be done efficiently](https://vanhunteradams.com/Pico/TimerIRQ/SPI_DDS.html), based on what appears to be an [excellent digital systems design course at Cornell, with comprehensive lecture videos](https://www.youtube.com/playlist?list=PLDqMkB5cbBA5oDg8VXM110GKc-CmvUqEZ)
* Or go sample-based with a [PicoAudio I2S pack](https://shop.pimoroni.com/en-us/products/pico-audio-pack) I've got one of these kicking around the house, which I used for a Markov-chain music composition project...could also just program some wavetables for this.  Might be the easiest path...[potentially as simple as IO](https://github.com/todbot/circuitpython-tricks/blob/main/larger-tricks/pidaydrummachine.py)
    * I2S audio can get really cheap ([just a few bucks](https://www.aliexpress.us/item/3256802711963831.html?gatewayAdapt=glo2usa4itemAdapt&_randl_shipto=US))
    * I2S is in [a preview for Micropython v1.19 so limited demos exist](https://github.com/miketeachman/micropython-i2s-examples)...or else you have to use [circuitpython](https://learn.adafruit.com/mp3-playback-rp2040/pico-i2s-mp3)
    * There are some [decent CPP demos](https://github.com/pimoroni/pimoroni-pico/blob/main/examples/pico_audio/demo.cpp)
* Really fancy: [PicoADK](https://github.com/DatanoiseTV/PicoADK-Hardware) uses [Vult to define DSP functions](https://www.vult-dsp.com/vult-language)

# Inspirations/Resources

* [digital-synthesis drum machine](https://www.youtube.com/watch?v=A_Bv5Ad-Cy8)
* If one gets [inspired by the classic TR-808 analog drum machine](http://mickeydelp.com/blog/anatomy-of-a-drum-machine)  the signals have the form of: *drum*: decaying sine wave; *snare*: noisy decaying sine wave; *cymbal*: white noise (can tweak this with a PRNG)
* [Kurt Werner](https://ccrma.stanford.edu/~kwerner/) did a phd in simulating analog circuits, including the TR-808...and led me into a rabbit hole of [1-bit music](({{ site.baseurl }}{% post_url 2023-04-20-1-Bit-Music %}))
* [Euclidean rhythms](https://en.wikipedia.org/wiki/Euclidean_rhythm), naturally... (see also [post]({{ site.baseurl }}{% post_url 2023-06-03-Euclidean-Rhythm %}))
* [Teensy-based drum machine](https://cdm.link/2023/02/diy-drum-machine-teensy/) --- looks like [C-code describing the various audioparameters and how they play with the switches and potentiometers](https://github.com/albnys/Drum-Machine/blob/main/Drum_machine.ino)
* [Polaron](https://github.com/zueblin/Polaron) --teensy-based drum machine, nice interface, sequencer, c-code, open-source
* [MadLab Funky Drummer](https://www.tindie.com/products/madlab/funky-drummer-kit/) is a simple PIC-based 8-bit drum machine (sounds pretty OK); the inventor's webpage has a [schematic and Elektor article for an earlier version](http://www.madlab.org/kits/drummer.html)
* The [bleep drum](https://bleeplabs.com/product/the-bleep-drum/) was a simple kit that is no longer sold...but you can find the [22kHz drum samples](http://bleeplabs.com/2013/04/07/putting-your-own-samples-in-the-bleep-drum/) online at [github](https://github.com/BleepLabs/Bleep-Drum); this seems like a popular backend for kits like the [cumbia tropical drum](https://www.tindie.com/products/oficinadesonido/hanan-cumbia-tropical-drum-machine/), etc.
* [PicoTouch capacitive midi keyboard](https://www.tindie.com/products/todbot/picotouch-capsense-midi-keyboard-for-raspi-pico/) and [PicoStepSeq](https://www.tindie.com/products/todbot/picostepseq-pcb/) designs.  Some inspiration for UI.   
* [CRUM Drum](https://www.thonk.co.uk/shop/crum-drum/) is a neat little semi-generative 4-voice drum machine; driven by a (pre-programmed) [Teensy](https://www.sparkfun.com/products/16996)


# Other random thoughts

* [Tayda electroncis](https://www.taydaelectronics.com) has some nice parts for making this shiny.
* [binaural beat generator](https://syntherjack.net/binaural-beat-generator-1-5-arduino/) --- might be a good project along the way, regardless of how it is implemented. That said, one should be able to run the [stereo I2S through separate channels](https://github.com/elehobica/pico_sine_wave_i2s_32b/blob/main/my_pico_audio_i2s/audio_i2s.pio)

# On second thought

- (20 Apr 2024)  [Mortiz Klein has a new series of videos/kits for drum machines](https://www.youtube.com/playlist?list=PLHeL0JWdJLvQZb-Zapy-OnCdbzCdM2R4-)
- (10 May 2024) [Wavetable drum machine/sequencer](https://github.com/zircothc/DRUM_2004_V1?tab=readme-ov-file) based on ESP32

# Prototyping hardware

- [spark inducer](https://protorack.de/modules/spark-inducer) is pretty cool for prototyping eurorack stuff.  It's a chassis that provides power, knobs, and plug entries on a breadboard.

# Sequencing (15 May 2024)

- Use a clock + [clock dividers](https://www.youtube.com/watch?v=up5f4npoobQ) to generate rhythms
    - There are definitely [kits](https://4mscompany.com/rcd-kit.php?c=11) to do this but the Doepfer A-160-2 is the classic (not too pricey)
    - You want to think about sending trigger pulses versus constant cycles, number of divisisions, CV inputs, possible internal clock.  
- Introduce patterns by binary pattterns (e.g., [Numeric Repetitor](https://manuals.noiseengineering.us/nr/))
    - The discontinued [Pittsburgh Time Runner](https://pittsburghmodular.com/timerunner) has some interesting ideas