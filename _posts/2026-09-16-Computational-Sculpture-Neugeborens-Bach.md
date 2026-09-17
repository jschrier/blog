---
title: "Computational Sculpture: Neugeboren's Hommage à J.S. Bach (revisited)"
date: 2026-09-16
tags: mathematica sculpture music art 3dprinting laser gpt6
---

In [a 2024 post]({{ site.baseurl }}{% post_url 2024-08-06-Henrik-Neugeboren's-Bach-Sculpture %}), I noted that [Henrik Neugeboren's](https://de.wikipedia.org/wiki/Henri_Nouveau) sculpture of a Bach fugue “would 3d print very nicely.” **Here we task GPT-6-Astra with constructing a 3d-printable solid and a laser-cut flat-packable aluminium model of the sculpture...**

# The Prompt

Initiated in plan mode codex session with gpt-6-astra-medium:

> Starting with the information in `2024-08-06-Henrik-Neugeboren's-Bach-Sculpture.md` do additional background research and then write a Mathematica notebook that will generate a reproduction of this sculpture.  I would like the code to generate two possible outputs: a solid geometry model (which might be 3d printed on a prusa MK3s+ printer at an appropriate scale) and a flat layout version with wave bending marks (https://sendcutsend.com/blog/wave-bending-sheet-metal/) with the idea that the bottom would have tabs that would fit into a laser cut base.

After asking three questions (Which reconstruction goal should guide the notebook? *Faithful, fabricable (Recommended)* What should the default sheet-metal design target? *Thin aluminum (Recommended)* Which base should the metal version use by default? *Aluminum base*), it then cranked away for 32 minutes and returned essentially the finished object, both as STL and DXF files for the two 

We could have been done here, but I wanted some changes, so I asked:

> This is really good work.  I'd like to request a couple small changes:
> - Modify the base in the 3d-printed and laser cut so that it is a rounded rectangle.  The corners should have a radius of curvature of 10 mm
> - For the 3d-printed version.  I would like the underside to have some debossed text that describes the project with minimal information, "Henri Nouveau (Heinrich Neugeboren) (1901-1959) Hommage à J.S. Bach"

Finally, seeing that the results looked good, but dreading writing this up:

> This is really great, I really like it.   Good work!
> Let's share the results publicly by generating a jekyll format blog post about this output result.  No need to run additional calculations or compute any new outputs.  
> Blog text should include the notebook narrative text describing the background literature, implementation, and relevant .png images that you generated. There is no need to include extensive code sections in this blog post.  
> At the end of the post, link to copies of the Plan file, as well as the ZIP file of all the assets into the images/09/16/ directory so that someone reading the webpage can download those.

Text that follow are all `GPT-6-astra-medium`I' generated output from this last command. Look upon these works, ye mighty, and despair:  I was quite impressed that it looked up the correct MIDI transcription, designed the laser cutting patterns, etc.  I will probably not get it laser cut, but will certainly consider printing it. **Links to download all of the generated materials, along with a construction guide, are at the end of the post.**


# Clanker says...

The discussion below is adapted from the notebook's narrative. The code lives in the downloadable notebook; the images are its existing outputs. **This is a reconstruction of the musical design, not a surveyed replica of the monument.** The files have been checked computationally, but have not yet been physically printed or fabricated.

![Assembled reconstruction of Neugeboren's Bach sculpture, with three colored musical voices on a rounded rectangular base]({{ 'images/09/16/neugeboren-assembled-preview.png' | relative_url }})

*The colors distinguish the voices. This preview shows nominal panel surfaces; the STL contains finite-thickness walls joined to the base.*

## Bach, folded into space

Neugeboren devised the project during his 1928 visit to the Bauhaus. Stephanie Probst's [“Pen, Paper, Steel: Visualizing Bach's Polyphony at the Bauhaus” (2020)](https://mtosmt.org/issues/mto.20.26.4/mto.20.26.4.probst.html) identifies the music as the three-voice stretto in Bach's E-flat-minor fugue, BWV 853, measures 52–55. The central idea is that pitch controls both the height and depth of the sculpture, while musical time extends along its other horizontal axis.

[Probst's illustrated examples](https://mtosmt.org/issues/mto.20.26.4/probst_examples.pdf), especially the score in Example 10, provide the musical starting point. The [historical Gerda Marx maquette and Konrad Püschel drawing reproduced from *La Revue Musicale* (1960)](https://continuo-docs.tumblr.com/post/12111025275/romanian-born-composer-henrik-neugeboren) help clarify the staggered beginnings of the three voices. The notebook's reconstruction also drew on front and side photographs of the realized work. [NRWskulptur](https://nrw-skulptur.net/en/skulptur/hommage-a-j-s-bach/) dates the stainless-steel monument in Leverkusen to 1968/70 and lists dimensions of 6.5 × 6.5 × 6 m.

The model follows the musical contour and documented relationship between pitch, depth, and height. Its exact proportions, ground level, base, wall thicknesses, mounting tabs, and allowances for bending are explicit reconstruction and fabrication choices.

## From the score to wall geometry

The notebook embeds exact rational onset times and durations, note pitches, and merged ties. The complete excerpt spans sixteen quarter notes. Its 65 sounding events were cross-checked against [Mutopia's public-domain transcription](https://www.mutopiaproject.org/ftp/BachJS/BWV853/bwv853b/bwv853b.ly), prepared by Davide Castellone from a Breitkopf & Härtel source. The E-flat-minor spelling used here includes F-flat and C-flat; the independent D-sharp-minor MIDI represents the same sounding pitches.

The sculptural subset begins the bass at quarter-note offset 0, alto at 1, and soprano at 2. The earlier alto and soprano events remain in the embedded score but are not added as extra walls. The bass's final tied E-flat is clipped at the end of the excerpt. These choices preserve the staggered subject entries visible in the historical model.

A sustained note produces a straight panel along the time axis. A pitch change produces a connecting panel in the depth direction, with a sloping top. The top edges lie in a common plane: height above the base is proportional to pitch above an editable ground pitch. With equal height and depth scales, the side elevation has the documented 45-degree slope. The default time-to-pitch proportion is two semitone units per quarter note. Voice spacing follows the pitches; the walls are not arbitrarily shifted apart.

![Ground plan of the three musical voices and their mounting positions]({{ '/images/2026/09/16/neugeboren-ground-plan.png' | relative_url }})

Both fabrication routes use the same panel-and-fold representation: voice identifiers, panel endpoints, top heights, fold axes, and signed turns. One configuration association collects the sizes, proportions, thicknesses, bend parameters, wave dimensions, tabs, and clearances. Changing overall size does not automatically scale material thickness or fitting clearance.

## The printed version

The default STL measures approximately **165.70 × 180.00 × 175.17 mm**, including its base. The walls are 1.2 mm thick and the base is 3 mm thick. Both the printed and laser-cut bases have **10 mm corner radii**; the exported outlines approximate each quarter-circle with 32 chords, for a maximum chord error below 0.0031 mm.

The printed solid starts with joined orthogonal wall footprints on a conforming grid. Boundary cells are clipped to the rounded base outline. Mathematica's bundled OpenCascadeLink then subtracts the underside lettering and triangulates the resulting solid. The exported STL is one connected, closed body rather than a collection of overlapping panel shells.

The underside carries two centered lines:

> Henri Nouveau (Heinrich Neugeboren) (1901-1959)  
> Hommage à J.S. Bach

The inscription is **debossed 0.6 mm**, leaving 2.4 mm of base material above it. Its geometry is mirrored during construction so it reads normally when viewed from below.

![Underside of the rounded base with the two-line debossed inscription]({{ '/images/2026/09/16/neugeboren-underside-preview.png' | relative_url }})

The model fits the [Prusa MK3S+ build volume](https://www.prusa3d.com/product/original-prusa-i3-mk3s-10th-anniversary-edition-3d-printer/), including room for a 5 mm brim. Import the STL as millimeters at 100% scale and place the base on the bed. The 1.2 mm walls suit roughly three extrusion tracks with a 0.4 mm nozzle, although the actual toolpaths depend on the slicer's line widths. A 0.20 mm layer-height PLA profile is a starting point.

The sculptural walls have no unsupported downward-facing overhangs. The lettering creates short bridge spans 0.6 mm above the bed; inspect those first layers and leave supports out of the inscription. Tall, thin walls still merit conservative speeds and an extrusion-preview check. The download contains a model, not printer-specific G-code.

## The sheet-metal version

The aluminum assembly uses **1.016 mm (0.040 inch) 5052 aluminum walls** and a **3 mm base**, with an assembled footprint of about 275.40 × 300 mm. The tallest wall rises 295.18 mm above the base. Material thicknesses remain editable.

Each ideal right-angle fold is replaced by a tangent circular bend along an effective neutral line. Adjacent straight panels are shortened accordingly, and the developed bend length is the effective radius multiplied by the turn angle. This gives a finite-width bend zone in the flat pattern. The radius and bend-allowance factor are empirical parameters for a perforated seam, not a claim that ordinary solid-sheet bend formulas predict its behavior exactly.

Following [SendCutSend's wave-bending guidance](https://sendcutsend.com/blog/wave-bending-sheet-metal/), the bend zones contain curved cutouts separated by retained webs. These are actual cutting contours, not etched fold marks. The default cut widths and webs start at the sheet thickness, and reliefs remain clear of edges and tabs. Three tabs on sufficiently long straight panels locate each voice in the base.

![Developed bass wall with wave cutouts, mounting tabs, and labeled fold centers]({{ '/images/2026/09/16/neugeboren-layout-bass.png' | relative_url }})

![Developed alto wall with wave cutouts, mounting tabs, and labeled fold centers]({{ '/images/2026/09/16/neugeboren-layout-alto.png' | relative_url }})

![Developed soprano wall with wave cutouts, mounting tabs, and labeled fold centers]({{ '/images/2026/09/16/neugeboren-layout-soprano.png' | relative_url }})

*Red fold references and labels appear in these assembly previews only. The cutting DXF and SVG files contain closed contours without annotations.*

The bass, alto, and soprano strips are approximately 695.92, 687.72, and 589.32 mm long. The largest wall blank is about 589.32 × 299.18 mm including its tabs, so the flat parts require more space than the assembled footprint suggests. Across the three walls there are 2,897 wave cutouts: this is a prototype with many laser pierces, not an optimized production quote. The small wave geometry preserves the short low-bass folds.

![Rounded aluminum base layout with nine locating slots]({{ '/images/2026/09/16/neugeboren-layout-base.png' | relative_url }})

Cut the wave and tab coupons in wall stock, and the separate six-slot coupon in base stock. Its trial clearances are 0.10, 0.20, 0.25, 0.35, 0.50, and 0.70 mm of **total added width**, not clearance per side. The default assembly slots are 1.266 mm wide in a 3 mm base; confirm that the chosen laser service can cut them. Fit changes belong in the parameters, rather than scaling a finished DXF or adding kerf compensation twice.

The supplied HTML assembly guide and CSV bend schedule identify fold order and direction. Looking down while following musical time, a positive turn goes left and a negative turn goes right. Work through successive folds with a consistent reference face, comparing the result with the ground plan. All three tabs of a voice should enter together without force. They project 1 mm below the base, so feet or a backing spacer are needed; an underside epoxy fillet can retain them after a successful dry fit.

## What has been checked

The saved notebook passed execution of all 17 input cells in a fresh Mathematica 15.0.1 kernel. It contains the musical data and definitions and needs no downloads or companion source file. Evaluating it regenerates the exports beside the notebook; existing files with the same names are overwritten. The CAD engraving step can take several minutes.

The existing validation reports record a closed, consistently oriented, connected STL with positive volume and 37,750 triangles. PrusaSlicer also recognized one manifold part. Independent checks re-read the STL and DXF/SVG files, verified the rounded corners and inscription depth, confirmed valid closed cutting contours and connected sheets, and checked agreement between the cutting formats. All nine tabs fit their corresponding slots geometrically. Numerical refolding agreed with the assembled geometry to within 6 × 10⁻¹³ mm.

Those results establish computational consistency. They do not establish the actual bend allowance, springback, seam durability, tab fit, print quality, or a supplier's acceptance of the smallest features. The supplied coupons are the next step before committing to the full aluminum assembly.

## Downloads

- [Download the project plan (Markdown)]({{ '/images/2026/09/16/NeugeborenBachSculpture-Plan.md' | relative_url }}), preserving the approved implementation plan and the subsequent rounded-base and inscription requests.
- [Download the complete notebook and fabrication assets (ZIP)]({{ '/images/2026/09/16/NeugeborenBachSculpture.zip' | relative_url }}): the self-contained Mathematica notebook, readable Wolfram Language source, STL, individual DXF/SVG cutting files, calibration coupons, PNG previews, HTML assembly guide, schedules, and validation reports.

