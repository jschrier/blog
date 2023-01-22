---
Title: "Autodidact guide to advanced manufacturing"
Date: 2022-12-31
Tags: 3dprinting, fusion360, cnc, autodidact
---

Interested in teaching yourself about [advanced manufacturing](https://en.wikipedia.org/wiki/Advanced_manufacturing), but don't want to commit to a [full-time apprenticeship](https://www.nyc.gov/site/sbs/careers/construction.page)?  Here is my autodidact's guide to learning some basic skills at home in your spare time... 

## Build a 3d-printer

Build a 3d-printer from parts to understand the mechanics of what is going on.  
[FDM](https://en.wikipedia.org/wiki/Fused_filament_fabrication) is the way to go when starting out...easier to work with, and can do many of the things you want.

I had a good experience building the [Prusa MK3+](https://www.prusa3d.com) from a kit.
It comes with a comprehensive build manual (which doubles as a "fix it" manual), and it has operated reliably for me. Additionally, as many of the parts are themselves 3D-printed, you'll learn some of the patterns of 3d-design (like embedded hex nuts, etc.)

Having a printer to play with is very useful for getting the _Fingerspitzengefuhl_ of tolerances, ways of avoiding support structures (or using it as necessary), perimeter/infill design, and the properties of different materials. 
Make lots of prints, and think about these issues.

## Learn 3D design

There are two general approaches to designing objects: Algorithmic (programming-like) computational geometry and CAD-based approaches.  
In my opinion, you will want to try both.

**Algorithmic** For algorithmic approaches, [OpenSCAD](https://openscad.org) is the most popular.  
[Mathematica also supports 3D printing](https://reference.wolfram.com/language/guide/3DPrinting.html), although using the default computational geometry objects can get very slow for very complicated objects and you'll want to use the built-in [OpenCASCADE Link](https://reference.wolfram.com/language/OpenCascadeLink/tutorial/UsingOpenCascadeLink.html) for more complicated jobs.  
As an example, my first self-made design was a Bauhaus chess set, comprised of very simple objects.  
Later, I used OpenCASCADE to develop an [algorithmically-designed mail caddy]({{ site.baseurl }}{% post_url 2022-07-22-Generating-3d-designs-with-OpenCASCADE-Link %}).
The power of this approach is that you generate the solids programmatically, with all of the joy and pain that can bring.


**CAD** You can play around with open-source packages if you like, but  [Autodesk Fusion360](https://www.autodesk.com/products/fusion-360/overview) is the king (it's free for academics, and free with some big limitations for others).  
I recommend [Kevin Kennedy's Learn Fusion 360 in 30 days](https://www.youtube.com/watch?v=WKb3mRkgTwg&list=PLrZ2zKOtC_-DR2ZkMaK3YthYLErPxCnT-) series as a guide.  

You could build a space shuttle in F360 (and sometimes it feels like it...).  
Eventually I'll post a few of the objects I've developed.
The power of this approach is that you generate the solids using a graphical user interface, and (if you use F360) can tap into a wide array of materials analysis methods, collision checking, generative design, etc.  


## Design and print a bunch of things

This is the key: play with layer thickness, design tolerances, objects that require strength (through perimeters, etc.)

## Subtractive methods: Laser

*Laser cutting* is a good way to start with subtractive methods. 
If your [local hacker-space](https://wiki.fatcatfablab.org/wiki/Laser_Cutting) has a laser cutter, then so much the better!

I got my start using the [SendCutSend](https://sendcutsend.com) service---very straightforward to export a DXF file (or other vector file) and get cut objects in a plethora of materials (including metals).
Again, I recommend [Kevin Kennedy's tutorial](https://www.youtube.com/watch?v=PN4bd4rr4z8&list=PLrZ2zKOtC_-B_HAKUEXhaHyK-2ksfFx2K) on the topic.
All of these skills are transferable to other laser cutters as well.

(They'll also do folded sheet metal parts...and yes, [Kevin has a tutorial on how to design folded sheet metal parts in F360](https://www.youtube.com/watch?v=NXu8vVYvjrg) )

Now, strictly speaking, you don't need to learn any modeling to do interesting things with a laser cutter---you can use your favorite vector graphics softwares to design cuts and etchings.  
But, it can be very powerful to combine laser cut parts with printed parts, and CAD software will let you do that in a straightforward way. 

## Subtractive methods: CNC 

*CNC* is quite a bit more complicated, messy, and potentially dangerous than 
the above options.  
I would recommend you find a guru who will teach you the ropes before you buy one (or use the one in your [friendly neighborhood hacker-space](https://wiki.fatcatfablab.org/wiki/CNC_Router)).
You will need to consider materials, appropriate bits, setup and operation of your particular machine, dust management, spoilboards, etc. 
You'll also acquire a new appreciation for machine tool parts---get yourself a copy of the [Tools Today catalog](http://toolstoday.com)!

If you've learned F360 already, then at least the program design is relatively straightforward.  
Starting with your model, it is almost self-explanatory how to do simple 2D operations....but useful to have a guide. 
Two videos that I found helpful were: a [12 minute video](https://www.youtube.com/watch?v=iqnvzxuXFTQ) and a [90 minute video](https://www.youtube.com/watch?v=TfqBKqzxl44&t=3s) My [first projects turned out OK](https://twitter.com/JoshuaSchrier/status/1608120496821870592).

# Advanced resources

(gleaned from a [12 Jan 2023 hackernews thread](https://news.ycombinator.com/item?id=34342251)...haven't fully explored these yet)

* [Guerilla guide to CNC and resin casting (2013-2015)](https://lcamtuf.coredump.cx/gcnc/) 
* [Resources for learning machining (2022)](https://www.r-c-y.net/posts/machining/)
* [Dan Gelbart video series on prototyping](https://www.youtube.com/playlist?list=PLSGA1wWSdWaTXNhz_YkoPADUUmF1L5x2F) - the man loves his waterjet! But also lots of interesting practical advice on design that is applicable to other modes
* [Textbook recommendations for learning Mechanical Engineering](https://news.ycombinator.com/item?id=34344285) (of course, if you're an autodidact the exact version doesn't matter, a used copy of any version would suffice)
    * [Engineering Mechanics Statics](https://amzn.to/3Zyua0p) by Meriam and Kraige
    * [Shigley's Mechanical engineering Design](https://amzn.to/3QKb0k7)



*updated 16 Jan 2022*