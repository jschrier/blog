---
title: "Estimating mosaic material costs from an image"
date: 2025-01-19
tags: art mathematica
---

[Crayonfou](http://crayonfou.com) asks:  *I want to estimate how much* [smalti](https://en.wikipedia.org/wiki/Glass_tile) *to purchase for a 71 inch by 112 inch mosaic for the* [IT High School](https://infotechhs.net)*, based on a cartoon sketch....*

Begin by importing the cartoon image (quantizing the colors because [the artist](https://www.instagram.com/crayonfou/) failed to do so...)...

```mathematica
img = ColorQuantize@ Import["~/Downloads/orderguide.BMP"]
```

![0oo2rc7h5m3c8](/blog/images/2025/1/19/0oo2rc7h5m3c8.png)

(Yes, it is typical that the cartoon is in reverse for the [Ravenna technique](https://mosaicschool.com/art/double_reverse/).) 

## Initial Solution

Start hacking towards an acceptable solution.  Begin by defining a function to count the proportions of pixels having each unique RGB value:

```mathematica
countPixelsByColor[image_] := 
  KeyMap[ Apply[RGBColor]]@ 
     ResourceFunction["Proportions"]@
      Flatten[#, 1] &@ ImageData@ image
```

Multiply by the final area to determine and convert to square feet:

```mathematica
areas = UnitConvert[#, "Square Feet"]&@
    (Quantity[71., "Inches"]*Quantity[112., "Inches"])*
   countPixelsByColor@ img
```

![1xjhlc6u1sg4m](/blog/images/2025/1/19/1xjhlc6u1sg4m.png)

How much should we buy?  We know roughly how many kilograms each square foot requires, but give ourselves a 10% margin of error:

```mathematica
masses = 1.1*Quantity[1.36, "Kilograms / Square Foot"]*areas // Sort
```

![1xnk95kpdq11m](/blog/images/2025/1/19/1xnk95kpdq11m.png)

In practice it useful to right-click on the image and get an RGB browser, which you can compare to the RGB values when mousing over the colors above.

At least how many kilos should we be buying in total?

```mathematica
Total[masses]
```

![1517q03aom1hg](/blog/images/2025/1/19/1517q03aom1hg.png)

(Of course, you must buy a kilo at a time...but you will also be blending colors, so that is left to the artist.)  However, it can be useful to know a rounded upper bound:

```mathematica
Total@ Ceiling@ masses
```

![0mz9z92rvy1g6](/blog/images/2025/1/19/0mz9z92rvy1g6.png)

It became apparent that it would be helpful to be able to separate each channel into an image to see where each color is used, but [ColorReplace](https://reference.wolfram.com/language/ref/ColorReplace.html) did not initially give me the correct outputs.  Trying to understand why, I learned on [StackExchange](https://mathematica.stackexchange.com/questions/59400/why-colorreplace-does-not-follow-the-rules-specified) that you will need to specify a tighter-than-default tolerance with the third argument, otherwise the colors may collapse onto each other (which was indeed the error)

```mathematica
pickColor[img_, color_RGBColor] := 
   ColorReplace[img, {color -> color, _ -> LightGray}, 0.01] 
  
 (* alternative: binarize first to the RGB vector value to avoid collapse *)
(*
pickColor[img_, color_RGBColor]:=With[
  {rgb = Apply[List]@color}, (* convert to vector *)
  ColorReplace[#, {White->color, Black->LightGray}]&@ Binarize[img, #==rgb &]]
*)
```

Show results as a table:

```mathematica
TableForm@ KeyValueMap[{#1, pickColor[img, #1], #2} &]@ masses
```

![0hdz4kzg0v78l](/blog/images/2025/1/19/0hdz4kzg0v78l.png)

## Refined final output

After working through this, I learned of some built-in functions which can streamline the process,  most notably using [DominantColors](https://reference.wolfram.com/language/ref/DominantColors.html) to extract the masks and coverage data. Refactoring the above into four functions, each of which is essentially a 1-liner with some type-checking of the arguments:

```mathematica
(* color in a black and white mask image with the target color *)
  colorReplace[{color_RGBColor, mask_Image, fraction_}, tol_ : 0.01] := With[
    {image = Thumbnail@ ColorReplace[mask, {White -> color, Black -> LightGray}, tol]},
    {color, image, fraction}] 
   
  (* compute the fractional area of each color *) 
   coverage[image_Image, minColorDistance_ : 0.01] := 
    colorReplace /@ 
     DominantColors[image, Automatic, 
      {"Color", "CoverageImage", "Coverage"}, 
      MinColorDistance -> minColorDistance] 
   
  (* multiply fractional area by true area and mass estimate *) 
   estimateMass[
      totalArea_?QuantityQ, 
      margin_ : 1.10, 
      kiloPerArea_ : Quantity[1.36, "Kilograms / Square Foot"] 
     ][{color_, mask_, fraction_}] := With[
     {mass = SetAccuracy[fraction*margin*totalArea*kiloPerArea, 3]}, 
     {color, mask, mass}] 
   
  (* final exposed function; cast Quantity to String for web *) 
   estimateMass[image_Image, area_?QuantityQ] := 
    TableForm@ Map[{#[[1]], #[[2]], ToString[#[[3]]]} &]@
      ReverseSortBy[Last]@ Map[estimateMass[area]]@ coverage[image]
```

Apply the function to our input to generate the final result:

```mathematica
estimateMass[img, Quantity[71., "Inches"]*Quantity[112., "Inches"]]
```

![16p9zlo59dyn5](/blog/images/2025/1/19/16p9zlo59dyn5.png)

## Deploy to the Web

Put this out on the web with a minimal UI:

```mathematica
form = FormFunction[
     {"image" -> "Image", "width" -> "Quantity", "height" -> "Quantity"}, 
     estimateMass[#image, #width*#height] &, 
     "HTML"] 
 
CloudDeploy[form, Permissions -> "Public"]
```

![17x1s361kdnqx](/blog/images/2025/1/19/17x1s361kdnqx.png)

` ***(URL available upon request)*** `

Each query for a 517x800 BMP costs about 5 cloud credits  (so ~10 queries  costs $0.01 USD)

## Possible extensions/future work

- Consistency check that dimensions are length and consistent with the aspect ratio of the image

- Specific a maximum image size/dimension to keep computation time limited

- UI: Combine into a single infographic figure with callouts?

```mathematica
ToJekyll["Estimating mosaic material costs from an image", 
  "art mathematica"]
```
