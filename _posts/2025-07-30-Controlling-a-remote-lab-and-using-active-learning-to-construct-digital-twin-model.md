---
title: "Controlling a remote lab and using active learning to construct digital twin model"
date: 2025-07-30
tags: science claude-light sdl ml teaching mathematica
---

[John Kitchin](https://scholar.google.com/citations?user=jD_4h7sAAAAJ&hl=en&oi=ao) recently described [Claude-Light](https://doi.org/10.1063/5.0266757) (a REST API accessible Raspberry Pi that controls an RGB LED with a photometer that measures ten spectral outputs) as a lightweight, remotely accessible instrument for exploring the idea of self-driving laboratories.  **Here we demonstrate how to implement a very basic active learning loop using this remote instrument in Mathematica...**

## Backstory

The idea of an [autonomous experiment systems (AES)](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&citation_for_view=zJC_7roAAAAJ:eflP2zaiRacC) or self-driving laboratory (SDL) has fascinated me since my participation in the [2017 Materials Acceleration Platform report](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&citation_for_view=zJC_7roAAAAJ:_B80troHkn4C) and [continues to this day](https://doi.org/10.1038/s41467-025-59231-1).  This is now a major field with large investments made throughout the world([1](https://doi.org/10.1039/D4DD00387J))([2](https://doi.org/10.1039/D5DD00072F)).  But if we want this emerging field to be accessible to researchers (and students!) then [frugal SDLs](https://pubs.rsc.org/en/content/articlehtml/2024/dd/d3dd00223c) are needed. The cheapest reagents are photons, and so there are various light-based SDL projects intended for teaching, in which the experimental input is the setting of an RGB LED and the output is a colorimetric response, of which [Claude-Light ](https://doi.org/10.1063/5.0266757)is the latest example. What sets it apart is that it is web-accessible, so that students operate the hardware and obtain measurements remotely.  The sensors are deliberately *not* shielded from ambient light in the office, so in addition to the inherent measurement noise of the sensors there will also be other variations that occur independent of the LED setting (not unlike how [uncontrolled changes in ambient lab humidity can affect crystallization outcomes](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&cstart=20&pagesize=80&sortby=pubdate&citation_for_view=zJC_7roAAAAJ:fQNAKQ3IYiAC)).

Here is what it looks like:
![0cgk44qwot4s4](/blog/images/2025/7/30/0cgk44qwot4s4.png)

One general strategy in automated science is acquiring data from an instrument and building a *digital twin* (i.e., a machine learned model of a physical system) that predicts the output values for a given input. In typical supervised machine learning you have a bunch of pre-obtained data and must construct a model. 
However, if you can tell the SDL what new data to acquire (i.e., what experiment to perform) then you can instead perform *active learning*  improve the model quality with fewer experiments.  We have previously applied active learning to various problems such as [perovskite crystal growth](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&cstart=20&pagesize=80&sortby=pubdate&citation_for_view=zJC_7roAAAAJ:mvPsJ3kp5DgC) (including a [bakeoff-style competition](https://dx.doi.org/10.26434/chemrxiv-2022-l1wpf-v2) of various methods) and [nanocrystal ligand selection](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&sortby=pubdate&citation_for_view=zJC_7roAAAAJ:dQ2og3OwTAUC).

**Goal:**  Demonstrate how to read data from a remote Claude-Light and how to train and evaluate an active learning model using that data, in the Wolfram language.

## Claude-Light

- You can read all about it in the [Claude-Light ](https://doi.org/10.1063/5.0266757)paper (including a basic usage tutorial in Python)

- Or just go over to the [github repository](https://github.com/jkitchin/claude-light) and check out some example exercises.

- Or just [hop on the instrument web site](https://claude-light.cheme.cmu.edu/rgb) and start banging on it a bit to get some intuition.

## Acquiring Values from Claude-Light

We do not want to manually acquire data...we want our program to do it for us.  Conveniently, [Claude-Light exposes a REST API](https://github.com/jkitchin/claude-light?tab=readme-ov-file#the-api-endpoint) that we can use to acquire data by performing an HTTP GET call.  We shall do this by using a simple [URLExecute](http://reference.wolfram.com/language/ref/URLExecute.html) to provide the URL and parameters. (Should you want to perform more complicated HTTP requests, or build in error handling, you would first construct a  [HTTPRequest](http://reference.wolfram.com/language/ref/HTTPRequest.html) and then evaluate that, check error messages, etc.  We shall keep it simple here.)  Our input is a triple of RGB values provided as real numbers between 0 and 1:

```mathematica
measurement[{r_, g_, b_}] := 
  URLExecute["https://claude-light.cheme.cmu.edu/api", {"R" -> r, "G" -> g, "B" -> b}]
```

Take a look at an example:

```mathematica
measurement[{0.1, 0.2, 0.3}]

(*
{"in" -> {0.1, 0.2, 0.3}, 
 "out" -> {"415nm" -> 1549, "445nm" -> 11055, "480nm" -> 7418, "515nm" -> 16576, 
  "555nm" -> 6108, "590nm" -> 6556, "630nm" -> 8111, "680nm" -> 5982, "clear" -> 46032, "nir" -> 7787}}
*)
```

We are going to focus our model on learning one wavelength, so let us [Query](http://reference.wolfram.com/language/ref/Query.html) this output to see what happened at that one wavelength:

```mathematica
measure445nm[in_] := Query["out", "445nm"]@ measurement@ in
```

## Active Learning in Mathematica

One *could* just perform standard supervised machine learning: query a bunch of random samples, organize them into a table, and then build a machine learning model to describe the input-output behaviour using [Predict](http://reference.wolfram.com/language/ref/Predict.html).  But the more efficient active learning approach is to let our model select the next sample to query based on the model uncertainty at each step.  The [ActivePrediction](http://reference.wolfram.com/language/ref/ActivePrediction.html) superfunction will iteratively query a function, `f`, to attempt to learn an approximation, trying different machine learning methods along the way. In our case, `f` will be the `measure445nm` function defined above.

```mathematica
?ActivePrediction
```

![0digcw2d59tjv](/blog/images/2025/7/30/0digcw2d59tjv.png)

The default options are mostly reasonable:

```mathematica
Options[ActivePrediction]
```

> (* {ClassPriors -> Automatic, FeatureExtractor -> Identity, FeatureNames -> Automatic, FeatureTypes -> Automatic, IndeterminateThreshold -> 0, InitialEvaluationHistory -> None, "InitialEvaluationNumber" -> Automatic, MaxIterations -> Automatic, Method -> "MaxEntropy", PerformanceGoal -> Automatic, RandomSeeding -> 1234, "ShowTrainingProgress" -> True, TimeConstraint -> \[Infinity], UtilityFunction -> Automatic, ValidationSet -> Automatic} *)


Notice how the default method chooses new configurations (i.e., RGB points) for which the learned predictor function has the maximum uncertainty.  (It is possible to specify a particular model choice with the Method option, and indeed, we expect [LinearRegression](http://reference.wolfram.com/language/ref/method/LinearRegression.html) to work fine for this type of problem, but we will let [ActivePrediction](http://reference.wolfram.com/language/ref/ActivePrediction.html) figure it out for us.)  Note also how [RandomSeeding](http://reference.wolfram.com/language/ref/RandomSeeding.html) is automatically specified for better reproducibility.   We will limit the number of function evaluations (MaxIterations), but it may also be useful to set a [TimeConstraint](http://reference.wolfram.com/language/ref/TimeConstraint.html) (this will be the time needed to acquire the data and build the models). 

## Active Learning 

In practice, this is simple; it could be a one-liner, but I shall comment each input argument to the function:

```mathematica
result = ActivePrediction[
   measure445nm,        (* function to call to request a sample *)
   Cuboid[],            (* boundary of input: Unit cube from [0,1] on 3 axes *)
   MaxIterations -> 25] (* set upper bound on number of function calls allowed *)
```

![10k2h50xnpbw0](/blog/images/2025/7/30/10k2h50xnpbw0.png)

Run this and you will see some interactive progress.  When completed, one can query the returned [ActivePredictionObject](http://reference.wolfram.com/language/ref/ActivePredictionObject.html) to learn about the process and the final results: 

```mathematica
result["Properties"]

(* {"OracleFunction", "EvaluationHistory", "Method", "Properties", "LearningCurve",
   "TrainingHistory", "PredictorFunction", "PredictorMeasurementsObject"} *)
```

What were the sampled input configurations and returned values?

```mathematica
result["EvaluationHistory"]
```

![0q5r1xc49r91b](/blog/images/2025/7/30/0q5r1xc49r91b.png)

What data was acquired and in what order?  (As you can see by the arrows, we bounce around the input space...)

```mathematica
With[
  {pts = Normal@result["EvaluationHistory"][All, "Configuration"]}, 
  Graphics3D[
   {PointSize[Large], 
    Point[pts, VertexColors -> (RGBColor @@@ pts)], 
    LightGray, Arrowheads[0.03], 
    Arrow /@ Partition[pts, 2, 1]}, 
   Axes -> True, AxesLabel -> {"R", "G", "B"}]]
```

![1d2i19cu5ymis](/blog/images/2025/7/30/1d2i19cu5ymis.png)

How did the model improve as we increased the number of training examples?

```mathematica
result["LearningCurve"]
```

![180d03xd30eeg](/blog/images/2025/7/30/180d03xd30eeg.png)

What are the summary statistics about the learned model and its performance?

```mathematica
result["PredictorMeasurementsObject"]
```

![1qq7xfhgtd8g6](/blog/images/2025/7/30/1qq7xfhgtd8g6.png)

Uncertainty can be quantified by requesting a distribution description of the predicted outcome, and then work with that symbolic [NormalDistribution](http://reference.wolfram.com/language/ref/NormalDistribution.html) to extract the 95%-confidence limit, plot the [probability density function](http://reference.wolfram.com/language/ref/PDF.html), etc. Let us consider a randomly generated test point in the RGB input space: 

```mathematica
test = RandomPoint@Cuboid[]; 
 
prediction = result["PredictorFunction"][test, "Distribution"]
Quantile[%, {0.025, 0.975}] 
 
Plot[
  PDF[prediction, x], 
  Prepend[x]@ MinMax@ result["EvaluationHistory"][All, "Value"], 
  PlotRange -> All]

(*NormalDistribution[25612.5, 95.5023]*)

(*{25425.3, 25799.7}*)
```

![0lttfcx28w6vy](/blog/images/2025/7/30/0lttfcx28w6vy.png)

 In practice this prediction is pretty good and falls well within our 95% CL:

```mathematica
actual = output445nm[test]

(*25496*)
```

However...remember that by construction, Claude-Light does not isolate the sensors from the ambient environment.  This means that a model that we train at noon (when sun is shining in the window and the office lights are on) will not necessarily make a good prediction at midnight (hopefully Prof. Kitchin is sleeping).  

## Possible Next Steps

- Saving a shareable archive of your experimental data using [libSQL](https://docs.turso.tech/introduction)...[see the next episode on this blog]({{ site.baseurl }}{% post_url 2025-07-31-Distributed-data-storage-with-libSQL %}) 

- Incorporating side information into the model (time of day, sun position, is it during working hours, etc.)

- Explore combined [meta-learning / active learning](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&cstart=20&pagesize=80&sortby=pubdate&citation_for_view=zJC_7roAAAAJ:kRWSkSYxWN8C) strategies for this problem
  - One concrete direction would be to use [linear-model metalearning (LAMel)](https://arxiv.org/abs/2509.13527)

- Reframe the problem as an optimization (minimize the difference between a target output and the generated output) and optimize it iteratively using [BayesianMinimization](http://reference.wolfram.com/language/ref/BayesianMinimization.html)


```mathematica
ToJekyll["Controlling a remote lab and using active learning to construct digital twin model, part 1", "science sdl ml teaching mathematica"]
```


# Parerga and Paralipomena

- [LabLands](https://labsland.com/) sells remote-lab experiences for electronics and chemistry (including some gen-chem style experiments).  They will sell you the hardware or just sell you a license to operate it remote-control. Learned about this from [a Digikey blog post.](https://www.digikey.com/en/blog/elevating-engineering-labs-with-labsland), which describes some deployments and pedagogy papers (mainly focused on electronics education, naturally) 