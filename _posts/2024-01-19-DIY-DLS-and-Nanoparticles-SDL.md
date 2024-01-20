---
title: "DIY DLS towards Organic Nanoparticle SDL (notes)"
date: 2024-01-19
tags: science teaching electronics pico diy sdl
---

Recently, Young et al. [Nano Lett 2024](https://dx.doi.org/10.1021/acs.nanolett.3c04171) described the use of [Vittorio Saggiomo's 3d-printed+ Ender Flow pumps](https://doi.org/10.1016/j.ohx.2021.e00219) to make organic nanoparticles (liposome, polymer nanoparticle, and solid lipid nanoparticle).  But how do you characterize them?  **Let's build a DIY dynamical light scattering device...**

# Comments on Young et al. setup

- Experimental setup uses [Vittorrio's pumps](https://doi.org/10.1016/j.ohx.2021.e00219).  We've built some already.
- Mixing is just done using T-junctions
- Experiments they describe look like just mixing two components?
- They make a batch and then characterize it.  They are not doing this in a closed loop. DLS is a possibility, some of the nucleic-acid containing nanoparticles also support fluorescence (but after a centrifugation step)

# Dynamical Light Scattering Theory

- [DLS 30 minute tutorial introduction](https://www.chem.uci.edu/~dmitryf/manuals/Fundamentals/Dynamic%20light%20scattering%20in%2030%20minutes.pdf)

# Existing DIY DLS projects

- [OpenDLS](https://www.hackster.io/etienner/opendls-an-open-source-dynamic-light-scattering-bff60f) comprehesnive build guide, using a Thor Lab 650nm 4.5mW laser module (CPS650F),   Vishay BPW24R photodiode, and TI TLC082IP opamp, all driver off an Arduino.  Nice 3d-printed case. Cuvette based.  Reading between the lines, you need to acquire ~5 minutes of sample to get a decent fit.  Looks like the available ADC samples at 67 kHz, which gets fed into a buffer.
    - Comment thread suggests you might just use USB oscilloscope and call it a day (save the output to disk for analysis)...then you don't need the arduino at all...and no amplifier or ADC either


#  The Need For Speed

- Ekkens [Physics Teacher 2024](https://doi.org/10.1119/5.0124070) describes how to use a Pico to modulate a 5 MHz laser square wave and how to use a Hamamatsu S5793 ($20) and high-speed amplifier  Analog Devices AD848JN ($5) to detect it
- In principle, you can set the integration time on the [MAX44009](https://www.analog.com/media/en/technical-documentation/data-sheets/max44009.pdf) to 6.25 ms = 160 Hz samples, but that aint enough (and it is one of the faster commercial kits out there)

