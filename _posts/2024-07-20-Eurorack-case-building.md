---
title: "Eurorack case building"
date: 2024-07-20
tags: synth diy fusion360 laser
---

This spring I [came to the conclusion that I needed to expand my Eurorack case]({{ site.baseurl }}{% post_url 2024-04-30-Great-Ideas-from-Korea,-part-2 %}).  I had decided to buy one, but then again I don't need to expand it that much, and so naturally I am going to yak shave by **building a case...**

# Desirerata

- 104 HP width x 6U.
- Path of least resistance is to use [Tip-top rails](http://www.tiptopaudio.com/manuals/z-rails.pdf) from B&H.  Uses M4 screws to secure into sides.  [Notes on various types of rails](https://synthracks.com/blog/eurorack-rails-diy-guide) and dimensioning
- 1 HP = 0.2 inches, so 104 HP = 20.8 inches width.  This makes it easy (not too wasteful) to use 24" pieces of acrylic for the long direction.  If the height is not too tall, the sides can be made from a single 12"x12" piece of acrylic

# Design 

- Handy website: [Eurorack case planner](https://intafon.github.io/diyEurorackCasePlanner/) and great idea to [build it first in cardboard](https://www.musicradar.com/tuition/tech/how-to-build-your-own-cardboard-eurorack-modular-case-625196) to see if it all works
    - [An example design using this website](https://ditheringstudio.wordpress.com/2018/11/24/open-source-eurorack-skiff-design/)
- 6 U flat?  Essentially just a box?
- Or angled case  10-15 degree for first piece, additional 10-15 degree angle for second?.
- Or could just have both 6Us in the same plane, but have it angled (maybe a little kick stand?)
- Think about a carrying handle? Vents?
- 3d printed corner bumpers? 
- rubber feet cushions (could etch placement marks for these) -- could also print the feet in TPU and glue them on.
- Use [tip top bracket drawing](https://tiptopaudio.com/z-rails-brackets/) to extract dimensions
- Could be a box with oversized edges this would support the rack above surface. Cut notches rathen than dovetail
- Briefly considered (but rejected):  3d-print the end-plates with crevices to situate laser cut flat panels.  Disadvantage:  This will have a dimension of 11.2" inches in length, so its out of bounds of my Mk3+; maybe its OK if you have a large format printer. 
    - Maybe not so terrible if you build in some joints.  
- Still considering:  Laser cut/folded/riveted aluminum from SendCutSend.


# Materials

- 3mm Smoky acrylic; use laser cutter at FCLC.  Will look cool to see the LEDs and wiring inside, no? 
- **DONT USE 3MM!** I found someone who [made a cool case like this](https://blog.cornbeast.com/2017/09/my-laser-cut-transparent-orange-acrylic-sheet-eurorack-case/) and he says that 3mm was too fragile. So upgrade to the thicker stock material.
    - Also has a really nice [design with captive-t-nuts](http://fab.cba.mit.edu/content/tools/omax_waterjet/tnuts.html) which is really convenient for connecting laser cut parts
- Order from [Makerkraft](https://www.makerkraft.com/pages/order-pick-up-in-nyc?nopreview) and they'll even deliver to FCFL
- Need to design holes for mounting the power supply, switches and power input

# Power 

- Use [my existing Erica MKI power supply](https://www.ericasynths.lv/shop/diy-kits-1/mki-x-esedu-diy-1x84hp-case/); it's good for 1.25 A on +12V and -12 V (I haven't built out the 5V supply yet, but also don't need it for anything yet.)  Documentation says it is good for 4x of the complete MKI kits, and by my arithmetic this should be fine to support the existing system an ES-9 (which is about 1/3 of the total), and the drum modules (which should be less than the other complete MKI kit)
- Need to figure out mounting: a few screws in the corner, maybe run then through the case with some standoffs
- Need a flying bus cable as we are running low on sockets. [Pretty easy to make our own](https://syntherjack.net/power-supply-ribbon-cable/) so as to chain a few nearby modules together with a minimum of excess cabling.
    - [Kit with wire and 10x 16pin and 20x 10 pin with crimping tool](https://amzn.to/46ffqHx) should suffice for this project. We'll be pretty modest and just run 2 modules per cable (keeping the ES-9 on its own as it is the most power hungry)

# Final design (Dec 2024)

![rendering of case](/blog/images/2024/12/26/eurorack_render.png)

- I want this to fit inside a bookshelf case with approximate bounding dimensions of 10" x 10" x 104 HP
- Layout in [Eurorack planner](https://intafon.github.io/diyEurorackCasePlanner/planner.html): 60mm module depth, 2 rows, Row 1 angle: 20 degrees, Row 2 angle 45 degrees, material thickness 6.35mm (1/4"); holes positioned for use with [Tip-top rails](http://www.tiptopaudio.com/manuals/z-rails.pdf)
- Include mounting and switch holes for [my existing Erica MKI power supply](https://www.ericasynths.lv/shop/diy-kits-1/mki-x-esedu-diy-1x84hp-case/)---but you'll need extra screws which are longer and bolts to attach the power supply in place. 
- Plan for 0.5 mm kerf losses, but it doesn't really matter in practice. You can just design it to notional fits and 
- Design in F360
    - Resisted the urge to yakshave:  [boxes.py](https://github.com/florianfesti/boxes)
    - [Refresher video on efficient ways to define tabs cuts in F360](https://www.youtube.com/watch?v=9U2JPfkQpsE)
    - [Use the Arrange feature in the `Manufacturing` tab to layout for manufacturing](https://www.youtube.com/watch?v=jeQPJHHwVN4)---the trick here is that you have to create components that contain sketches of the bounding box of material you are cutting 
    - [Project the objects into the sketch plane](https://www.youtube.com/watch?v=CGeL6ot2mZ0)
    - [Export sketch as DXF files](https://www.youtube.com/watch?v=eKoJa2913cQ)
        - To fit this in the [trusty Trotec 300](https://wiki.fatcatfablab.org/wiki/Laser_Cutting) by dividing into two workpieces:  a 23"x15" and 12"x15" piece.  In practice, just buy a 2'x4' quarter inch baltic birch sheet and rip it into pieces that will fit inside the laser cutter.
        - **HERE ARE THE FILES:** [cut1.dxf](/blog/images/2024/12/26/cut1.dxf) and [cut2.dxf](/blog/images/2024/12/26/cut2.dxf)
- Laser cut it!
- Assemble using the [Tip-top rails](http://www.tiptopaudio.com/manuals/z-rails.pdf) and glue the joints
- Print 4x TPU feet to avoid scuffing the table:  [foot.stl](/blog/images/2024/12/26/foot.stl)
- Mount the power supply and start filling it with modules
    - Print 8x TPU standoffs for the power supply. [power_standoffs.stl](/blog/images/2024/12/26/power_standoffs.stl)



