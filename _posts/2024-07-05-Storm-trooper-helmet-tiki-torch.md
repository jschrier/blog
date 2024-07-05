---
title: "Storm-trooper helmet tiki torch"
date: 2024-07-05
tags: 3dprinting tiki sculpture
---

**Premise:**  Use cement casting to make a storm-trooper helmet tiki torch...

## Inspiration

(while drinking beers with [Crayonfou](https://crayonfou.com) at Focal Point) Remember that scene in *Return of the Jedi* where the Ewoks put storm-trooper helmets on a sticks?  Actually we could not find it, although there was  one where they play the helmets as drums/marimbas. (But there is a scene of storm-trooper helmets on sticks in the *Mandalorian)*.

![021hyovfyew8x](/blog/images/2024/7/5/021hyovfyew8x.png)

Some [nerds have made versions of the helmets-on-sticks for Halloween decorations](https://www.therpf.com/forums/threads/stormtrooper-helmets-on-spikes.345744/), but I want something more whimsical:  A [tiki torch](https://amzn.to/3WajOnw)! To do this, we would need to cast the helmets out of a flame-resistant material...how about cement?  Well, just that morning I saw a [hackaday thread on printing molds out of TPU to do cement casting.](https://hackaday.com/2024/07/01/casting-concrete-with-a-3d-printed-mould/)  Perfect! 

## Resources/Questions

[Stormtrooper helmet model on printables ](https://www.printables.com/model/3041-stormtrooper-anh-helmet/files)-- can fit this at 60% scale on a Prusa MK3S+

![12vgd6axgho22](/blog/images/2024/7/5/12vgd6axgho22.png)

**Design questions:**

- Should flame be visible through the eyes (i.e., partially hollow interior cavity) or flame emerging from top of head? (solid head, paint the eye holds). No clear opinion.

**Status:**

- Unlikely to do implement, as I do not have  a backyard and open flames are forbidden on the roof

## Some mockups with Dall-E-3

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
    {"Prompt" -> "A Star Wars stormtrooper helmut on a stick, in the form of a tiki torch", "Model" -> "dall-e-3"}]
```

![0cmcjyb6w727t](/blog/images/2024/7/5/0cmcjyb6w727t.png)

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
    {"Prompt" -> "A clearing with people having a tiki party.  The tiki torches that are in the background and foreground are clearly Star Wars stormtrooper helmets on sticks, and have flames visible.", "Model" -> "dall-e-3"}]
```

![1g0pyinzuzull](/blog/images/2024/7/5/1g0pyinzuzull.png)

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
    {"Prompt" -> "A tiki party scene. The tiki torches have flames visible from the top and are shaped like star wars stormtrooper helmets.", "Model" -> "dall-e-3"}]
```

![0id4bps6kx8sx](/blog/images/2024/7/5/0id4bps6kx8sx.png)

```mathematica
ToJekyll["Storm-trooper helmet tiki torch", "3dprinting tiki sculpture"]

(*Missing["NotAvailable"]["Storm-trooper helmet tiki torch", "3dprinting tiki sculpture"]*)
```
