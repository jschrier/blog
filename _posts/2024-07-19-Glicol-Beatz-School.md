---
title: "Glicol Beatz School"
date: 2024-07-19
tags: music synth drum
---

*My name is DJ Borscht, I'm full of beatz...* **Basic rhythm patterns from [Pocket Operations](https://shittyrecording.studio/) implemented in [Glicol](https://glicol.org/)...** 

# Basic Patterns

## One and Seven and Five and Thirteen

Keeping it simple and writing out all 16 sequence locations with spaes

``
bd: seq 60 _ _ _  _ _ 60 _  _ _ _ _  _ _ _ _   >> sp \808bd
sn: seq _ _ _ _  60 _ _ _  _ _ _ _  60 _ _ _ >> sp \808sd  
``

## Boots and Cats

Glicol lets you run the sequences at different rates, so we can try that here to not have to write so many blanks

```
bd: speed 2.0 >> seq 60 _   >> sp \808bd
sn: speed 2.0 >> seq _ 58   >> sp \808sd  
ch: speed 4.0 >> seq 62 _ 62 _ >> sp \808ch
```

## Tiny House

We probably just want to make this

```
oh: speed 4.0 >> seq _ 60_  >> sp \808oh
bd: speed 4.0 >> seq 60 _ >> sp \808bd
```

## Good to go

```
bd: speed 1.0 >> seq 60_ _60 _ 60_ _ 60_ _ _ >> sp \808bd
sn: speed 2.0 >> seq _ 60_  >> sp \808sd
```

## Hip hop

```
bd: speed 1.0 >> seq 60 _ 60 _  _ _ 60 60 _ _ _ _ _ _ 60 _>> sp \808bd
sn: speed 2.0 >> seq _ 60  >> sp \808sd
ch: speed 4.0 >> seq 60 60 >> sp \808ch
```


# The Secrets of Dance Music Production

## Groove Essentials: funky ghost snares (p.55)

"To hear how the use of so-called 'ghost' notes can inject life and interest into a static beat, program a basic drum groove comprised of eigth note closed hats, a kick on beats 1 and 3 of the bar, and a snare on beats 2 and 4. [It's a straightforward disco-style beat](https://www.dropbox.com/scl/fo/717xasxisk22opkyhayjy/ADB3KuGJ7A081dWxfGB9Hwc/English/Ch%201%20Drums%20and%20beats/p55%20Ghost%20snares?preview=step+1+start+beat.wav&rlkey=s1emm4v0hz70n6lc12pprsr6a&subfolder_nav_tracking=1&st=3mwkked9&dl=0) that's about as vanilla as they come."

```
ch: seq 60 60 60 60 60 60 60 60 >> sp \808ch  
ki: seq 60 _ _ _ 60 _ _ _  >> sp \kick1 
sna: seq _ _ 60 _ _ _ _ 60 _ _ >> sp \808sd >> mul 0.5
```

"Ghost notes are quieter hits - invariable on the snare, that sit around the main hits. Adding an additiona snare on the final 16th note of beat two helps break the straight rhym, instantly [giving the groove a more characterful 'skipping' feel](https://www.dropbox.com/scl/fo/717xasxisk22opkyhayjy/ADB3KuGJ7A081dWxfGB9Hwc/English/Ch%201%20Drums%20and%20beats/p55%20Ghost%20snares?preview=step+2+new+snare.wav&rlkey=s1emm4v0hz70n6lc12pprsr6a&subfolder_nav_tracking=1&st=7k4euar3&dl=0)"

```
ch: seq 60 60 60 60 60 60 60 60 >> sp \808ch  
ki: seq 60 _ _ _ 60 _ _ _  >> sp \kick1 
sna: seq _ _ 60 _ _ _ _ 60 _ _ >> sp \808sd >> mul 0.5
ghost: seq _ _ _ _60 _ _ _ _ >> sp \snare2 >> mul 0.5
```

# Beat starts: House and deep house

[Low tempo house](https://www.dropbox.com/scl/fo/717xasxisk22opkyhayjy/AANhFq9ZleYAnwUepDVFL-Y/English/Ch%201%20Drums%20and%20beats/Beats%20Dissected%20including%20pp%2052-69?preview=p56+low+tempo+house.mp3&rlkey=s1emm4v0hz70n6lc12pprsr6a&subfolder_nav_tracking=1&st=pshm3s82&dl=0) 

```
??? 
```