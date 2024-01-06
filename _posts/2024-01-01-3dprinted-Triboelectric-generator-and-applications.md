---
Title: "3d printed Triboelectric generator and applications"
Date: 2024-01-01
tags: 3dprinting electronics science synthesizer
---

Saw an [article with youtube video on Hackaday](https://hackaday.com/2023/12/31/3d-printing-your-own-triboelectric-generators/) about a 3d-printed [triboelectric generator](https://en.wikipedia.org/wiki/Triboelectric_effect), which describes the work in this paper [Fully enclosed microbeads structured TENG arrays for omnidirectional wind energy harvesting with a portable galloping oscillator](https://nanoscience.gatech.edu/paper/2023/1-s2.0-S1369702123003486-main.pdf) from Zhong Lin Wang's group at GATech.  Use your standard fdm printer, condutive filament, and insert some PTFE beads during a pause, so it is easy to do at home. Triboelectrics give you high voltage, but low current; you can always play some electronics tricks. In the paper they charge a 220 mF capacitor to 3 V in under 1 min, and under linear shaking at 3 Hz, the maximum peak power is 2.1 mW, the maximum average power is 1.2 mW. **How might this be applied?...**

# Project ideas

- In the paper they describe a wind generator that tkaes advantage of shaking motion
- You've got rattling beads.  This seems like a kind of hybrid analog electronic [idiophone](https://en.wikipedia.org/wiki/Idiophone) (e.g., [maraca](https://en.wikipedia.org/wiki/Maraca) or [caxirola](https://en.wikipedia.org/wiki/Caxirola)) input device for an analogue synthesizer (use the voltage, through some filter, look ma, no accelerometers).  It would be hybrid because presumably you would hear the shaking beads along with the electronic signal
    - love the brass-knuckles look of the [caxirola](https://en.wikipedia.org/wiki/Caxirola), but [can't find any free models](https://free3d.com/3d-model/caxirola-7739.html)
    - [Sambacan](https://www.youmagine.com/designs/sambacan) the forgotten child of the maraca and caxirola
- Energy harvesting for water environments (for bouys, sensors).  It's hollow, so it might be designed as a self-floating platform that incorporates energy generation.
- Pet door: use the swinging motion to shake the beads.  Maybe this powers a counter/sensor



