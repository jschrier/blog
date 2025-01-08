---
title: "Laser Cutter Chemistry"
date: 2025-01-07
tags: science diy laser
---

Nietzsche famously claimed to do [philosophy with a hammer](https://en.wikipedia.org/wiki/Twilight_of_the_Idols).  **But can you do chemistry with a commercial laser cutter?** Some notes on feasible projects with CO2 (10.6 um), 1064 nm NIR fiber, and blue diode (455 nm) lasers found in commercially available laser cutters...

# What are we working with?

- CO2 IR lasers (~10,000 nm) are pretty common; local hackerspace has an [80W Trotec Speedy 300](https://wiki.fatcatfablab.org/wiki/Laser_Cutting)
- More recently higher power fiber (NIR 1064 nm) and diode (visible blue, 455 nm) based machines have become available.  One particularly nice one is the [XTool F1 Ultra](https://www.xtool.com/products/xtool-f1-ultra-20w-fiber-diode-dual-laser-engraver) which has 20W on both of these wavelengths.  Also neat is that the laser is moved by galvanometer, potentially allowing us to have higher resolution patterning.

(I learned about the F1 Ultra from a recent description of [how to make surface mount PCBs on the laser](https://github.com/sphawes/fiber-laser-pcb-fab) corresponding [youtube video](https://www.youtube.com/watch?v=wAiGCyZZq6w))


# Relevant Review Articles

- Manshina et al "The Second Laser Revolution in Chemistry: Emerging Laser Technologies for Precise Fabrication of Multifunctional Nanomaterials and Nanostructures" [Adv Funct Mater 2024](https://dx.doi.org/10.1002/adfm.202405457)
- Pinheiro et al "Direct Laser Writing: From Materials Synthesis and Conversion to Electronic Device Processing" [Adv Mater 2024](https://dx.doi.org/10.1002/adma.202402014)

# Laser-induced graphene

**Premise:** [Jim Tour & Co. in 2014](https://doi.org/10.1038/ncomms6714) showed how you could use a CO2 laser to cook kapton polyimide into graphene. Graphene has great properties, including conductivity, and using the laser cutter lets you pattern it. 

**Precident:** Shokoruv and Menon [J. Chem Educ. 2023](https://doi.org/10.1021/acs.jchemed.2c01237) used a 30W CO2 laser cutter to make 3-electrode graphene electrodes on flexible polymers (followed by silver electroplating) that are as performant as commercial screen-printed electrodes. Murray et al [ACS Omega 2023](https://doi.org/10.1021/acsomega.1c00309) describe a design of experiments study of CO2 laser power and speed for graphene quality; one could imagine adapting this into a Bayesian optimization style adaptive experiment.

**Feasibility:** High. Seems technically easy, and there are good intersections with nanoscience and electrochemsitry.

# Laser-based sintering

**Premise:** Sinter metal nanoparticles that are on a surface to form a continuous conductive film.  (Selective laser sintering is used in [additive manufacturing]({{ site.baseurl }}{% post_url _posts/2024-08-05-Imaginary-Syllabi:-Additive-Manufacturing-Lab %}) of larger metal objects too, but our goals are more modest )

** Precedent:** Table 1 in the direct laser writing review ([Adv Mater 2024](https://dx.doi.org/10.1002/adma.202402014)) lists many examples, one of which includes Balliu et al. [Sci Rep 2018](https://dx.doi.org/10.1038/s41598-018-28684-4) in which a CW 1064 fiber lasers to sinter commercially-purchased Ag inkjetted onto paper.  The inkjetted particles are conductive, but become much more conductive after sintering, which lets you make RFID antennas, etc. 

**Feasibility:** High/Medium.  Observable is conductivity...about 5x improvemenets in conductivity compared to as-printed, so maybe it is harder to get kids excited about this. Also you need to inkjet print the Ag nanoparticles, which might require some special kit.


# Laser activation + electroless copper plating

**Premise:** Incorporate a photoactive metal oxide, copper–chromium oxide (CuO·Cr2O3), into the acrylonitrile-butadiene-styrene (ABS) matrix, which forms a black color.  Blast the matrix with a 1064 nm NIR laser to pattern. Then electroless plate.  Looks pretty and serves as a template for the plating. 

**Precedent:** Experiment above is described by Zhang et al. [ACS AMI 2017](https://dx.doi.org/10.1021/acsami.6b15828). Alternatively, Xiang et al. [Surf. Interf 2022](https://doi.org/10.1016/j.surfin.2022.102209) describe how you can just use the NIR laser to pattern polycarbonate or ABS, coat on a thin layer of Cu2(OH)PO4, laser it again to activate, and then perform your electroless copper depoistion.  Subsequent work by the same folks showed you can also do this with  Cu3(PO4)2 (just lightly brush the powder onto the relevant surface before activation), and activation by 1064 nm was preferable, also applicable to polycarbonate, ABS, and PEEK. Opportunity to connect this to various characterization methodologies, solid state DFT calculations.

**Feasibility:** High/medium.  Requires extruding/molding the polymer or a two step process in which you brush on a thin layer of powder, followed by an hour of electroless plating (which might be slow in a lab setting?) but otherwise pretty straightforward with impressive results.  

# Pulsed Laser ablation for silver nanoparticle synthesis

**Premise:** Blast a surface to make nanoparticles.

**Precident:** Nothing in the Chemical Education literature, but...
 - Mafune et al [J. Phys Chem C 2000](https://doi.org/10.1021/jp001803b) ablate a silver metal plate in an aqueous solution of SDS or SSS surfactant, but they used a frequency doubled Nd:Yag (532 nm); unclear if we could do this at other wavelengths with decreased efficiency, but maybe worth a shot 
- Seoura et al [J. Photochem Photobiol A 2017](https://dx.doi.org/10.1016/j.jphotochem.2017.05.002) synthesized silver nanoparticles from silver nitrate at the interface of a glass slide (they claim that the interface is crucial), using continuous wave 1064nm, 442 nm, and 532 nm lasers---efficiency/production rate decreases a lot compared to the notional 325nm result, but this suggests it is possible.
- Kalai Priya [Appl Phys A 2021](https://doi.org/10.1007/s00339-021-04370-7) used a non-doubled 1064 nm Nd:YAG source to synthesize silver nanoparticles by "laser ablation of silver nitrate solution with trisodium citrate under the different ablation durations of 20, 40, 60, and 80 min. About 60 mL mixture containing 0.01 M (50 mL) of silver nitrate solution and 0.1 M (10 mL water) of trisodium citrate solution was taken for irradiation. The prepared solution was kept under constant stirring for laser ablation with unfocused light. Ag-NPs samples prepared under the 20, 40, 60, and 80 min of ablation duration are referred to as S2, S4, S6, and S8. Ag-NPs in yellowish-brown color colloid was obtained (Fig. 2)." 

**Feasibility:** Medium/High.  It is advantageous that the solutions become visibly colored, and this could be monitored in situ using a [low-cost spectrometer](https://github.com/scientistnobee/Pocket-Spectrometer). 


# Laser Synthesis of Polyenes

**Premise:** Irradiating a graphite-in-ethanol solution results in the formation of linear polyenes, which can be characterized by their 1D-particle-in-a-box UV/vis spectra.

**Precident:** Henry et al. [J Chem Educ 2012](https://doi.org/10.1021/ed200728k) did this, but with a 2nd harmonic Nd:YAG at 532nm, with peak pulse power of 5 MW. They report: "Other types of lasers and wavelengths were examined to see if polyynes could be successfully generated. The third harmonic (355 nm) of the Nd:YAG laser easily produced polyynes at 30 mJ/pulse with an unfocused beam. Furthermore, a focused 355 nm beam did produce small quantities of polyynes at 5 mJ/pulse in 15 min, but no evidence of polyyne production was seen with the focused 355 nm beam at 1.5 mJ/pulse even when the irradiation time was increased to 75 min. Lasers not found to produce polyynes are a 10 mW HeCd laser at 442 nm and a 5 W CO2 laser at 10,600 nm."  

**Feasibility:** Low. We are probably too far away from the wavelengths needed.  


# Laser-Induced Breakdown Spectroscopy (LIBS)

**Premise:**  Use a laser (CO2 would be fine) to blast a material, and then look at the emitted light using a spectrometer.  This is more analytical than synthetic.

**Precedent:** There are papers in the chemical education literature on partially-homebrewed LIBS ([Maher et al., 2021](https://doi.org/10.1021/acs.jchemed.1c00563))([Rainey et al, 2024](https://doi.org/10.1021/acs.jchemed.4c00421)). The latter uses the primary (1064nm) of a Nd:YAG laser, and so in principal we could do this with an fiber IR laser. 

**Feasibility:** Medium/Low. Possible practical complications:
- Use the $60 [AS7265x triad sensors]({{ site.baseurl }}{% post_url 2023-02-01-Reading-AS726x-and-AS7265X-Spectral-Sensors-in-Micropython %}) to detect the light from 410nm (UV) to 940nm (IR); run a lense/fiber optic capble to the sensor. Resolution is not great, but it might be enough to reolve some different species
- Generally the laser is pulsed and data is collected with a gate delay and gate width; these are on the order of 1-30 uS, and its not clear that we can synchronize the laser and the sensors with this level of precision.  Maybe it doesn't matter and we operate continuously. 
