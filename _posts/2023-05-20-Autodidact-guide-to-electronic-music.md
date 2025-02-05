---
title: "Autodidact guide to electronic music making on digital computers"
date: 2023-05-20
tags: music synth autodidact analog dsp
---

In the beginning, the LORD created [modular synthesizers]({{ site.baseurl }}{% post_url 2023-01-16-Building-the-mki-x-es.edu-synthesizer %}), and they were good. He sent his [Prophets](https://en.wikipedia.org/wiki/Prophet-5), [Bob](https://en.wikipedia.org/wiki/Robert_Moog) and [Don](https://en.wikipedia.org/wiki/Don_Buchla) and [Serge](https://en.wikipedia.org/wiki/Serge_Tcherepnin), who told all the peoples "Make a joyful noise unto the LORD all the earth, but thou shalt not eat of the fruit of the tree of the digital computer."  But the people hardened their hearts and did not listen.  So the LORD sent his prophet [Dieter](https://doepfer.de/home.htm), a voice crying in the wilderness, who said "Repent, repent! For the [Eurorack](https://en.wikipedia.org/wiki/Eurorack) is at hand." But the people said: "We have no King but [Gordon](https://en.wikipedia.org/wiki/Moore's_law)."  And so it came to pass that digital computers became numerous upon the face of the earth.  Then angel of the LORD came down and created a multitude of programs to confound their language, so that they may not understand one another's code.  "Now are you happy?" said the angel of the LORD.  [And the people said: "Do do do, do do do do, do do do do do..."](https://www.youtube.com/watch?v=PSafh_G3skU).  **A list of resources...**

# Analog synthesizers

*This is the way*

- Build one!  [I did...]({{ site.baseurl }}{% post_url 2023-01-16-Building-the-mki-x-es.edu-synthesizer %})
- Great HN thread on [Introductions to Analog Synths](https://news.ycombinator.com/item?id=27822489) — the GA Tech videos on [ECE4450 L1: Analog Circuits for Music Synthesis: Introduction (Georgia Tech course)](https://www.youtube.com/watch?v=mYk8r3QlNi8&list=PLOunECWxELQS5bMdWo9VhmZtsCjhjYNcV) look especially nice
- (June 2024) The new Mki x Erica Synth [labor kit](https://www.ericasynths.lv/shop/diy-kits-1/edu-diy-labor/?v=3076) would be a nice way to experiment with prototyping different circuits
- (book) Pinch, [Analog Days: The Invention and Impact of the Moog Synthesizer](https://amzn.to/3VoK77Z)
- (June 2024) Just found Prof. Lanterman's [EECE4050: Analog Circuits for Music Synthesis](https://youtube.com/playlist?list=PLOunECWxELQS5bMdWo9VhmZtsCjhjYNcV&si=6XK93LHZXLvUXj0m) lecture videos

# Field-Programmable analog arrays (added 27 June 2023)

*This is also the way*

- [ZRNA software-defined analog boards](https://zrna.org) for $89 including shipping (assuming they are available).  Built around the [AN231E04 analog array](http://www.anadigm.com/_doc/DS231000-U001.pdf), you get 4 comparators, 8 opamps, switched-capacitors and some auxiliary hardware that you can configure programmably (e.g., [via python](https://zrna.org/demos))...although the availability says "restocking" and the [last commit to the github repo was in 2019](https://github.com/zrna-research/zrna-api) which suggests to me that this might be unobtanium


# Analog/modular simulators

If you are interested only in committing [venial sins](http://www.scborromeo.org/ccc/p3s1c1a8.htm), [VCV Rack](https://vcvrack.com) is a pretty decent open-source modular synthesis simulator.  
It is certainly easier to copy paste a few more VCOs than it is to solder up a few more modules, but nobody said sloth was a virtue...

N.B. Andrew Olney [Computational Thinking through Modular Sound Synthesis](https://olney.ai/ct-modular-book/index.html) is any interesting resource, worth deeper study.

# Max/MSP visual programming environments

It seems that [Max/MSP](https://cycling74.com/products/max) is a popular choice. 
It costs money (but not too much on an academic license), but the tutorial within the free trial is enough to give you a sense of how it works.
 The main problem (for me) is that you need to like clicking and dragging boxes into visual arrangements. 
 And the order of evaluation depends on the location of those boxes.  (Hint: It is right to left.) 
I can see the appeal, but it's not my style, because I like words and typing.  Or fooling LLMs into doing the words and typing for me.

# Supercollider 


*And there came a voice to him, Rise, Peter, make music with your computer.  But Peter said, Not so, Lord; for I have never made music with anything digital. And the voice spake unto him again the second time, What the LORD hath cleansed, that call not thou common. ... And then Peter laid aside his soldering iron and went down to Joppa...*


It seems that [supercollider](https://supercollider.github.io) is an open-source, text-based music programming environment (it's the successor to [CSound](https://csound.com)).
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

# Sonic Pi

[Sonic Pi](https://sonic-pi.net) is a livecoding environment built on top of supercollider


# Mathematica?

There's a fairly rich set of [audio processing functionality in Mathematica](http://reference.wolfram.com/language/guide/AudioProcessing.html).  
For example, I've posted a few [bytebeat]({{ site.baseurl }}{% post_url 2023-04-25-Bytebeat-(Music) %}) examples.  Other classics, like [Karplus-Strong string synthesis](https://en.wikipedia.org/wiki/Karplus–Strong_string_synthesis) are pretty easily generated using the available primitives:
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

Alternatively [tidalcycles](https://sonic-pi.net) is a Haskell-based domain specific language for driving supercollider (comparable to, but with some differences from Sonic-Pi, mentioned above)

# Glicol

- (15 July 2024) [Glicol](https://glicol.org) is a minimalist programming language for music generation, designed for live coding.  Really slick: You specify a graph, not unlike modular synthesis. Has built-in oscillators and filters.  Specifying notes and duration is not so clear in the tutorial, but a [youtube video](https://www.youtube.com/watch?v=LA78okAHtlM&list=PLT4REhRBWaOOrLQxCg5Uw97gEpN-woo1c&index=2) and the [author's GPT-4 prompt](https://github.com/chaosprint/glicol/discussions/125) help clarify some of this. 
    
# Digital Signal Processsing

- (03 Oct 2024) [Jonathan Dubois](https://scholar.google.com/citations?user=0WXE25AAAAAJ&hl=en&oi=ao) asks: *I do have a dumb question about analog synthesizers though..  Aside from the cool factor of actual analog, where are the open source digital patch panels?  it doesnt seem like it should be that hard to compute pretty much anything you want in real time.* 

Indeed, it's a thing. 

- I've seen the [DaisySeed](https://electro-smith.com/products/daisy-seed)-based [https://electro-smith.com/products/patch] as one example.  

- Somewhat less polished in terms of final product is the [Pico Audio Development Kit](https://github.com/DatanoiseTV/PicoADK-Hardware?tab=readme-ov-file)

- Closely related: The [VultDSP](https://www.vult-dsp.com/vult-language) language (supported on the PicoADK)

- The [Digital Signal Processing Primer](https://amzn.to/4dIAbNF) has been languishing in my cart for a few years, as has [Hamming's Digital Filters](https://amzn.to/4gZ7ejx) book.

# Ableton Live

If you can't beat 'em, join 'em.  [Notes]({{ site.baseurl }}{% post_url 2025-01-27-Intro-to-EDM-101 %}) There's nothing really text-based about this, but under the hood the projects are just XML files which you can parse if you like. 
