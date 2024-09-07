---
title: "Imaginary Syllabi: Additive Manufacturing Lab"
date: 2024-08-05
tags: 3dprinting diy art science teaching imaginary-syllabi
---

**Premise:** Move beyond [mere autodidacticism]({{ site.baseurl }}{% post_url 2022-12-31-Autodidact-guide-to-advanced-manufacturing %} ) and equip a comprehensive, but minimal teaching lab for a course on material science / additive manufacturing processes... 


# Why?

- I think its cool/fun. 

- Create an excuse to teach others while doing the things I like, and use university lab space.

- Increase culture of materials science at Fordham / NYC.

- Create opportunities for research projects (e.g., use of LLMs to assist in debugging?, use AI-directed experiment planning to optimize new materials/processing conditions?)


# First principles and foundations

- *Conceptually comprehensive:* Include all of the major areas of materials (polymers, metals, ceramics) and try to include many (but not all) additive modalities.  Aim for illustrating basic transferable principles, that have a connection to underlying fundamental chemistry...sort of like the lab complement to [Shackelford's intro materials science textbook](https://amzn.to/3JNUFbz)   

- *Safety:* We don't want powder explosion hazards, etc.  Focus on relatively safe methods

- *Affordable purchase and operation:*  Try to limit ourselves to "prosumer" devices and processes;  things like powder bed and material jetting methods are probably out in our scope (unless it is a [sugar-based powder bed fusion device]({{ site.baseurl }}{% post_url 2023-12-16-Feuerzangenbowle-Zuckerhut-Designs %} )) Ideally no single item is above the $5000 capital equipment threshold, to minimize paperwork. Assemble this piecemeal using chair funds over a few years.


# Polymer

- *Fused deposition modeling:* Obviously a must have, but also really easy.  Get a [Prusa MK4](https://www.prusa3d.com/product/original-prusa-mk4-2) ($1100 assembled or $700 DIY) or [XL $2K](https://www.prusa3d.com/product/original-prusa-xl/) and be done with it. I've personally found the MK3S+ super reliable. MK4 has easy nozzle changes, which will be important for doing some of the sinter-based metal products
    - Learning goals:  Polymer structure/property relations (PLA, PETG, TPU, ABS, etc.)
    - Basic tricks of the trade: modeling, 3d file formats, slicers
    - Good for introducing ideas about: anisotropy (of strength under compression and tension, which is more pronounced because of layering, design for manufacture, processing conditions (temperature, humidity, curing (in the case of PLA+)))

- *Stereolithography printer.*  Dedicate one to polymers, [Prusa SL1](https://www.prusa3d.com/product/original-prusa-sl1s-speed-3d-printer-cw1s-bundle/) would be fine; bundled with appropriate UV curing source for $2600

- Side-quest [electroplating](https://www.youtube.com/watch?v=pD73QydSlhw )

**EHS Needs:** Fume hood venting (snorkel), basic PPE for SLS processing


# Ceramics

- **Kiln:**  We're going to need to program this for other stuff, so get a fancier electric one; 2350 F (1288 C) is fine (might put porcelain out of reach, but enough for lots of other ceramics), smaller volume is fine.  [Available from Virtual Foundry for $3700](https://thevirtualfoundry.com/wp-content/uploads/2024/06/The-Virtual-Foundry-Kiln-Catalog-06_24.pdf).  Make sure that these can be run as an oxidizing environment (with blower fan) for doing ceramic stuff, as well as being run in a reducing (or at least not too much oxygen) environment for metal sintering

- [Slip casting]({{ site.baseurl }}{% post_url 2023-11-23-Slip-Casting %}) --- make FDM positives, then pour plaster negatives, then do the casting.  Relatively gentle introduction to mold making processes and other ceramic-y stuff with minimal investment 
    - I suppose an even lighter introduction would be to 3d-print a tile mold, and just do rolled clay into the mold...use of [azulejo style motifs]({{ site.baseurl }}{% post_url 2024-05-10-Great-Ideas-from-Portugal %}) is optional...
    - Could also do [direct casting of concrete into TPU negative molds](https://hackaday.com/2024/07/01/casting-concrete-with-a-3d-printed-mould/) as a lighter introduction still...

- **Extrusion based:**  [Eazao Zero](https://www.eazao.com/product/eazao-zero/) ($900) is a direct extrusion ceramic printer with good reviews; you can formulate your own clays and pack them in

- *Side quest:*  [glazing chemistry]({{ site.baseurl }}{% post_url 2024-06-11-Imaginary-Syllabi:-Glazed-and-Confused %})

- **DLP ceramics:**  [Tethon Bison](https://tethon3d.com) is the winner here for SLS/DLP printing with ceramics.  You can buy the resins but results are iffy with other printers (according to random redditors who tried), and the ceramic fluids mess up your other printers, so it is worth specializing. Unfortunately these are above our typical threshold ([$19K, but there's an academic discount?](https://tethon3d.com/product/bison-1000-dlp-printer-2/)).  They have lots of cool resins, including [castalite](https://tethon3d.com/wp-content/uploads/Castalite-Guideline-1.pdf) which can be used to direct print investment molds and other stuff, well as [resin kits that can be used to embed your own nanoparticles](https://tethon3d.com/product/genesis/).

- **Glass**: Glassomer sells an [SLS with hgih-quality silica](https://www.glassomer.com/technology.html), marketed with [Lithoz](https://lithoz.com/en/lithoz-and-glassomer-launch-innovation-partnership-presenting-lithaglass-powered-by-glassomer-a-3d-printable-quartz-glass-for-high-performance-applications/). Probably fine to do it with our polymer SLS printer?

- **EHS Needs:** Venting for kiln, power and fire safety for kiln 

# Metals


- **Casting:**  Never underestimate the ability to make positives out of polymer and then make an investment mold/lost-wax process
    - Ye-olde [Lost PLA casting](https://all3dp.com/2/lost-pla-casting-guide/)
    - [Print-wave casting with a microwave kiln](https://hackaday.com/2024/07/13/print-wave-metal-casting/)
    - Side quest:  Trip to the [Diamond District](https://en.wikipedia.org/wiki/47th_Street_(Manhattan)#Diamond_District) (which has plenty of casting-on-demand shops)
    - [SolidScape](https://www.solidscape.com/s3duo-3d-printer-for-jewelry/) is a wax 3d printer especially for jewelers.  It's not my jam (I'm more into direct additive than doing lost-wax, but certainly fun to know about)
    - **EHS**:  Molten metals are gonna be fun...but you can do this safely in a small space at small scales (the diamond district exists) if needed

- **FDM/sintering workflows**:  These are cool and leverage tools from above
    - [Virtual Foundry](https://thevirtualfoundry.com/) sells a PLA+metal particle filament. Print in any FDM printer (a filament warmer helps...the filaments are quite brittle), then debind and sinter in a kiln to make metal parts.  Lots of different metals, also glass(!) and lunar regolith simulant(!)
        - [Starter kit is about $400](https://shop.thevirtualfoundry.com/collections/filamet-kits/products/getting-started-bundle?variant=39511194140844) --- seems easy to do

    - [Cerametal](https://hackaday.com/2024/07/21/cerametal-lets-you-print-metal-cheaply-and-easily/) is another idea; you make a metal-powder infused clay and then squeeze it through your ceramic extruder (see above; they use an Eazao), but you have to do some custom slicing
        - What's neat is that its easy to mix your own so the operational cost can be very low

- Directed energy deposition (like [MeltIO](https://meltio3d.com/)), powder bed fusion/selective laser sintering, etc. is too pricey for us to do at this scale.
    - **Field trip:**  Go to the [GA Tech Advanced Manufacturing Pilot Facility](https://ampf.research.gatech.edu)



# Biomaterials

(I think biology is messy, but...we might still have to do this for a well-rounded course) Also tie into other [departmental efforts in biomaterials](https://pubmed.ncbi.nlm.nih.gov/37999189/)

- [Chocolate 3d printer]({{ site.baseurl }}{% post_url 2024-01-08-What-to-do-with-a-chocolate-3d-printer? %}) not so gross, maybe delicious, but kind of a one-trick pony, and we wouldn't want to put it in a lab with all the gross stuff.

- Bioprinter/hydrogels: There is a [BioX kicking around the department](https://now.fordham.edu/colleges-and-schools/fordham-college-at-rose-hill/next-generation-scientists-inside-a-fordham-chemistry-lab/)


# Testing

- Tensile testing of dogbones samples

- Indentation tester for mixing clays


# Computational / Design aspects

- Simple modeling in Fusion360: Design a container with a lid

- Ideas of mold design (including drafts, etc.)

- 3d-scanning (and subtraction)


# Professor, teach thyself

- [MEng in additive manufacturing at PennState](https://www.worldcampus.psu.edu/degrees-and-certificates/penn-state-online-additive-manufacturing-and-design-masters-degree) (apply by 01 Sep to begin 06 Jan), 30 credits, 100% online (but you get to make an optional field trip to play with the metal stuff)

- [Additive Manufacturing Strategies](https://additivemanufacturingstrategies.com/ ) conference in NYC 04-06 Feb 2025

# Course ideas
 
- One day workshops (on a Saturday) open to the general public? 

- Lab for a materials science course

- Collaborate with sculpture faculty? (But: I don't see anyone on the [visual arts faculty](https://www.fordham.edu/academics/departments/visual-arts/about-the-department/visual-arts-faculty-and-staff/) who does sculpture, but there's a [VART 1219 Sculptural Methods course](https://bulletin.fordham.edu/undergraduate/theatre-visual-arts/?_ga=2.65009192.605861286.1722875629-1156076372.1718293184#coursestext-otp1) on the books)
    - Frame it as an interdisciplinary capstone course?

- Research projects?
