---
title: "Electric Dreams: Art and Technology Before the Internet"
date: 2026-05-07
tags: art reading 3dprinting mathematica p5js analog
---

Notes on [Electric Dreams: Art and Technology Before the Internet](https://amzn.to/426bKGQ)...

# General resources

- [Digital Art Museum](https://dam.org/museum): online resource for the history and practice of digital fine art,
- [Monoskop](https://monoskop.org/Monoskop): a wiki for arts and studies, focus on Euro technical arts
- [LeRandom](https://www.lerandom.art): articles on generative art, broadly defined

# Ian Sommerville (p. 60)

Only mentioned in passing in the section on Brion Gysin, but [he was an interesting character](https://en.wikipedia.org/wiki/Ian_Sommerville_(technician)), spending time in the Paris Beat hotel where he was a "systems advisor" and lover of [William S. Burroughs](https://en.wikipedia.org/wiki/William_S._Burroughs). 

- [Dream Machine no.9 video](https://www.instagram.com/reels/DIMQapZofhE/)
- Book: Geiger, [Chapel of Extreme Experience: A Short History of Stroboscopic Light and the Dream Machine (2003)](https://archive.org/details/chapelofextremee0000geig) ---out of print, but in Fordham library. It is a charming little book, part history of psychological research into flicker effects and part beat/hippie hijinx. 
- [Build Your Own Dream Machine](https://www.bluestwave.com/toolbox_dreammachine.php)

# Grazia Varisco (p. 89)

- [Video of Variable Light Scheme R](https://www.youtube.com/shorts/gStCmJvLc7g)
- [3d print your own imitation (-ish) with LEDs](https://www.printables.com/model/1694139-light-pattern-projector)


# François Morellet (pp. 96-97)

- [Artist's homepage](https://francoismorellet.com)
- [wikipedia entry](https://en.wikipedia.org/wiki/François_Morellet)
- [biographical video](https://www.youtube.com/watch?v=QmXDF_IZcF8) showing his neon and sculptural work. "Juxaposition, superposition, chance, interference, fragmentation."

His painting "Random distribution of squares using the pi number decimals, 50% odd digit blue, 50% even digit red" (1963) is shown in the book, which inspired me to write the following Mathematica code to reproduce it (minus the hand-painting):

```
ArrayPlot[#, ColorRules -> {True -> Blue, False -> Red}]&@
   ArrayReshape[#, {200, 200}]&@ OddQ@ First@ RealDigits[Pi, 10, 40000]
 ```

A related painting, ["Random Distribution of 40,000 Squares Using the Odd and Even Numbers of a Telephone Directory, 50% Blue, 50% Red"(1960) is on display at the MoMA](https://www.moma.org/collection/works/105479)

A modern take might be to use the [BBP algorithm](https://en.wikipedia.org/wiki/Bailey–Borwein–Plouffe_formula) to compute arbitrary *binary* (or other power-of-2) digits at random order.  As an aside, the binary version of Morellet's painting (replace `RealDigits[Pi, 2, 40000]` in above code) doesn't look substantially different, and has the same property of being nearly equal counts of each color. 

# Vladimir Bonačić (pp. 124-125)

[Galois fields](https://en.wikipedia.org/wiki/Finite_field) visualized with moving lights with custom hardware---a rejection of randomness: "“I am especially sceptical of the attempts to produce computer art through play with randomness and the deliberate intro­ duction of errors in programs prepared for non­artistic pur­poses"

- [Video of DIN. GF100 V.b. 1969](https://www.youtube.com/watch?v=Qw764twB0CM)
- [hour long lecture/panel on Bonačić (2011) *auf deutsch*](https://zkm.de/en/media/videos/vladimir-bonacic-bcd-cyberneticart-team-cyberneticart)

- Article: "Kinetic Art: Application of Abstract Algebra to Objects with Computer-Controlled Flashing Lights and Sound Combinations" (Leonardo, 1974) [pdf](https://monoskop.org/images/c/c4/Bonacic%2C_Vladimir_%281974%29_-_Kinetic_Art.pdf) in which he describes his notional construction of 32x32 lights, and constructions where the lights are mapped onto audio tones.

- [Notes towards implementation](http://reference.wolfram.com/language/guide/FiniteFields.html)---*frankly, this is an area of mathematics I don't understand well enough to try to implement*

# Vera Molnár (pp. 126-127 )

Code reproductions of [Quatre éléments distribués au hasard, 1968 and Interruptions (1968-1969)](https://mathematica.stackexchange.com/questions/299650/vera-molnárs-interruptions-erasing-graphic-elements)

# Frieder Nake (pp. 128-129)

- **Open question:** I tried to find a more detailed recipe of his matrix works, but the best description I could find was that it is a matrix initialized with random values, and the series is generated as matrix powers, with the values of each element assigned (by human?) a color code.
- Code reproduction [Walk Through Raster (1966)](https://mathematica.stackexchange.com/questions/302010/early-computer-art-frieder-nakes-walk-through-raster)
- [2022 interview with Nake](
https://www.rightclicksave.com/article/an-interview-with-frieder-nake): comments on the distinction between brains and computers of relevance in the LLM-era
- [2024 interview with Nake on “Machinic” Miracles](https://www.lerandom.art/editorial/frieder-nake-on-machinic-miracles)

# Lillian F. Schwartz (pp. 136-137)

- The Ford Museum holds her collected papers, which makes sense why they made [a 3-minute biographical video (along with videos of some of her computer animation pieces, as well as her other painter and sculptural work)](https://www.youtube.com/watch?v=rGxQfGHApP0)
  - But this [Computer History Museum Bio](https://computerhistory.org/blog/lillian-schwartz-pushing-the-medium/) does a better job of putting her development as an artist into chronological sequence, as well as showing the schematics of the inner workings of her projector dome, and video clips of her Bell Labs animation

# Stephen Beck (p. 155)

- **Beck Direct Video Synthesizer (1970)**...[direct from the Artist's Own Website](https://www.stevebeck.tv/project/beck-direct-video-synthesizer/)...and [again from his previous website](https://ncet.stevebeck.tv/dirvideo/drivideo.html)
  - Apparently his papers (including [archival slides of the BDVS and BVW](https://californiarevealed.org/do/fa84f66a-8cdf-46fc-b9b7-45499d3430fe)) are at the UC Berkeley Pacific Film Archives...if you enjoy looking at protoboard soldering and some Apple II hardware, you can find it there!
  - He designed the BDVS to have [compatible voltages with the Buchla audio synths](https://www.vasulka.org/archive/eigenwelt/pdf/122-125.pdf)
  - The competing  [Sandin Image Processor (1971-1974)](https://en.wikipedia.org/wiki/Sandin_Image_Processor) really captures the analog synth hardware vibe. 
    - According to a  [history of video synthesizers](https://collopy.net/writing/publications/Video%20Synthesizers.pdf), he  "gave away plans for the Image Processor with a 'distribution religion,' stating that 'the Image Processor may be copied by individuals and not-for-profit institutions without charge.'"...essentially a predecessor to open source licenses
    - [Modwiggler thread on plans](https://www.modwiggler.com/forum/viewtopic.php?t=52490)...very few are still operational and they are hard to reconstruct now because of some odd parts. ONe that is still operational in Chicago has a [users manual](https://jameshconnolly.com/sandin-ip-doc.html)

- His later *Beck Video Weaver (1974)* [was digital](https://www.vasulka.org/archive/eigenwelt/pdf/122-125.pdf)...made out of 60x 7400 TTL logic circuits (which he recreated in 1992 with two ASICs)
  - [Video Weaving (1976)](https://www.youtube.com/watch?v=EjX8aCRQ8Ms) (as a video, still shwon in book), with original groovy jazz background music. Makes sense that this is digital when you watch it, but this isn't obvious in the book's image
  - [Wikipedia: Video Synthesizer](https://en.wikipedia.org/wiki/Video_synthesizer) tries to put this in context with other developments...such as the [Atari Video Synthesizer](https://en.wikipedia.org/wiki/Atari_Video_Music).  

# Garnet Hertz, "Art + DIY Electronics" (2023) (p. 165)

- [book](https://amzn.to/48JSVwW)...ties together [Survival Research Lab](https://www.srl.org) and [Nam Jun Paik](https://www.paikstudios.com)

# Suzanne Treister (pp. 204-215)

- [artist website](https://www.suzannetreister.net)...including a larger selection of her [Fictional Video Game Stills (1991-1992) series](https://www.suzannetreister.net/Ampages/Amenu.html)

# Parerga and Paralipomena

- [Processing (p5)](https://processing.org/) seems to be what all the cool kids are using, and often in the form of the javascript, in browser, p5.js
  - Gross et al, [Generative Design: Visualize, Program, and Create with JavaScript in p5.js ](https://amzn.to/4tTwopP) also has a [companion website](http://www.generative-gestaltung.de/2/)

- [Artblocks.io](https://www.artblocks.io) is a marketplace/gallery for generative digital art...sold as NFTs (which usual gives me a bad vibe, but these pieces are actually quite good), with a physical location in Marfa, TX. 
  - I came across this via [works by Manuel Larino](https://www.artblocks.io/collection/gift-of-time-by-manuel-larino)
  - [Under the hood:](https://docs.artblocks.io/creator-onboarding/artists/1-building-your-project/)  It appears that it's just a way to store/retrieve a 32-byte hex string hash which you then use as a seed for your PRNG + storage of a 5-10 kB javascript file containing your code (as this costs several thousand USD, it rewards brevity).  In practice that's a p5.js or some other type of equivalent library.

- [Signal Culture](https://signalculture.org) center for video art (currently in Colorado? Moving to Binghampton NY?). Their [cookbooks look interesting](https://signalculture.org/cookbooks.html). 
  - Here's a [2016 account of a residency](https://jonasbers.com/signal-culture/) at their former location. And his account of making a [$10 crap video synth](https://jonasbers.com/crap-video-synth-for-10/) by using a VGA test signal generator

- [LZX Industries](https://lzxindustries.net) carrying on the mantle of modular video synthesis ala the Sandin Image Processor (and cheaper FPGA video synth in a box )

- [WaveFarm](https://wavefarm.org/ta/about) (in Acra NY...outside Hudson, NY) is dedicated to transmission art