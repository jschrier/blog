---
title: "Simulated Electrochemistry, part 2: The Randles-Ševčík Equation"
date: 2026-08-05
tags: chemistry mathematica montecarlo science teaching electrochem chiguiro
---

In our [previous episode]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %}), we implemented a Monte Carlo simulation of chronoamperometry, linear sweep voltammetry, and cyclic voltammetry.  In this episode, we adapt this to study the current dependence on scan rate and reproduce the [Randles-Ševčík equation](https://en.wikipedia.org/wiki/Randles-Sevcik_equation)...

## Setting the Scan rate

[Experimentally,](https://blog.iorodeo.com/tutorial-cyclic-voltammetry/) one varies the scanning rate and looks for changes in the peak current; faster scan rates lead to larger currents.  To simulate this, [as before]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %}), we define a list of the thermodynamically rescaled voltages relative to the redox potential of our molecule.  Faster scan rates mean cycling the voltage from the maximum to minimum in fewer time steps.  For convenience, define a helper function for the task: 

```mathematica
Clear[cv]
cv[v0_, time_Integer] := With[
   {v = N@ Rest@ Subdivide[v0, -v0, time/2] }, 
   Join[v, Rest@ Reverse[v]]]
```

...and then use it to define several different one-pass cyclic voltammetry experiments:

```mathematica
expts = cv[10., #]& /@ {60, 120, 200, 250, 400};
ListLinePlot[%, AxesLabel -> {"time", "nF(E-E')/RT"}]
```

![1ewxm8dhv00j6](/blog/images/2026/8/5/1ewxm8dhv00j6.png)

...having different scan rates: 

```mathematica
rates = (#[[-1]] - #[[-2]])& /@ expts

(*{0.666667, 0.333333, 0.2, 0.16, 0.1}*)
```

## Simulation function, revisited

You might be tempted to just throw these voltage functions into the [previous simulation code]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %}), but this will introduce a subtle error.  As you will recall, we sampled possible initial conditions of the molecule up to `Ceiling[6 Sqrt[d t]]`, away from the electrode, where `d = 0.5` is the diffusion coefficient and `t` is the maximum simulation time.  This was done for the sake of computational efficiency--if time is short, the particle is unlikely to diffuse a long distance, and so sampling from far away would mean that even more events would result in no measurement.  But if we naively do this and then try to compare experiments with different time durations, then each of the simulations will be sampling its (fixed) 10^6 trials over different volumes---effectively changing the *concentration* of our system.  We can avoid this problem by modifying the function to take a fixed distance as input and using that for all simulations; when we run it, we shall provide the largest relevant value.  (Alternatively, we could also run different numbers of trials, but that would be more complicated.)  The code below marks changes with comments:  

```mathematica
sweepF = FunctionCompile@Function[ 
    {Typed[vv, TypeSpecifier["PackedArray"]["Real64", 1]], 
     Typed[maxX, TypeSpecifier["Integer16"]]},     (* !! define fixed length *)
    Module[
     {x =  RandomInteger[{1, maxX}],               (* !! use fixed length for each simulation *)
      state = +1, 
      obs = ConstantArray[0, Length[vv]], 
      dx = 2 RandomInteger[{0, +1}, Length[vv]] - 1}, 
     Do[
      x += dx[[t]]; 
       If[x == 0, 
        If[RandomReal[] < 1./(1. + Exp[-vv[[t]]]),  (* !! improve numerical stability *)
         If[state == -1, obs[[t]] = +1; state = +1;], 
         If[state == +1, obs[[t]] = -1; state = -1;] 
        ]; 
        x = 1; 
       ]; 
      , {t, Length[vv]}]; 
     obs 
    ]]
```

![0z0nr4ytp4gla](/blog/images/2026/8/5/0z0nr4ytp4gla.png)

(While we are at it, we may simplify the random number sampling by replacing our `xi/(1.+ xi)` with `1./(1.+ Exp[-vv[[t]]])`; this is algebraically equivalent, avoids the need to define the `xi` variable, and defends against a possible rounding errors should `vv[[t]]` become really large.)

(Sure, we could get away with `Integer8` here, but I'm living high on the hog, profligately squandering 8 bits as if RAM was cheap...)

## How well are simulations described by the Randles-Ševčík equation?

Determine the maximum distance over which to sample for all of the simulations based on the last (longest) experiment:

```mathematica
maxX = Ceiling[6*Sqrt[0.5*Length[Last@expts]]]

(*85*)
```

...and then run the simulations for each voltage profile.  We will take advantage of the compiled function's computational efficiency to collect 10x as many samples, as before, so as to reduce the noise and facilitate identifying the peak positions.  This will take about a minute for each simulation, so about 5 minutes for the entire collection of experiments *(you could get away with using only 10^6 samples, as our peak extraction algorithm will be relatively robust to the noise)*:

```mathematica
obs = ParallelSum[sweepF[#, maxX], {i, 10^7}] & /@ expts;
```

As predicted, the faster scan rates (blue) have a larger peak current:

```mathematica
ListLinePlot@ MapThread[Transpose[{#1, #2}] &]@ {expts, obs}
```

![1pkifkgh13fkb](/blog/images/2026/8/5/1pkifkgh13fkb.png)

Extract the peak currents (using a Gaussian blurring at the scale of 5 adjacent elements in the list) in the oxidation and reduction directions:

```mathematica
peakOxCurrent = (Last@ Last@ FindPeaks[#, 5])& /@ obs

(*{16038, 12167, 10125, 9260, 7548}*)
```

```mathematica
peakRedCurrent = -(Last@ Last@ FindPeaks[-#, 5])& /@ obs (*multiply by -1 to find min*)

(*{5359, 3796, 2961, 2610, 2061}*)
```

The [Randles-Ševčík equation](https://en.wikipedia.org/wiki/Randles-Sevcik_equation) predicts that the peak current (for both the oxidation and reduction curves) is proportional to the square root of the scan rate (with different constants). The fit is pretty good for both oxidation and reduction peak currents:

```mathematica
Transpose[{Sqrt[rates], peakOxCurrent}];
ModelFit[%, "Linear"]
ListPlot[%%, PlotFit -> %, 
  PlotStyle -> Red, AxesLabel -> {"sqrt(scan rate)", "max current"}]
```

![1rzm9qbqmyg1i](/blog/images/2026/8/5/1rzm9qbqmyg1i.png)

![04u0e1dxe5p4q](/blog/images/2026/8/5/04u0e1dxe5p4q.png)

```mathematica
Transpose[{Sqrt[rates], peakRedCurrent}];
ModelFit[%, "Linear"]
ListPlot[%%, PlotFit -> %, 
  PlotStyle -> Red, AxesLabel -> {"sqrt(scan rate)", "max current"}]
```

![0mcfmfvqfu0g8](/blog/images/2026/8/5/0mcfmfvqfu0g8.png)

![0kj8w9ts99cd0](/blog/images/2026/8/5/0kj8w9ts99cd0.png)

For a diffusion-controlled process, the slope of the fit of log(scan rate) and log(peak current) should be about 0.5; in our idealized simulation this is the case and we obtain approximately this exact result measuring either the oxidation or reduction:

```mathematica
N@Log@Transpose[{rates, peakOxCurrent}];
ModelFit[%, "Linear"]
ListPlot[%%, PlotFit -> %, 
  PlotStyle -> Red, AxesLabel -> {"log(rate)", "log(peak current)"}]
```

![0ck2ev8eeqp2y](/blog/images/2026/8/5/0ck2ev8eeqp2y.png)

![0emtk9fux0frr](/blog/images/2026/8/5/0emtk9fux0frr.png)

```mathematica
N@Log@Transpose[{rates, peakRedCurrent}];
ModelFit[%, "Linear"]
ListPlot[%%, PlotFit -> %, 
  PlotStyle -> Red, AxesLabel -> {"log(rate)", "log(peak current)"}]
```

![18yhmm056ran8](/blog/images/2026/8/5/18yhmm056ran8.png)

![07ok81mur0cwu](/blog/images/2026/8/5/07ok81mur0cwu.png)

## Gratuitous Chiguiro Content

[Chiguiros]({{ '/tag/chiguiro' | relative_url }}) are not very good at remembering equations:

```mathematica
ImageSynthesize["Capybara explaining the Randles-Ševčík equation"]
```

![15o5gil6rqery](/blog/images/2026/8/5/15o5gil6rqery.png)

But they can look things up on the internet:

```mathematica
ImageSynthesize["Capybara explaining the following wikipedia page" <> 
  Import["https://en.wikipedia.org/wiki/Randles-Sevcik_equation"]]
```

![11mnwovrirkay](/blog/images/2026/8/5/11mnwovrirkay.png)

Remember to tell them to dress properly to deliver their lecture:

```mathematica
ImageSynthesize[
  "Capybara wearing a bowtie, glasses, and a tweed jacket explaining the following wikipedia page" <>
  Import["https://en.wikipedia.org/wiki/Randles\[Dash]Sevcik_equation"]]
```

![1qch9moz35osj](/blog/images/2026/8/5/1qch9moz35osj.png)


```mathematica
ToJekyll["Simulated Electrochemistry, part 2", "chemistry mathematica montecarlo science teaching electrochem"]
```

## Monte Carlo Simulations of Electrochemistry

- **Part 1:** [Monte Carlo Simulation of Diffusion, Chronoamperometry, Linear & Cyclic Voltammetry]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %})
- **Part 2:** Reproducing the Randles–Ševčík Relation — *this post*
- **Part 3:** [Irreversible Cyclic Voltammetry and Quantification]({{ site.baseurl }}{% post_url 2026-08-07-Simulated-Electrochemistry,-part-3:-Irreversible-CV %})
- **Part 4:** [Anodic Stripping Voltammetry]({{ site.baseurl }}{% post_url 2026-08-10-Simulated-Electrochemistry,-part-4:-Anodic-Stripping-Voltammetry %})
- **Part 5:** [Optimizing the Monte Carlo Simulation]({{ site.baseurl }}{% post_url 2026-08-12-Simulated-Electrochemistry,-part-5 %})
