---
title: "Hacking the Korg Volka Beats"
date: 2024-07-19
tags:  diy synth electronics drum
---

[The Korg Volka Beats](https://www.korg.com/us/products/dj/volca_beats/) is a cool little portable drum machine, but how can you make it cooler by voiding your warranty?...

- Batteries are included, but not a power supply. 
    - You could just buy one from Korg.  FYI if you want to get it from a third party, it is a [2.1 mm center-positive 9V plug](https://www.reddit.com/r/synthesizers/comments/7oaqnk/whos_stupid_idea_was_it_to_make_volca_power/), which is pretty standard for everything EXCEPT guitar pedals.  (The Volkas alledgedly have a reverse bias diode to protect against the wrong polarity, but still...)
    - [Synthrise sells a power supply](https://synth-rise.com/products/pa2pro-us) for this that is alledged to be audio grade, but has higher power so you can [daisy chain it](https://synth-rise.com/products/dc5?pr_prod_strat=jac&pr_rec_id=b4564faf6&pr_rec_pid=6543582855353&pr_ref_pid=6543582953657&pr_seq=uniform)
    - Or just drive it off of an existing USB adapter.  [Adafruit](https://www.adafruit.com/product/2777) has a USB to 2.1 mm DC 9V booster cable for $6.50.  [Other people have tried using adapters from AliExpress](https://ranzee.com/korg-volca-mobile-power-for-under-5/). What's cool about this is that you can run off of a USB power pack.  I got a free one from Merck...

- [Install a Lithium battery inside](https://www.instructables.com/Korg-Volca-Lithium-Battery-Mod/) that charges off the power supply input. Basically you need a LiPo battery, a adjustable discharge breakout, and a couple diodes to dial down the 9V input voltage. 

- Some [other electronics mods](https://drolez.com/blog/music/korg-volca-beats-mods-guide.php)
    - Modifying the [C78 capacitor to make the snare nicer](https://modwiggler.com/forum/viewtopic.php?t=193238#p2710371); you can also modify a resistor to make the snare louder
    - [Separate the audio outputs](https://www.instructables.com/Improve-Korg-Volca-Beats-with-Individual-Out-Mod/) (they're all mixed, but could be separate)
    - Add [MIDI out port](https://blog.utopianlabs.com/2013/09/korg-volca-beats-midi-out/)

