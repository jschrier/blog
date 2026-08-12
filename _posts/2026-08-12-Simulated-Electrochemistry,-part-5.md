---
title: "Simulated Electrochemistry, part 5: The Need for Speed"
date: 2026-08-12
tags: chemistry mathematica montecarlo science teaching electrochem chiguiro
---

Our electrochemical Monte Carlo simulations require many evaluations to limit the noise in the simulated results and explorations over many different experimental conditions.  While our [initial implementation]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %}) was aimed at conceptual simplicity, **we will explore here how to make further modifications to achieve an additional 16x speedup in computational efficiency to unlock more ambitious simulations...**

## Notional Experiment

For simplicity, we will perform a simple cyclic voltammetry experiment to use as a benchmarking example, using the code from [Part 2]({{ site.baseurl }}{% post_url 2026-08-05-Simulated-Electrochemistry,-part-2 %}):

```mathematica
Clear[cv]
cv[v0_, time_Integer] := With[
    {v = N@Rest@Subdivide[v0, -v0, time/2] }, 
    Join[v, Rest@Reverse[v]]] 
 
expt = cv[10., 400]; (* demo *)
```

## Monte Carlo Simulation, Revisited

[Part 1]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %}) introduced the notion of simulating  the one-dimensional diffusion problem using a discrete-time-step Monte Carlo simulation.  The analyte begins in the oxidized state (M+) in solution at some random position in solution, and then takes a random walk during its trajectory.  If it reaches the electrode, then it has the possibility of reacting as governed by the Boltzmann-Nernst probability.  The reaction is assumed to be electrochemically reversible and occurs immediately upon impingement upon the electrode.  We saw that compiling the code lead to a 10x speed improvement over the interpretted version.  [Part 2]({{ site.baseurl }}{% post_url 2026-08-05-Simulated-Electrochemistry,-part-2 %}) expanded this slightly to specify the distance range over which to sample the initial particle position and some numerical simplifications.  We shall use the Part 2 code as our starting point.

For the sake of conceptual simplicity, the function was defined to perform the time evolution of a single candidate particle. This is often a helpful way to build a Monte Carlo simulation--just focus on one trial.  The final simulation is then the sum of these many events, which we performed using a ParallelSum operation.  Here is the code from [Part 2]({{ site.baseurl }}{% post_url 2026-08-05-Simulated-Electrochemistry,-part-2 %}) to remind you, followed by a timing benchmark (output is in seconds):

```mathematica
sweepF = FunctionCompile@Function[ 
     {Typed[vv, TypeSpecifier["PackedArray"]["Real64", 1]], 
      Typed[maxX, TypeSpecifier["Integer16"]]}, 
     Module[
      {x =  RandomInteger[{1, maxX}],  
       state = +1, 
       obs = ConstantArray[0, Length[vv]], 
       dx = 2 RandomInteger[{0, +1}, Length[vv]] - 1}, 
      Do[
       x += dx[[t]]; 
        If[x == 0, 
         If[RandomReal[] < 1./(1. + Exp[-vv[[t]]]), 
          If[state == -1, obs[[t]] = +1; state = +1;], 
          If[state == +1, obs[[t]] = -1; state = -1;] 
         ]; 
         x = 1; 
        ]; 
       , {t, Length[vv]}]; 
      obs 
     ]] 
 
ParallelSum[sweepF[expt, 86], {i, 10^6}]; // AbsoluteTiming
```

![05a4l8keilu0x](/blog/images/2026/8/12/05a4l8keilu0x.png)

```
(*{7.60349, Null}*)
```

As a comment, this ParalleSum evaluation used 8 kernels on the local machine to perform the evaluation. 

## Make it faster by compiling the loop

While the `sweepF` function is compiled, [ParallelSum](https://reference.wolfram.com/language/ref/ParallelSum.html) is an interpreted function.  Furthermore, parallel calculation involves overhead in initializing the parallel kernels and collecting the results, and intermediate memory usage in retaining the intermediate output vectors before summing them.  A path towards a faster evaluation is to perform the entire loop *inside* the compiled function---essentially just to nest the prior trial inside an additional `Do` loop, resetting some variables (like the initial position, `x`, the random moves, `dx`, and the charge `state`) at the beginning of each trial, and retaining a persistent record of the observed charging processes, `obs`, which gets [incremented](https://reference.wolfram.com/language/ref/Increment.html) or [decremented](https://reference.wolfram.com/language/ref/Decrement.html) during each trial to built up the final sum over the events:

```mathematica
sweepF2 = FunctionCompile@Function[ 
     {Typed[vv, TypeSpecifier["PackedArray"]["Real64", 1]], 
      Typed[maxX, TypeSpecifier["Integer16"]], 
      Typed[nMC, TypeSpecifier["UnsignedInteger64"]]},  (*!! specify the number of MC trials *)
     Module[
      {x, dx, state, obs, 
       maxTime = Length[vv]}, 
      obs = ConstantArray[0, maxTime];                  (*!! initialize observations *)
      Do[                                               (*!! loop over MC steps *)
       x = RandomInteger[{1, maxX}];                        (*!! reinitialize the trial *)
        dx = 2 RandomInteger[{0, +1}, maxTime] - 1; 
        state = +1; 
        Do[                                                 (*!! loop over simulation time *)
         x += dx[[t]]; 
          If[x == 0, 
           If[RandomReal[] < 1./(1. + Exp[-vv[[t]]]), 
             If[state == -1, obs[[t]]++; state = +1;],      (*!! increment, not assign *)
             If[state == +1, obs[[t]]--; state = -1;]       (*!! decrement, not assign *) 
            ]; 
           x = 1;                                           (* even if no reaction occurs, return to solution *) 
          ]; 
         , {t, maxTime}]; 
       , nMC]; 
      obs 
     ]] 
 
sweepF2[expt, 86, 10^6]; // AbsoluteTiming
```

![03u9ri8hje7sm](/blog/images/2026/8/12/03u9ri8hje7sm.png)

```
(*{3.65595, Null}*)
```

These modifications speed up the wall time (i.e., elapsed real time) by 2x, but use only one (not 8!) core to achieve that goal, so it is  16x more efficient.  We can now use [ParallelMap](https://reference.wolfram.com/language/ref/ParallelMap.html) operations over different experimental conditions to advance our electrochemistry studies.

## Conclusion

The first goal in scientific computing is to write a simulation that is correct and clear.  Only after that is achieved should you try to make it fast.  A general pattern in writing [Monte Carlo simulations]({{ '/tag/montecarlo' | relative_url }}) is to focus on writing a single trial first, and then using parallelization to speed up the independent evaluations.  But computational efficiency often beats brute force parallelism---one rabbit can pull you faster than 8 turtles.

```mathematica
ImageSynthesize["A race scene, drawn in the style of Beatrix Potter. One capybara (dressed in a red roman soldier outfit) is riding on a chariot pulled by **EIGHT** turtles. The reins must go to a yoke on each of the eight turtles. IMPORTANT that the reins only go to the turtles and nothing else. Another Capybara (dressed in a blue roman soldier outfit) is  riding on a saddle on one rabbit. Both are riding towards the right."]
```

![0iarx5qpkpgmw](/blog/images/2026/8/12/0iarx5qpkpgmw.png)

```mathematica
ToJekyll["Simulated Electrochemistry, part 5", 
  "chemistry mathematica montecarlo science teaching electrochem chiguiro"]
```

## Monte Carlo Simulations of Electrochemistry

- **Part 1:** [Monte Carlo Simulation of Diffusion, Chronoamperometry, Linear & Cyclic Voltammetry]({{ site.baseurl }}{% post_url 2026-08-01-Simulated-Electrochemistry %})
- **Part 2:** [Reproducing the Randles–Ševčík Relation]({{ site.baseurl }}{% post_url 2026-08-05-Simulated-Electrochemistry,-part-2 %})
- **Part 3:** [Irreversible Cyclic Voltammetry and Quantification]({{ site.baseurl }}{% post_url 2026-08-07-Simulated-Electrochemistry,-part-3:-Irreversible-CV %})
- **Part 4:** [Anodic Stripping Voltammetry]({{ site.baseurl }}{% post_url 2026-08-10-Simulated-Electrochemistry,-part-4:-Anodic-Stripping-Voltammetry %})
- **Part 5:** Optimizing the Monte Carlo Simulation — *this post*
