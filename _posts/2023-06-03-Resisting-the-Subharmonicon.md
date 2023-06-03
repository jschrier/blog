---
Title: "Resisting the Subharmonicon"
Date: 2023-06-02
Tags: music synth analog supercollider
---

The [Moog Subharmonicon](https://www.moogmusic.com/products/subharmonicon) ... who can resist an analog synth based on the [subharmonic generative music theory of Schillinger](https://en.wikipedia.org/wiki/Joseph_Schillinger).  [See it in action, with tutorial.](https://www.youtube.com/watch?v=f5rsu8IdN8A) Polyrhythms and subharmonics, oh my. A trip to [Perfect Circuit](http://perfectcircuit.com) this weekend? **Or save $600 and do it in software...**

# Building a Subharmonicon in VCV rack

[Omri Cohen explains how (youtube)](https://www.youtube.com/watch?v=r7_U4Dgln-0)

Polyrhythm:
- Clock 
- 4x dividers 
- Octatrig
- Bus router
- Sequencer 
- 2x VCOs
- 4x frequency dividers
- 2x mixers
- matrix mixer 



# Supercollider

[A first approximation)(https://scsynth.org/t/moog-subharmonicon/2483) --- copied below for easy references


```
// Saw wave version

(
SynthDef(\subh2,{
	arg freq = 440, div = 4;
	var osc, sub, env;
	osc = Saw.ar(freq);
	p = PulseDivider.ar(osc, div);
	a = 0.5 * freq/(div * s.sampleRate);
	sub = LeakDC.ar(Phasor.ar(p, 1, 0, inf, 0) * a);
	env = EnvGen.ar(Env.perc(0.001,8), doneAction:2);
	Out.ar(0, Splay.ar(osc + sub * env));
}).add;
)

(
Pbind(
	\instrument, \subh2,
	\degree, Pseq([0,5,9,[0,12]], inf),
	\dur, 2,
	\div, Pseq([[2,4,8],[3,6,9],[4,8,16]],inf),
	\strum,0.2
).play;
)
```

or

```
// Square wave version

(
SynthDef(\subh3,{
	arg freq = 440, div = 4;
	var osc, sub, env;
	osc = Saw.ar(freq);
	p = PulseDivider.ar(osc, div * 0.5);
	sub = 0.5 * LeakDC.ar(ToggleFF.ar(p) - 0.5);
	env = EnvGen.ar(Env.perc(0.001,8), doneAction:2);
	Out.ar(0, Splay.ar(osc + sub * env));
}).add;
)

(
Pbind(
	\instrument, \subh3,
	\degree, Pseq([0,5,9,[0,12]], inf),
	\dur, 2,
	\div, Pseq([[2,4,8],[3,6,9],[4,8,16]],inf),
	\strum,0.2
).play;
)
```

# Hardware clones

Apparently Behringer has announced [SPICE](https://www.gearnews.com/behringer-spice-the-long-expected-subharmonicon-clone-is-revealed/) which is only $249 (versus $600) 