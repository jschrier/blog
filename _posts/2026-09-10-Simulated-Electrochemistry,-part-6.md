---
title: "Simulated Electrochemistry, part 6: Concentration Profiles during Cyclic Voltammetry"
date: 2026-09-10
tags: chemistry mathematica montecarlo science teaching electrochem chiguiro
---

Our past [electrochemical simulations]({{ '/tag/electrochem' | relative_url }}) have focused on reporting experimental observables, specifically the amount (and direction) of current transferred during the reaction at the electrode.  But a distinct advantage of simulations is that they also allow us to observe quantities that are less experimentally evident.  **In this post, we explore a simple modification that lets us observe the concentration profile of oxidized and reduced species as a function of time...**

## Coding strategy

The key idea is that we want to maintain an array of `{position, time}` dimensions that records the distribution of oxidized and reduced species during the course of the simulation.  In the simulation each particle behaves independently, and so this distribution will be obtained by summing over multiple independent trajectories.   For brevity we will refer to the oxidized and reduced states as "ions", with charge states of +1 and -1. When oxidized molecules are dominant, a positive value will be seen, when reduced molecules are dominant a negative value, and when they are equal then we will observe zero..  This need not be the case in experiment, but makes the modifications to the code from [part 5]({{ site.baseurl }}{% post_url 2026-08-12-Simulated-Electrochemistry,-part-5 %}) relatively minor:

```mathematica
sweepF3 = FunctionCompile@Function[
    {Typed[vv, TypeSpecifier["PackedArray"]["Real64", 1]], 
     Typed[maxX, TypeSpecifier["Integer64"]],               (*!! increase size to be comparable to implied type of vv *)
     Typed[nMC, TypeSpecifier["UnsignedInteger64"]]}, 
    Module[{x, dx, state, obs, chargeDistbn, 
     maxTime = Length[vv]}, 
     obs = ConstantArray[0, maxTime];                       (*!! initialize observations *)
     chargeDistbn = ConstantArray[0, {maxX - 1, maxTime}];  (*!! initialize charge state *) 
      Do[(*!!loop over MC steps*)
       x = RandomInteger[{1, maxX}]; 
       dx = 2 RandomInteger[{0, +1}, maxTime] - 1; 
       state = +1; 
       Do[                                                  (*!! loop over simulation time*)
        x += dx[[t]]; 
         If[x == 0, 
          If[RandomReal[] < 1./(1. + Exp[-vv[[t]]]), 
           If[state == -1, obs[[t]]++; state = +1;], 
           If[state == +1, obs[[t]]--; state = -1;] ]; 
          x = 1;  (* return to solution regardless of reaction outcome *)]; 
         If[x < maxX, chargeDistbn [[x, t]] += state];     (*!! record ion location *) 
        , {t, maxTime}];, 
       nMC]; 
     {obs, chargeDistbn}] 
   ]
```

![11dw20jzi3elz](/blog/images/2026/9/10/11dw20jzi3elz.png)

A few salient points:

- [FunctionCompile](https://reference.wolfram.com/language/ref/FunctionCompile.html) demands that the arguments to [ConstantArray](https://reference.wolfram.com/language/ref/ConstantArray.html) have a consistent type (`Integer64`), leading us to change the type of `maxX`

- The only substantive modification is to add the `chargeDistbn` array (initialized to zero), and then update it at every timestep with the current state of the system.

- Our simulation allows particles to diffuse to arbitrarily large values of position (`x`) away from the electrode, but the `chargeDistbn` array only has a finite size, so we only record information within the finite region.

- Because we have diffusion away from the farther positions (but not inward from beyond the starting boundary), we will want to restrict our attention to a narrower window of distances when plotting the charge distribution so as to represent the bulk. 

## Demonstration

Consider a basic cyclic-voltammetry experiment of the type introduced in [part 1]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %}):

```mathematica
Clear[cv]
cv[v0_, time_Integer] := With[{v = N@Rest@Subdivide[v0, -v0, time/2]}, Join[v, Rest@Reverse[v]]] 
  
 (*demo*)
expt = cv[10., 400]; 
{obs, charge} = sweepF3[expt, 86, 10^6];
```

Then visualize the results by generating a list of plots of corresponding time points in the observed charge transfer (`obs`) and charge distribution (`charge`) arrays and animating the collection:

```mathematica
ListAnimate@ Table[
    GraphicsColumn[
     {ListPlot[obs, 
       Frame -> True, FrameLabel -> {"time", "current"}, 
       Epilog -> {Red, PointSize[0.025], Point[{t, obs[[t]]}]}], 
      
      ListPlot[charge[[All, t]], 
       Frame -> True, FrameLabel -> {"distance from interface", "net charge"}, 
       PlotRange -> { {0, 60}, MinMax[charge]}]}], 
    {t, 1, 399}] 
```

<video controls autoplay loop muted playsinline style="max-width: 100%; height: auto;">
  <source src="/blog/images/2026/9/10/chargeanimation.mp4" type="video/mp4">
  Your browser does not support embedded video. <a href="/blog/images/2026/9/10/chargeanimation.mp4">Download the animation</a>.
</video>

We are unlikely to win an Academy Award for this video, but it is indeed interesting to see how the concentration distribution varies over time when aggregated over our particles.  Perhaps this suggests a future study of [electrochemical impedance](https://en.wikipedia.org/wiki/Electrochemical_impedance_spectroscopy).

```mathematica
ImageSynthesize["Cartoon style image of a capybara as a 1930s movie director.  He is pointing a movie camera at an electrochemical experiment in a laboratory."]
```

![0qfck3rp24h1e](/blog/images/2026/9/10/0qfck3rp24h1e.png)

```mathematica
ToJekyll["Simulated Electrochemistry, part 6", "chemistry mathematica montecarlo science teaching electrochem chiguiro"]
```

## Monte Carlo Simulations of Electrochemistry

- **Part 1:** [Monte Carlo Simulation of Diffusion, Chronoamperometry, Linear & Cyclic Voltammetry]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %})
- **Part 2:** [Reproducing the Randles–Ševčík Relation]({{ site.baseurl }}{% post_url 2026-08-05-Simulated-Electrochemistry,-part-2 %})
- **Part 3:** [Irreversible Cyclic Voltammetry and Quantification]({{ site.baseurl }}{% post_url 2026-08-07-Simulated-Electrochemistry,-part-3:-Irreversible-CV %})
- **Part 4:** [Anodic Stripping Voltammetry]({{ site.baseurl }}{% post_url 2026-08-10-Simulated-Electrochemistry,-part-4:-Anodic-Stripping-Voltammetry %})
- **Part 5:** [Optimizing the Monte Carlo Simulation]({{ site.baseurl }}{% post_url 2026-08-12-Simulated-Electrochemistry,-part-5 %})
- **Part 6:** Concentration Profiles During Cyclic Voltammetry — *this post*
