---
Title: "DIY drum machine ideas"
Date: 2023-04-20
Tags: audio synth pico drum
---

What [my analog synthesizer](({{ site.baseurl }}{% post_url 2023-01-16-Building-the-mki-x-es.edu-synthesizer %})) lacks is a drum machine.  A few thoughts towards a project, assuming you are not an analog purist and have a Raspberry Pi Pico or two floating around...

# Circuit design

* A handful of 2k resistors is enough to build a [two-channel 1 Hz-20 MHz wavegenerator](https://www.instructables.com/Arbitrary-Wave-Generator-With-the-Raspberry-Pi-Pic/) using the programmable IO pins. 
* Or drive the good-old [MCP4728 Quad DAC](https://www.adafruit.com/product/4470) [DATASHEET](https://ww1.microchip.com/downloads/en/DeviceDoc/22187E.pdf) at 100 kHz, which is far beyond what I can hear.  Heck, I've even got three free channels left on my [MIDI-to-CV project](({{ site.baseurl }}{% post_url 2023-01-21-MIDI-to-CV-on-RP2040-part-2 %})) that could be used for separate drum signals.  This type of [direct digital synthesis can be done efficiently](https://vanhunteradams.com/Pico/TimerIRQ/SPI_DDS.html), based on what appears to be an [excellent digital systems design course at Cornell, with comprehensive lecture videos](https://www.youtube.com/playlist?list=PLDqMkB5cbBA5oDg8VXM110GKc-CmvUqEZ)
* Or go sample-based with a [PicoAudio I2S pack](https://shop.pimoroni.com/en-us/products/pico-audio-pack) I've got one of these kicking around the house, which I used for a Markov-chain music composition project...could also just program some wavetables for this.  Might be the easiest path

# Inspirations/Resources

* [digital-synthesis drum machine](https://www.youtube.com/watch?v=A_Bv5Ad-Cy8)
* If one gets [inspired by the classic TR-808 analog drum machine](http://mickeydelp.com/blog/anatomy-of-a-drum-machine)  the signals have the form of: *drum*: decaying sine wave; *snare*: noisy decaying sine wave; *cymbal*: white noise (can tweak this with a PRNG)
* [Kurt Werner](https://ccrma.stanford.edu/~kwerner/) did a phd in simulating analog circuits, including the TR-808...and led me into a rabbit hole of [1-bit music](({{ site.baseurl }}{% post_url 2023-04-20-1-Bit-Music %}))
* [Euclidean rhythms](https://en.wikipedia.org/wiki/Euclidean_rhythm), naturally...
* [Teensy-based drum machine](https://cdm.link/2023/02/diy-drum-machine-teensy/) --- looks like [C-code describing the various audioparameters and how they play with the switches and potentiometers](https://github.com/albnys/Drum-Machine/blob/main/Drum_machine.ino)
* [Polaron](https://github.com/zueblin/Polaron) --teensy-based drum machine, nice interface, sequencer, c-code, open-source


# Other random thoughts

* [Tayda electroncis](https://www.taydaelectronics.com) has some nice parts for making this shiny.
* [binaural beat generator](https://syntherjack.net/binaural-beat-generator-1-5-arduino/) --- might be a good project along the way