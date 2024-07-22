---
title: "Eurorack case building"
date: 2024-07-20
tags: synth diy fusion360
---

This spring I [came to the conclusion that I needed to expand my Eurorack case](({{ site.baseurl }}{% post_url 2024-04-30-Great-Ideas-from-Korea,-part-2 %} )...).  I had decided to buy one, but then again I don't need to expand it that much, and so naturally I am going to yak shave by building a case...

# Desirerata

- 104 HP width x 6U.
- Path of least resistance is to use [Tip-top rails](http://www.tiptopaudio.com/manuals/z-rails.pdf) from B&H.  Uses M4 screws to secure into sides.  [Notes on various types of rails](https://synthracks.com/blog/eurorack-rails-diy-guide) and dimensioning
- 1 HP = 0.2 inches, so 104 HP = 20.8 inches width.  This makes it easy (not too wasteful) to use 24" pieces of acrylic for the long direction.  If the height is not too tall, the sides can be made from a single 12"x12" piece of acrylic

# Design 

- Handy website: [Eurorack case planner](https://intafon.github.io/diyEurorackCasePlanner/) and great idea to [build it first in cardboard](https://www.musicradar.com/tuition/tech/how-to-build-your-own-cardboard-eurorack-modular-case-625196) to see if it all works
    - [An example design using this website](https://ditheringstudio.wordpress.com/2018/11/24/open-source-eurorack-skiff-design/)
- 6 U flat?  Essentially just a box?
- Or angled case  45 degree for first piece, additional 22.5 degree angle for second?.
- Or could just have both 6Us in the same plane, but have it angled (maybe a little kick stand?)
- Think about a carrying handle? Vents?
- 3d printed corner bumpers? 
- rubber feet cushions (could etch placement marks for these)
- Use [tip top bracket drawing](https://tiptopaudio.com/z-rails-brackets/) to extract dimensions
- Could be a box with oversized edges this would support the rack above surface. Cut notches rathen than dovetail


# Materials

- 3mm Smoky acrylic; use laser cutter at FCLC.  Will look cool to see the LEDs and wiring inside, no? 
- Order from [Makerkraft](https://www.makerkraft.com/pages/order-pick-up-in-nyc?nopreview) and they'll even deliver to FCFL
- Need to design holes for mounting the power supply, switches and power

# Power 

- Use [my existing Erica MKI power supply](https://www.ericasynths.lv/shop/diy-kits-1/mki-x-esedu-diy-1x84hp-case/); it's good for 1.25 A on +12V and -12 V (I haven't built out the 5V supply yet, but also don't need it for antyhing.)  Documentation says it is good for 4x of the complete MKI kits, and by my arithmetic this should be fine to support the existign system an ES-9, and the drum modules
- Need to figure out mounting: a few screws in the corner, maybe run then through the case with some standoffs
- Need a flying bus cable as we are running low on sockets. [Pretty easy to make our own](https://syntherjack.net/power-supply-ribbon-cable/) so as to chain a few nearby modules together with a minimum of excess cabling.  
