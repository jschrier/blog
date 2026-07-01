---
title: "DIY Automated Surface Tension Measurements "
date: 2026-07-01
tags: science chemistry diy sdl automation
---

**Goal:** Develop low-cost, high-throughput, automatable measurements of [surface tension](https://en.wikipedia.org/wiki/Surface_tension), which can inform knowledge of a variety of physical chemistry processes (micelle formation, etc.)...

# Drop tensiometry

**Physical principle:** Determine shape and size of droplet as a function of surface tension 

**Automation?** Camera + computer vision to watch droplet size with a diffuse light background. [OpenDrop](https://opendrop.readthedocs.io/en/latest/) software exists for this. Use a syringe with blunt needle to dispense the droplets (to be fancy, maybe you want some liquid nearby to saturate humidity)    

**Limitation:** You want to use a wide blunt needle (on a luer lock syringe) of known diameter for dispensing the droplets.  Maybe you want to use a washing station of some kind? Or maybe you just don't overthink it too much—--the [Huck paper SI](https://doi.org/10.1038/s41524-025-01842-9) looks like they just jam one of these blunt needles on an OT-2, don't aspirate too much volume, and then just eject it. 

**Precedent:** Widely used method. Precedent for automation is work by [Huck & Robinson & co. npj Comput Mater 2025](https://doi.org/10.1038/s41524-025-01842-9) (done on OT-2 for mixture prep and measurement although they don't address washing issue) 


# Capillary rise

**Physical principle:** Measure the height of a column of liquid. 

**Automation?**  Use a camera + computer vision to look at the rise (need a side angle) Use [disposable precision capillary tubes](https://stonylab.com/products/b07zr9z2lz-capillary-tubes) for each measurement.  Avoids need for cleaning (just dispose of tube). Needs clear, level side view of solution.

**Limitation:** Requires knowledge of the solution density.

**Precedent:** [Huck-Iriart et al. J Chem Educ 2016](https://pubs.acs.org/doi/10.1021/acs.jchemed.6b00128) --- USB microscope camera with manual image analysis


# Drop Weight

**Physical principle:** Surface tension keeps drops from falling until they get big. Determine mass of the drops.

**Automation?** Use a [drop counter](https://www.vernier.com/product/drop-counter/) or camera + computer vision to count drops. Use an analytical balance to measure a collection of 20 drops in a batch. In principle this could be on the [robot deck](https://docs.pylabrobot.org/stable/user_guide/02_analytical/scales/mettler-toledo-WXS205SDU.html) (e.g., Mettler Toledo [WMS](https://www.mt.com/gb/en/home/search/Advanced_Search.html#stq=WMS) or [WXS series](https://www.mt.com/gb/en/home/search/Advanced_Search.html#stq=wxs)) or some other type of rig (e.g., [Kedar's placement of a MT balance under an OT-2](https://insights.opentrons.com/hubfs/Applications/General%20liquid%20handling/Mass%20Balance%20Integration%20OT-2%20App%20Note.pdf))     

**Limitation:** Empirical correction factor to account for the full mass of a pendant drop not being detached from the dispenser. Need analytical balance (0.1 mg) on robot, and these are pricey (3-5k USD used?) 

**Precedent:** [Gascon et al J. Chem. Educ 2019](https://pubs.acs.org/doi/10.1021/acs.jchemed.8b00667) --- used manual disposable plastic pipettes + 20 drops + analytical balance (0.1 mg)


# Capillary waves

**Physical principle:** Energy to excite waves on a surface depends on the surface tension. Measure the waves

**How?** Immerse an exciter needle (virbating at acoustic frequencies) into the liquid (Eur. J. Phys 2012)[https://dx.doi.org/10.1088/0143-0807/33/6/1677] or use a [smart phone vibrator motor to shake a paper cup](https://dl.acm.org/doi/pdf/10.1145/3307334.3326078)

**Automation?** Exciter needle approach would require cleaning.  [CapCam](https://dl.acm.org/doi/pdf/10.1145/3307334.3326078) is non-contact:  Place iPhone on cup to perform excitation at 144.5 Hz, and use light + camera to look at trough patterns, with computer vision to determine wavelength.

**Limitation:** Requires large volume of liquid (typical wavelength is order of 3 mm, paper-cup sized volume)

