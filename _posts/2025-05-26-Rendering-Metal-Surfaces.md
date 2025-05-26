---
title: "Rendering Metal Surfaces"
date: 2025-05-26
tags: mathematica santafe art opencascade
---

I want to try computationally modeling the surface of indented [tinwork](https://amzn.to/3Fukcb3) items (after taking a class with [Cleo Romero](https://cleoromero.com) at [MAKE Santa Fe](http://makesantafe.org)).  The [physically based rendering](http://reference.wolfram.com/language/tutorial/PhysicallyBasedRendering.html) provided by [MaterialShading](http://reference.wolfram.com/language/ref/MaterialShading.html) should do the heavy lifting of rendering [objects created by constructive solid geometry](http://reference.wolfram.com/language/ref/CSGRegion.html), **but there are some tricks to make this work....**

## The Setup

Begin by defining the work plane and some positive and negative indentations (viewed from the top), and combine them using [CSGRegion](http://reference.wolfram.com/language/ref/CSGRegion.html): 

```mathematica
positive = CSGRegion@
    Table[Ball[{RandomReal[{-5, 5}], RandomReal[{-5, 5}], 0}, 0.2], 10];
negative = CSGRegion@ 
    Table[Ball[{RandomReal[{-5, 5}], RandomReal[{-5, 5}], 0}, 0.2], 10];
plane = Cuboid[{-5, -5, -0.2}, {5, 5, 0.0}]; 
 
g = CSGRegion["Difference", {#, negative}]&@ CSGRegion["Union", {positive, plane}]
```

```mathematica

```

![1k1761popjmb7](/blog/images/2025/5/26/1k1761popjmb7.png)

## The Problem: CSGRegions do not render

Except, there is a problem:  The resulting CSGRegion does not accept MaterialShading:

```mathematica
Graphics3D[{MaterialShading["Gold"], g}]
```

![0gug38dcblv28](/blog/images/2025/5/26/0gug38dcblv28.png)

There is also another problem with the CSGRegion....it does not export to an STL file!  If we round trip this, we only get the flat sheet:

```mathematica
Export["~/Downloads/foo.stl", g]
Import[%]

(*"~/Downloads/foo.stl"*)
```

![15y71xfh798z5](/blog/images/2025/5/26/15y71xfh798z5.png)

How shall we fix this problem?

## OpenCascadeLink to the Rescue

[OpenCascadeLink](http://reference.wolfram.com/language/OpenCascadeLink/tutorial/UsingOpenCascadeLink.html) help us in exporting this, but even then there are some tricks to consider. Conveniently, OpenCascadeShape accepts any CSGRegion as input, which is convenient:

```mathematica
Needs["OpenCascadeLink`"]

oc = OpenCascadeShape[g]
OpenCascadeShapeSurfaceMeshToBoundaryMesh[oc]["Wireframe"] (* visualize *)

```

![01dirq9w6crn6](/blog/images/2025/5/26/01dirq9w6crn6.png)

We are not out of the woods yet, as it does not export these expressions! 

```mathematica
Export["~/Downloads/foo1.stl", oc]
```

![18fu8yhaevwbw](/blog/images/2025/5/26/18fu8yhaevwbw.png)

```
(*$Failed*)
```

However, the [OpenCascadeLink](http://reference.wolfram.com/language/OpenCascadeLink/tutorial/UsingOpenCascadeLink.html) Import/Export documentation describes a workaround, which involves converting a shape into a a [MeshRegion](http://reference.wolfram.com/language/ref/MeshRegion.html) for export to fix problematic boundary normals:

```mathematica
mr = MeshRegion@ OpenCascadeShapeSurfaceMeshToBoundaryMesh[oc];
Export["~/Downloads/foo2.stl", mr]

(*"~/Downloads/foo2.stl"*)
```

We can then [Import the STL](http://reference.wolfram.com/language/ref/format/STL.html) back in (where it will get converted to a [Graphics3D](http://reference.wolfram.com/language/ref/Graphics3D.html) item) and see that it renders nicely:

```mathematica
Graphics3D[
  {MaterialShading["Gold"], 
   Import["Downloads/foo2.stl"]}, 
  Lighting -> "Neutral"]
```

![16hbf057vy6sz](/blog/images/2025/5/26/16hbf057vy6sz.png)

Our desired pattern is more silvery; there are a few options but Iron is reasonable:

```mathematica
Graphics3D[
  {MaterialShading["Iron"], 
   Import["Downloads/foo2.stl"]}, 
  Lighting -> "Neutral"]
```

![0w7hc5jn4sb1f](/blog/images/2025/5/26/0w7hc5jn4sb1f.png)

## Ideas to explore: Rendering complex patterns

- Halftone shading--specifically [stochastic screening](https://en.wikipedia.org/wiki/Stochastic_screening)

- [Floyd-Steinberg dithering](https://en.wikipedia.org/wiki/Floyd-Steinberg_dithering) ... or better yet, an [Atkinson dither](https://beyondloom.com/blog/dither.html)

- [Ditherpunk](https://surma.dev/things/ditherpunk/) is an aesthetic

- There is [an App for that](https://apps.apple.com/us/app/retro-dither-b-w-is-beautiful/id1586423971?mt=12)... whose [core code (in python) for the Atkinson dither is available on github ](https://github.com/davecom/ComputerScienceFromScratch/tree/main/RetroDither)

```mathematica
ToJekyll["Rendering Metal Surfaces", "mathematica santafe art opencascade"]
```
