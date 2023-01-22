---
Title: "Generating 3d-designs with OpenCASCADE Link"
Date: 2022-07-22
Tags: 3dprinting opencascade
---

During the COVID-19 pandemic, I built a [Prusa MK3S+](https://www.prusa3d.com/category/original-prusa-i3-mk3s/) FDM 3d-printer from a kit.  After printing the requisite pre-made objects, I started designing my own objects.  Although I've more recently moved to doing a lot of work in [Autodesk Fusion360](https://www.autodesk.com/products/fusion-360/overview) (I cranked through [Kevin Kennedy's youtube tutorial ](https://www.youtube.com/watch?v=WKb3mRkgTwg&list=PLrZ2zKOtC_-C4rWfapgngoe9o2-ng8ZBr)over Christmas break), it is always fun to do algorithmically-designed objects--especially since you are printing each object on-demand.  My project here was to design a generative-designed mail caddy, where the size and placement of holes is completely random.  By using circles, it can be printed without supports, while reducing the amount of filament.  Also it looks cool. **To do this, I used the [OpenCASCADE Link](https://reference.wolfram.com/language/OpenCascadeLink/tutorial/UsingOpenCascadeLink.html) in Mathematica...**  
![1qzb9te548eu5](/blog/images/2022/7/22/1qzb9te548eu5.png){: width="250" }

## Exterior shell

The underlying design idea to to create a simple shell and then create a tool that removes that shell.  Here we make the shell.

```mathematica
h = 5.;
o = Sqrt[2]/2.;
w = 1.5;
t = 4./72; (*1.5 mm in inches as frame thickness*)
edge = 12./72; 
 
outer = Cuboid[{0, 0, 0}, {w, GoldenRatio*h, h}];
inner = Cuboid[{t, t, t}, {w - t, GoldenRatio*h - t, h*1.2}];
```

```mathematica
RegionDifference[outer, inner] // Region
```

![1s1p0wnoqf555](/blog/images/2022/7/22/1s1p0wnoqf555.png)

## Generate face punches

Now we define how to punch out the faces.  I do this for each of the faces of the caddy independently.

```mathematica
fInside = Region@Cuboid[{edge, edge}, {GoldenRatio*h - edge, h - edge}]
fFrame = RegionDifference[Cuboid[{0, 0}, {GoldenRatio*h, h}], fInside]
```

![0gsvimzyw1y36](/blog/images/2022/7/22/0gsvimzyw1y36.png)

![1qnlsb20fa38e](/blog/images/2022/7/22/1qnlsb20fa38e.png)

```mathematica
(*warning: uses global variable t and edge*)
  Clear[holePuncher, maxDisk, punch] 
   
   maxDisk[{inside_, frame_}] := With[
     {center = RandomPoint[inside]}, 
     {center, RegionDistance[frame]@center}] 
   
   punch[{inside_, frame_, cuts_, status_}, center_, radius_, t_] := {RegionDifference[inside, Disk[center, radius]], RegionUnion[frame, Annulus[center, {radius - t, radius}]], 
     Append[cuts, {center, radius - t}], 
     status} 
   
   punch[{inside_, frame_, cuts_, status_}, center_, radius_, t_] := {RegionDifference[inside, Disk[center, radius]], RegionUnion[frame, Annulus[center, {radius - t, radius}]], 
     Append[cuts, {center, radius - t}], 
     status} 
   
   holePuncher[{inside_, frame_, cuts_, True}] := Module[
     {center, radius, nearest, maxRadius = 1.5, minRadius = 0.15, distanceFunction, 
      candidatePoints}, 
     
    (*define the distance function*) 
     distanceFunction = RegionDistance@BoundaryDiscretizeRegion[frame]; 
     
    (*distribute 1000 candidate points evenly throughout the area and evaluate distances to boundaries*) 
     candidatePoints = RandomPoint[inside, 1000]; 
     
    (*pick the one that allows us to draw the biggest circle*) 
     center = First@MaximalBy[candidatePoints, distanceFunction, 1]; 
     radius = Min[maxRadius, distanceFunction[center]]; 
     
     If[radius < minRadius, 
      {inside, frame, cuts, False}, 
     (*there is no place where we can fit an acceptable disk, so terminate*) 
     (*else*) 
     (*generate a suitable radius and randomly select a point that satisfies it*) 
      punch[{inside, frame, cuts, True}, center, radius, t] 
     ] (*endif*) 
    ] 
   
  (*when you can't punch any more holes, don't bother continuing*) 
   holePuncher[{inside_, frame_, cuts_, False}] := {inside, frame, cuts, False} 
   
   holePuncher[{inside_, frame_}] := holePuncher[{inside, frame, {}, True}] 
   
  (*convenience wrapper*) 
   holePuncher[{inside_, frame_}, iterations_Integer] := Nest[holePuncher, {inside, frame}, iterations] 
   
   holePuncher[{inside_, frame_, cuts_, status_}, iterations_Integer] := Nest[holePuncher, {inside, frame, cuts, status}, iterations] 
   
  
```

```mathematica
frontPattern = holePuncher[{fInside, fFrame}, 200];
frontPattern[[2]]
```

![1uddyjhy35tew](/blog/images/2022/7/22/1uddyjhy35tew.png)

```mathematica
frontPattern // Last (*can we add moredisks?*)

(*False*)
```

### Rear pattern should have holes punched...

```mathematica
hole1 = {1, h - 1};
hole2 = {h*GoldenRatio - 1, h - 1};
```

```mathematica
rearStart = punch[#, hole2, .5/2, .25/2] &@
     punch[#, hole1, .5/2, .25/2] &@{fInside, fFrame, {}, True}
```

![18j9keba5vf61](/blog/images/2022/7/22/18j9keba5vf61.png)

```mathematica
rearPattern = holePuncher[rearStart, 200];
rearPattern[[2]]
Last[rearPattern]
```

![19fxoqezhkciv](/blog/images/2022/7/22/19fxoqezhkciv.png)

```
(*False*)

(*False*)
```

#### Sides

```mathematica
sInside = Region@Cuboid[{edge, edge}, {w - edge, h - edge}]
sFrame = RegionDifference[Cuboid[{0, 0}, {w, h}], sInside]
```

![1mntmo4lg5luw](/blog/images/2022/7/22/1mntmo4lg5luw.png)

![1hdpit39ddj4r](/blog/images/2022/7/22/1hdpit39ddj4r.png)

```mathematica
lSidePattern = holePuncher[{sInside, sFrame}, 50];
lSidePattern[[2]]
lSidePattern // Last
```

![07txu20wxcb1x](/blog/images/2022/7/22/07txu20wxcb1x.png)

```
(*False*)
```

```mathematica
rSidePattern = holePuncher[{sInside, sFrame}, 50];
%[[2]]
%% // Last
```

![0nvo5zr5wfsnz](/blog/images/2022/7/22/0nvo5zr5wfsnz.png)

```
(*False*)
```

```mathematica
edge

(*0.166667*)
```

### Bottom

```mathematica
bInside = Region@Cuboid[{edge, edge}, {w - edge, h*GoldenRatio - edge}];
bFrame = RegionDifference[Cuboid[{0, 0}, {w, h*GoldenRatio}], bInside];
bPattern = holePuncher[{bInside, bFrame}, 50];
%[[2]]
%% // Last
```

![09omyjc8kgqp9](/blog/images/2022/7/22/09omyjc8kgqp9.png)

```
(*False*)
```

### Create Cylinder objects

```mathematica
cylindrizeFront[res_, xMin_, xMax_] := 
   RegionUnion @@ MapThread[
     Cylinder[{ Prepend[xMin]@#1, Prepend[xMax]@#1}, #2] &, 
     Transpose[res]] 
 
cylindrizeSide[res_, xMin_, xMax_] := 
   RegionUnion @@ MapThread[
     Cylinder[{ {#1[[1]], xMin, #1[[2]]}, {#1[[1]], xMax, #1[[2]]}}, #2] &, 
     Transpose[res]] 
 
cylindrizeBottom[res_, xMin_, xMax_] := 
   RegionUnion @@ MapThread[
     Cylinder[{ {#1[[1]], #1[[2]], xMin}, {#1[[1]], #1[[2]], xMax}}, #2] &, 
     Transpose[res]] 
 
Region[
  cuts = RegionUnion[
    cylindrizeFront[frontPattern[[3]], w/2, w + 1], 
    cylindrizeFront[rearPattern[[3]], w/2, -1], 
    cylindrizeSide[lSidePattern[[3]], -1, 1], 
    cylindrizeSide[rSidePattern[[3]], h*GoldenRatio + 1, h*GoldenRatio - 1], 
    cylindrizeBottom[bPattern[[3]], -1, 1], 
    inner 
   ]]
```

![1qt05sv9733dc](/blog/images/2022/7/22/1qt05sv9733dc.png)

## Process using OpenCASCADE

Using default Mathematica objects tends to crash with very complicated object intersections and differences.  However, the [OpenCASCADE Link](https://reference.wolfram.com/language/OpenCascadeLink/tutorial/UsingOpenCascadeLink.html) module makes it easy to do the underlying processes in [OpenCASCADE](https://en.wikipedia.org/wiki/Open_Cascade_Technology), an industrial-strength open-source computational geometry package.  

```mathematica
Needs["OpenCascadeLink`"]
```

```mathematica
u = OpenCascadeShapeUnion[ OpenCascadeShape /@ cuts[[2]]];
o = OpenCascadeShape[outer]; 
 
d = OpenCascadeShapeDifference[o, u]

(*OpenCascadeShapeExpression[209]*)
```

```mathematica
OpenCascadeShapeSurfaceMeshToBoundaryMesh[d]["Wireframe"]
```

![16qihbqjpj2qo](/blog/images/2022/7/22/16qihbqjpj2qo.png)

Now that we're happy, we can export an [STL file](https://en.wikipedia.org/wiki/STL_(file_format)) which can be imported into your favorite slicer program:

```mathematica
OpenCascadeShapeExport["caddy.stl", d] (*export it for printing*)
Import["caddy.stl"] (*re import the exported STL to visualize*)

(*"caddy.stl"*)
```

![1qzb9te548eu5](/blog/images/2022/7/22/1qzb9te548eu5.png)

If you pull this into your slicer program, you'll find that this design requires:  46.91 g of filament, 4h:4m print time at 0.3mm resolution.  (An earlier version of this program, v2 caddy which required 60g of filament...the difference here is that we fill the holes in more effectively).

(I printed one of these...and it continues to store mail 1.5 years later)

```mathematica
NotebookFileName@EvaluationNotebook[]
ToJekyll["Generating 3d-designs with OpenCASCADE Link", "3dprinting opencascade"];

(*"/Users/jschrier/Dropbox/journals/3dprinting/2021.05.11_caddy_v3.nb"*)
```
