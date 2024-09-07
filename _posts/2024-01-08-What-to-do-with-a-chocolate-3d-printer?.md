---
title: "What to do with a chocolate 3d-printer?"
date: 2024-01-08
tags: art business 3dprinting dall-e-3
---

*Premise:*  [Relatively affordable chocolate 3d-printers](https://cocoapress.com/products/cocoa-press-3d-chocolate-printer-diy-kit) (see [video](https://youtube.com/shorts/FUGps9rICwA?si=e35sMNn0XoKHyM_s))  are now available ([some assembly required](https://www.tomshardware.com/3d-printing/cocoa-press-3d-printer-review)).  **What types of business could you start with this?...**

It seems that the sweet spot are cases where:

- You only want one (so [making a mold](https://youtu.be/DRcFh_Kop9U) is a waste of time)

- You are trying to make a shape that is not easily produced in a mold (but also doesn't have excessive overhangs, etc. that would require printing with supports)

- Having an intricate interior structure (rather than just a shell) is a benefit, for the purpose of texture/mouthfeel, etc. 

**Idea:**   Make 3d-scans of people's heads and then print realistic chocolate versions for cake-toppers!  

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world in which we can 3d-print chocolate.  Depict a realistic, 3d-printed chocolate face, emerging from a cake, at a party", "Model" -> "dall-e-3"}]
```

![0w7rx6n9684iw](/blog/images/2024/1/8/0w7rx6n9684iw.png)

Instead of having generic bridge/groom caketoppers at weddings, why not have realistic faces of the bridge/groom printed out of chocolate?

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world in which we can 3d-print chocolate.  Depict a realistic, 3d-printed chocolate face of the bride and groom at a wedding, emerging from the top of their wedding cake.  The bridge and groom are cutting the cake and smiling at the guests.", 
   "Model" -> "dall-e-3"}]
```

![1hruyrcvip5kz](/blog/images/2024/1/8/1hruyrcvip5kz.png)

But you could also use this for celebrating technical milestones. Also, kids love dinosaurs (especially at [$75K birthday parties](https://www.nytimes.com/2023/04/13/style/la-children-parties.html)) :

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world in which we can 3d-print chocolate.  A group of paleontologists are celebrating their new discovery with a party and there is a cake. On top of the cake is a realistic 3d-printed chocolate dinosaur skeleton.", 
   "Model" -> "dall-e-3"}]
```

![0lasnac6ibool](/blog/images/2024/1/8/0lasnac6ibool.png)

A natural application would be for fund-raisers:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world where realistic 3d-printed chocolate structures exist.  At a fundraiser, a realistic 3d chocolate replica of the Milan Duomo is on top of the cake.", 
   "Model" -> "dall-e-3"}]
```

![17cklbkqm7u35](/blog/images/2024/1/8/17cklbkqm7u35.png)

One also dares to think about [sexual chocolate](https://en.wikipedia.org/wiki/Coming_to_America)--we'll keep it classy with some [tasteful nudes](https://en.wikipedia.org/wiki/David_(Michelangelo)): 

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world in which we can 3d-print chocolate.  Depict a replica of Michelangelo's David statue, 3d-printed out of chocolate, on top of a cake.", 
   "Model" -> "dall-e-3"}]
```

![1ejopj802blmc](/blog/images/2024/1/8/1ejopj802blmc.png)

## Yael's big adventure

For some reason, along the way I thought it would be funny to make a cake depicting the [biblical story of Yael from the Book of Judges](https://en.wikipedia.org/wiki/Jael). (There are no holidays that celebrate her, per se., but it is a popular name in Israel, so maybe this would work for birthday cakes.). Here are a few attempts at prompt engineering:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world in which we can 3d-print chocolate. Depict a cake, with a 3d-printed chocolate statues of a man's head.  A real life woman at the party cuts the chocolate head and red raspberry jam oozers out. Make this reminiscent of the Biblical story of Yael or Jael.", 
   "Model" -> "dall-e-3"}]
```

![17hv3xy9wgxgi](/blog/images/2024/1/8/17hv3xy9wgxgi.png)

I started getting some "unacceptable content" warnings as I added more details (apparently smashing tent pegs into people's heads is *not cool* for our OpenAI overlords, even though it is [IN THE BIBLE](https://www.youtube.com/watch?v=ebGOhAGFC4M)!).  Here was one approach: 

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world in which we can 3d-print chocolate. Depict a cake, with a 3d-printed chocolate statues of a man's head.  A real life woman pushes a tent-peg into the chocolate head and red raspberry jam oozes out. Make this reminiscent of the Biblical story of Yael or Jael.", 
   "Model" -> "dall-e-3"}]
```

![1soxh22o6xt72](/blog/images/2024/1/8/1soxh22o6xt72.png)

But we want it to be in the back of the head. For some reason the white-chocolate tent peg and the dark chocolate head get mixed up, and where did our tent peg go?:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world in which we can 3d-print chocolate. Depict a cake, with a 3d-printed chocolate statues of a man's head on top.  From the back of the 3d-printed chcoolate head is a white-chocolate 3d-printed tent peg and red raspberry jam is oozing out on to the cake.  This is at a party.  There is a real-life woman, who is holding a tent peg in one hand and is serving slices of cake with the other hand.  Make this reminiscent of the Biblical story of Yael (also known as Jael) from the Book of Judges.", 
   "Model" -> "dall-e-3"}]
```

![1fqmvqmyi6t0u](/blog/images/2024/1/8/1fqmvqmyi6t0u.png)

Enough with the tent peg.  Let's just smash the head open (and make it look like a Canaanite...):

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> 
    "Consider a world in which we can 3d-print chocolate. Depict a cake, with a 3d-printed chocolate statues of a man's head on top.  From the back of the 3d-printed chocolate head is a white-chocolate 3d-printed tent peg and red raspberry jam is oozing out on to the cake.  This is at a party.  There is a real-life woman, who is holding a mallet in one hand and is serving slices of cake with the other hand.  Make this reminiscent of the Biblical story of Yael (also known as Jael) from the Book of Judges. To do that, make the man's head look vaguely like a Canaanite of biblical antiquity.", 
   "Model" -> "dall-e-3"}]
```

![0rx9o7d9cvwqn](/blog/images/2024/1/8/0rx9o7d9cvwqn.png)

TBH, I like the first one the best.

```mathematica
ToJekyll["What to do with a chocolate 3d-printer?", 
  "art business 3dprinting dall-e-3"]
```
