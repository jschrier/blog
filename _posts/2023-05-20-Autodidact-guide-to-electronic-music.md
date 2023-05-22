---
Title: "Autodidact guide to electronic music making on digital computers"
Date: 2023-01-06
Tags: music synth autodidact
---

In the beginning, the LORD created [modular synthesizers]((({{ site.baseurl }}{% post_url 2023-01-16-Building-the-mki-x-es.edu-synthesizer %}))), and they were good. He sent his [Prophets](https://en.wikipedia.org/wiki/Prophet-5), [Bob](https://en.wikipedia.org/wiki/Robert_Moog) and [Don](https://en.wikipedia.org/wiki/Don_Buchla) and [Serge](https://en.wikipedia.org/wiki/Serge_Tcherepnin), who told all the peoples of the earth "Thou shalt not eat of the fruit of the tree of the digital computer."  But the people hardened their hearts and did not listen.  So the LORD sent his prophet [Dieter](https://doepfer.de/home.htm), a voice crying in the wilderness, who said "Repent, repent! For the [Eurorack](https://en.wikipedia.org/wiki/Eurorack) is at hand." But the people said: "We have no King but [Gordon](https://en.wikipedia.org/wiki/Moore's_law)."  And so it came to pass that digital computers became numerous upon the face of the earth.  Then angel of the LORD came down and created a multitude of programs to confound their language, so that they may not understand one another's code.  "Now are you happy?" said the angel of the LORD.  [And the people said: "Do do do, do do do do, do do do do do..."](https://www.youtube.com/watch?v=PSafh_G3skU).  

# Modular simulators

If you are interested only in committing [venial sins](http://www.scborromeo.org/ccc/p3s1c1a8.htm), [VCV Rack](https://vcvrack.com) is a pretty decent open-source modular synthesis simulator.  
It is certainly easier to copy paste a few more VCOs than it is to solder up a few more modules, but nobody said sloth wasn't a sin...

# Max/MSP visual programming environments

It seems that [Max/MSP](https://cycling74.com/products/max) is the winner here, in terms of community support. 
It costs money (but not too much on an academic license), but the tutorial within the free trial is enough to give you a sense of how it works.
 The main problem (for me) is that you need to like clicking and dragging boxes into visual arrangements. 
 And the order of evaluation depends on the location of those boxes.  (Hint: It is right to left.) 
I can see the appeal, but it's not my style, because I like words and typing.

# Supercollider 

It seems that [supercollider](https://supercollider.github.io) is an open-source, text-based music programming environment (it's the successor to [CSound]()).
Under the hood, it is a client/server model (like Max/MSP), programmed with an object-oriented programming language, with support for many primitives related to sound generation and processing.  
The built in *Getting Started With SuperCollider* tutorial is fine, but [Thor Magnusson's Scoring with Supercollider](https://thormagnusson.gitbooks.io/scoring/content/index.html) seems like a more thorough introduction to the the musical aspects, with practical descriptions of audio tasks.  There's a book, but it's pretty outdated
The user community as [scsynth.org](https://scsynth.org) seems active.

Here's a cute example of a Twitter composition for Supercollider (from the intro to Thor's book); ordinarily one would add (nonsemantic) whitespace to make it more legible to the humans:
```
play{HPF.ar(({|k|({|i|SinOsc.ar(i/96,Saw.ar(2**(i+k))/Decay.ar(Impulse.ar(0.5**i/k),[k*i+1,k*i+1*2],3**k))}!6).product}!32).sum/2,40)}
```

# Mathematica?

There's a fairly rich set of [audio processing functionality in Mathematica](http://reference.wolfram.com/language/guide/AudioProcessing.html).  
For example, I've posted a few [bytebeat]((({{ site.baseurl }}{% post_url 2023-04-25-Bytebeat-(Music) %}))) examples.  But other classics, like [Karplus-Strong](https://scsynth.org) are pretty easily generated using the available primitives:
```mathematica
freq = 60;
feedback = 0.99;

(* padding runs the audio longer than the brief initial impulse *)
AudioDelay[
    AudioGenerator["Pink", .01], 1/freq, feedback, 
    PaddingSize -> 5]

(* another version with a low-pass cutoff filter *)    
AudioDelay[
    AudioGenerator["Pink", .01], 1/freq, feedback, 
    PaddingSize -> 5, Method -> {"LowpassCutoff" -> Quantity[8000, "Hertz"]}]
```

There's some powerful audio analysis tools, and of course you get the rest of the lovely functional Mathematica stack to play with, and there's a lot of general signal processing and transformation that you can do.
But it's not clear to me that it will scale up to do ambitious audio projects in the way supercollider is set up.


# Haskell?

I find the idea of the [Haskell School of Music](https://amzn.to/3BOhacs) amusing, but it seems like the ultimate [yak-shave](https://en.wiktionary.org/wiki/yak_shaving) if your goal is making music....

