---
Title: "Autodidact guide to electronic music making on digital computers"
Date: 2023-05-20
Tags: music synth autodidact
---

In the beginning, the LORD created [modular synthesizers]((({{ site.baseurl }}{% post_url 2023-01-16-Building-the-mki-x-es.edu-synthesizer %}))), and they were good. He sent his [Prophets](https://en.wikipedia.org/wiki/Prophet-5), [Bob](https://en.wikipedia.org/wiki/Robert_Moog) and [Don](https://en.wikipedia.org/wiki/Don_Buchla) and [Serge](https://en.wikipedia.org/wiki/Serge_Tcherepnin), who told all the peoples "Make a joyful noise unto the LORD all the earth, but thou shalt not eat of the fruit of the tree of the digital computer."  But the people hardened their hearts and did not listen.  So the LORD sent his prophet [Dieter](https://doepfer.de/home.htm), a voice crying in the wilderness, who said "Repent, repent! For the [Eurorack](https://en.wikipedia.org/wiki/Eurorack) is at hand." But the people said: "We have no King but [Gordon](https://en.wikipedia.org/wiki/Moore's_law)."  And so it came to pass that digital computers became numerous upon the face of the earth.  Then angel of the LORD came down and created a multitude of programs to confound their language, so that they may not understand one another's code.  "Now are you happy?" said the angel of the LORD.  [And the people said: "Do do do, do do do do, do do do do do..."](https://www.youtube.com/watch?v=PSafh_G3skU).  **A list of resources...**

# Analog synthesizers

*This is the way*

- Build one!  [I did...]({{ site.baseurl }}{% post_url 2023-01-16-Building-the-mki-x-es.edu-synthesizer %})
- Great HN thread on [Introductions to Analog Synths](https://news.ycombinator.com/item?id=27822489) — the GA Tech videos on [ECE4450 L1: Analog Circuits for Music Synthesis: Introduction (Georgia Tech course)](https://www.youtube.com/watch?v=mYk8r3QlNi8&list=PLOunECWxELQS5bMdWo9VhmZtsCjhjYNcV) look especially nice

# Analog/modular simulators

If you are interested only in committing [venial sins](http://www.scborromeo.org/ccc/p3s1c1a8.htm), [VCV Rack](https://vcvrack.com) is a pretty decent open-source modular synthesis simulator.  
It is certainly easier to copy paste a few more VCOs than it is to solder up a few more modules, but nobody said sloth was a virtue...

# Max/MSP visual programming environments

It seems that [Max/MSP](https://cycling74.com/products/max) is a popular choice. 
It costs money (but not too much on an academic license), but the tutorial within the free trial is enough to give you a sense of how it works.
 The main problem (for me) is that you need to like clicking and dragging boxes into visual arrangements. 
 And the order of evaluation depends on the location of those boxes.  (Hint: It is right to left.) 
I can see the appeal, but it's not my style, because I like words and typing.  Or fooling LLMs into doing the words and typing for me.

# Supercollider 

It seems that [supercollider](https://supercollider.github.io) is an open-source, text-based music programming environment (it's the successor to [CSound]()).
Under the hood, it is a client/server model (like Max/MSP), programmed with an object-oriented programming language, with support for many primitives related to sound generation and processing.  
There's a hardcopy book, but it's allegedly pretty outdated.
The (online) built in *Getting Started With SuperCollider* tutorial is okay, but emphasizes programming (rather than sonic) qualities.
[Thor Magnusson's Scoring with Supercollider](https://thormagnusson.gitbooks.io/scoring/content/index.html) website/book is a more thorough introduction to the the musical aspects, with practical descriptions of audio tasks.  
What I like about it is that he gets you into making sounds (and understanding complex combinations of sound generation) in a more direct way.
The user community as [scsynth.org](https://scsynth.org) seems active.

Here's a cute example of a Twitter composition for Supercollider (from the intro to [Thor's book](https://thormagnusson.gitbooks.io/scoring/content/index.html)); ordinarily one would add (nonsemantic) whitespace to make it more legible to the humans:
```
play{HPF.ar(({|k|({|i|SinOsc.ar(i/96,Saw.ar(2**(i+k))/Decay.ar(Impulse.ar(0.5**i/k),[k*i+1,k*i+1*2],3**k))}!6).product}!32).sum/2,40)}
```

It really shines for explaining concepts.  For example, the role of harmonics (`Blip` creates a signal with some number of equally weighted harmonics, and `freqscope` displays a live plot of the frequencies):
```
{Blip.ar(256, MouseX.kr(1, 20))}.freqscope // using the Mouse left-right to have 
```

Additionally things like [ProxySpace](https://thormagnusson.gitbooks.io/scoring/content/PartI/chapter_2.html) as a way of interaction are really impressive.  The thought given to [synthesis definition, patterns, and tempo clocks](https://thormagnusson.gitbooks.io/scoring/content/PartI/chapter_3.html) is quite sophisticated, and designed around the needs of sound makers.

[Open Sound Control (OSC)](https://thormagnusson.gitbooks.io/scoring/content/PartI/chapter_4.html) is also pretty neat, and I bet you could build a Eurorack module based on the RPi Pico W that could hang out and and send/retrieve OSC messages.  Somebody has written an [OSC client for the Pico (receive messsages only)](https://github.com/madskjeldgaard/PicoOSC) so that's a start...

And if [1-bit music]({{ site.baseurl }}{% post_url 2023-04-20-1-Bit-Music %}) is your thing, the `Impulse` and `Dust` (random impulse) Ugens will be your thing.

# Mathematica?

There's a fairly rich set of [audio processing functionality in Mathematica](http://reference.wolfram.com/language/guide/AudioProcessing.html).  
For example, I've posted a few [bytebeat]((({{ site.baseurl }}{% post_url 2023-04-25-Bytebeat-(Music) %}))) examples.  Other classics, like [Karplus-Strong string synthesis](https://en.wikipedia.org/wiki/Karplus–Strong_string_synthesis) are pretty easily generated using the available primitives:
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
But it's not clear to me that it will scale up to do ambitious audio projects in the way supercollider is set up, nor will you have specialty audio modules like supercollider's `MoogFF` (a digital implementation of the Moog VCF)


# Haskell?

I find the idea of the [Haskell School of Music](https://amzn.to/3BOhacs) amusing, but it seems like the ultimate [yak-shave](https://en.wiktionary.org/wiki/yak_shaving) if your goal is making music....

