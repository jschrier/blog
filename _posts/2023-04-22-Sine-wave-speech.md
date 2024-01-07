---
title: "Sine wave speech"
date: 2023-04-22
tags: sound music
---

[Sine wave speech](http://www.scholarpedia.org/article/Sine-wave_speech) is a research technique in which a human voice is reduced to 3 or 4 time-varying sinusoids.  It is unintelligble when heard without prompting, but with prompting it is clearly distinguishable.  A nice explanation (with examples) can be found on [Matt Davis (Cambridge)](https://www.mrc-cbu.cam.ac.uk/people/matt.davis/sine-wave-speech/), and Robert Remez (Barnard) has a very [artistic example setting a Robert Frost poem to sine wave, with experiments on note duration and pitch quantization](http://www.columbia.edu/~remez/musical-and-poetic-sine-wave-speech.html).  *Art project:* You could take [Johnny Cash reading the Bible](https://www.youtube.com/watch?v=artPgvlOtVU&list=PLyxgmM4B5YzTSFAzp4wUGiIVyxxpWCfOz) and turn this into a four voice analog oscillator...

# Notes

* I suspect one can use [AudioLocalMeasurements](https://reference.wolfram.com/language/ref/AudioLocalMeasurements.html) to extract what is needed, but I don't know the right terminology. 
* This [script for PRAAT](http://www.lifesci.sussex.ac.uk/home/Chris_Darwin/Praatscripts/SWS) gives some ideas about filtering and formants 
* This [page with matlab code](https://www.ee.columbia.edu/~dpwe/resources/matlab/sws/) says about [LPC pole positions](https://www.ee.columbia.edu/~dpwe/e4896/lectures/E4896-L06.pdf) being an effective way to extract the parameters.  I guess we can dig into the matlab to figure it out