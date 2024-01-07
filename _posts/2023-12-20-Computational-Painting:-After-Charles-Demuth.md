---
title: "Computational Painting: After Charles Demuth"
date: 2023-12-20
tags: llm ai art gpt4 dall-e-3
---

[Eldo asks](https://mathematica.stackexchange.com/questions/295191/how-can-we-reproduce-charles-demuths-figure-5-in-gold):  *How can we reproduce* [Charles Demuth's "Figure 5 in Gold"](https://www.metmuseum.org/art/collection/search/488315)?  **Some fiddling with Dall-E-3/GPT-4/(V)...**

## Things you cannot do

You might be wondering why not just ask directly, and the answer is that [direct references to artists from the last 100 years are prohibited](https://simonwillison.net/2023/Oct/26/add-a-walrus/?utm_source=tldrai#peeking-under-the-hood): 

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "Generate an abstract American Precisionist painting in the style of Charles Demuth's \"I Saw the Figure 5 in Gold\"", 
   "Model" -> "dall-e-3"}]
```

![0n30vkjwoefmp](/blog/images/2023/12/20/0n30vkjwoefmp.png)

![1xzv44rt021gw](/blog/images/2023/12/20/1xzv44rt021gw.png)

## Dall-E-3:  Using the same poem as inspiration prompt

The [painting was inspired by a William Carlos William's poem](https://www.metmuseum.org/art/collection/search/488315)...so maybe we use that as a prompt muse:

```mathematica
poem =  "Among the rainand lights I saw the figure 5 in goldon a red fire truck moving tense unheeded to gong clangs siren howls and wheels rumbling through the dark city"; 
 
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> "Create an illustration of the following poem in the style of an American Precisionism painting. Precisionist artists reduced subjects to their essential geometric shapes and were fascinated by the sleekness and sheen of machine forms:\n" <> poem, 
   "Model" -> "dall-e-3"}]
```

![196yk97osts9w](/blog/images/2023/12/20/196yk97osts9w.png)

Perhaps a bit too literal.  Let's enforce the idea that this is an abstract painting rather than an illustration:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
   {"Prompt" -> "Create an abstract painting about this poem in the style of an American Precisionism painting. Precisionist artists reduced subjects to their essential geometric shapes and were fascinated by the sleekness and sheen of machine forms.  Use bold geometrical forms.  The number 5 should appear in different shades of yellow.  There should be red and black geometrical shapes and white disks. The text is:\n" <> poem, 
   "Model" -> "dall-e-3"}]
```

![1m6a957577ckc](/blog/images/2023/12/20/1m6a957577ckc.png)

Let's also try to force it to not be so literal about the fire engine:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
   {"Prompt" -> "Create an abstract painting about this poem in the style of an American Precisionism painting. Precisionist artists reduced subjects to their essential geometric shapes and were fascinated by the sleekness and sheen of machine forms.  Use bold geometrical forms.  The number 5 should appear in different shades of yellow.  There should be red and black geometrical shapes and white disks. Do not actually depict a literal fire truck, but instead include abstract red blocks. The text is:\n" <> poem, 
   "Model" -> "dall-e-3"}]
```

![0actxdsx5rl9x](/blog/images/2023/12/20/0actxdsx5rl9x.png)

## Use GPT-4-Vision descriptions

Although we cannot name the painting directly, we can try to have GPT-4-V read it and generate a description and use the resulting description to generate new images.  Let's see if we can do it in code...

```mathematica
Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/Misc/LLMVision.m"];
```

![1entjv85n1o4o](/blog/images/2023/12/20/1entjv85n1o4o.png)

```
(*"The painting depicted in the image is a complex composition that combines geometric shapes and textual elements in an abstract manner. It is characterized by:- A dominant central motif of a large circle intersected by the number \"5\", which is prominent in the foreground.- The palette includes shades of red, yellow, black, and white with varying gradients to create a sense of depth and dimensionality.- Angular geometric shapes, including rectangles, triangles, and other polygonal forms, form a background that is reminiscent of Cubist influences. These shapes create a sense of fragmentation and dynamism.- Additional textual elements are visible, for example, \"No. 5\" is written again in the lower part of the circle, and there are fragments of other words and letters, such as \"DILL\" and \"CARLIC,\" appearing in the rest of the composition. The text is stylized and integrated into the geometric design.- The use of shading and perspective suggests a three-dimensional space, and the layering of shapes and colors contributes to a complex, multi-planar effect.- The lighting in the composition appears to be strategically placed to highlight certain elements and enhance the three-dimensionality of the shapes.Creating a similar image using Wolfram Language would be quite involved and require advanced programming techniques to replicate the geometric complexity and color gradients. For a simple approximation that captures geometric and stylistic elements, consider the following code snippet that would generate an abstract composition with a large central number and geometric shapes:```wolframGraphics[{ {Red, Disk[{0, 0}, 1]},{Yellow, Rotate[Text[Style[\"5\", FontSize -> 72, Bold, Italic, FontColor -> White]], Pi/4, {0, 0}]},{Black, Rectangle[{-1.5, -1}, {-0.5, 1}]},{Black, Rectangle[{0.5, -1}, {1.5, 1}]},{White, Polygon[{ {-0.5, 0.5}, {0.5, 0.5}, {0, 1}}]},{Black, Polygon[{ {-0.5, -0.5}, {0.5, -0.5}, {0, -1}}]}},PlotRange -> { {-2, 2}, {-2, 2}},Background -> Gray]```Note that the above code is a very simplified interpretation and would not replicate the intricate details, text elements, or the exact style of the original painting. It would require much more sophisticated programming to approach a closer resemblance, including creating custom shapes, applying gradients, and integrating textual elements properly."*)
```

How does the program look?

```mathematica
Graphics[
  {
    {Red, Disk[{0, 0}, 1]}, 
    {Yellow, Rotate[Text[Style["5", FontSize -> 72, Bold, Italic, FontColor -> White]], Pi/4, {0, 0}]}, 
    {Black, Rectangle[{-1.5, -1}, {-0.5, 1}]}, 
    {Black, Rectangle[{0.5, -1}, {1.5, 1}]}, 
    {White, Polygon[{ {-0.5, 0.5}, {0.5, 0.5}, {0, 1}}]}, 
    {Black, Polygon[{ {-0.5, -0.5}, {0.5, -0.5}, {0, -1}}]} 
   }, 
  PlotRange -> { {-2, 2}, {-2, 2}}, 
  Background -> Gray 
 ]
```

![0vlds6i1bea5g](/blog/images/2023/12/20/0vlds6i1bea5g.png)

## Description plus Dall-E-3

Let's use the text description from above as input to Dall-E-3 (we could do this more programmatically, but I didn't want to make another API request, so I just copy-pasted from above):

```mathematica
With[
  {description = "The painting depicted in the image is a complex composition that combines geometric shapes and textual elements in an abstract manner. It is characterized by:\\n\\n- A dominant central motif of a large circle intersected by the number \"5\", which is prominent in the foreground.\\n- The palette includes shades of red, yellow, black, and white with varying gradients to create a sense of depth and dimensionality.\\n- Angular geometric shapes, including rectangles, triangles, and other polygonal forms, form a background that is reminiscent of Cubist influences. These shapes create a sense of fragmentation and dynamism.\\n- Additional textual elements are visible, for example, \"No. 5\" is written again in the lower part of the circle, and there are fragments of other words and letters, such as \"DILL\" and \"CARLIC,\" appearing in the rest of the composition. The text is stylized and integrated into the geometric design.\\n- The use of shading and perspective suggests a three-dimensional space, and the layering of shapes and colors contributes to a complex, multi-planar effect.\\n- The lighting in the composition appears to be strategically placed to highlight certain elements and enhance the three-dimensionality of the shapes.", 
   prompt = "Precisionist artists reduced subjects to their essential geometric shapes and were fascinated by the sleeknes and sheen of machine forms. Create an illustration in the style of an American Precisionism painting based on the following description:\n" 
  }, 
  ServiceExecute["OpenAI", "ImageCreate", 
   {"Prompt" -> prompt <> description, 
    "Model" -> "dall-e-3"}]]

```

![08w1lwyti8rni](/blog/images/2023/12/20/08w1lwyti8rni.png)

Definitely charming, not at all like the original painting, but has some stylistic resonance

```mathematica
ToJekyll["Computational Painting: After Charles Demuth", "llm ai art"]
```
