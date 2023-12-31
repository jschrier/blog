---
Title: "Computational Sculpture: After Damon Hamm, part 1"
Date: 2023-12-14
Tags: sculpture art llm gpt4v dall-e-3
---

[Damon Hamm](https://www.damonhamm.com) writes: *I'm WAAAAAY into the idea of making my own custom agent that ingests my previous writings, proposals, and sculpture descriptions to write more like I would. ... Let's make something cool!* **Let's investigate taking photos of one of his sculptures and evolve them by using** **[GPT-4V(ision)](https://openai.com/research/gpt-4v-system-card)** **to describe the sculpture and** **[Dall-E-3](https://openai.com/dall-e-3)** **to generate a new image of a sculpture based on that description...**

We start with an image of Hamm's *[From Orion](https://www.damonhamm.com/from_orion)*[ sculpture,](https://www.damonhamm.com/from_orion) downloaded from his website: 

```mathematica
img = Import["https://images.squarespace-cdn.com/content/v1/547bc8b6e4b01e4f655d007a/337f3a0b-ce3f-41d7-92ed-51a1dcd33395/2023-08-05+FROM_ORION+Dubuque+IA-03.jpeg?format=1024w"]
```

![17129sopgjala](/blog/images/2023/12/14/17129sopgjala.png)


Next: define some functions that make API calls to describe the image and visualize the descriptions:

```mathematica
Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/Misc/LLMVision.m"];


describe[img_] := LLMVisionSynthesize[
   "Describe the sculpture depicted in this image.  Emphasize the structural and geometric aspects, so that the description is thorough enough to redraw it.", 
    img, 
    "MaxTokens" -> 1000] 
 
visualize[description_] := First@ServiceExecute["OpenAI", "ImageCreate", 
    {"Prompt" -> description, "Model" -> "dall-e-3"}]
```

Now we just apply this repeatedly to see what happens.  We could write an explicit loop, but I just wanted to see where this goes...

```mathematica
description = describe[img]
img2 = visualize[description]
```

This sculpture features a series of tall, slender, metallic elements that fan out from a central spherical base. Here's a structured breakdown to assist in visualizing or drawing the sculpture:

1. Base: The sculpture sits atop a round, dome-like base that appears to be made of a different texture or material, which resembles hammered or textured metal. This half-sphere serves as the anchor point for the rising elements.

2. Rising Elements: Approximately 12-15 individual, elongated elements emerge from the central base. They are tall and vary in width, with some looking narrower than others. Each appears to be a slender, elongated metal sheet, with a slight curvature, reminiscent of flat petals or reeds. They are not uniform, instead, each has its own unique bending and twist, adding to a dynamic and organic composition.

3. Form and Arrangement: These metallic elements rise upwards and outwards, diverging as they ascend. They are positioned in a bouquet-like arrangement, reminiscent of stalks of grass or reeds. The elements near the center are taller, giving the structure a tapered, flame-like silhouette when viewed from certain angles.

4. Surface: The metal surface of the elements is reflective and seems polished, with light creating highlights and shadows that accentuate their three-dimensional form. Their surfaces vary from smooth to slightly wavy, which would interact with light giving the sculpture a shimmering quality.

5. Proportions: The overall height of the sculpture is significant compared to its width, and it dominates the space it occupies, adding a vertical dimension to the landscape. 

6. Assembly: The elements are fixed to the base, possibly welded, and the way they converge at the bottom suggests that they are hollow or have an internal support structure.

7. Finish: It appears to have a chrome or stainless steel finish, giving it a modern, industrial look.

These details about the form, texture, and composition of the sculpture should help create a substantial understanding of its design for redrawing purposes. Remember that the specific number of elements, their precise curvature, and their arrangement would need to be observed directly to fully replicate the sculpture's geometry and structure.

![1lmwdugypjp2g](/blog/images/2023/12/14/1lmwdugypjp2g.png)

```mathematica
description2 = describe[%]
img3 = visualize[%]
```

This is a sculpture that features a bouquet-like arrangement of metallic elements, all emanating from a central, circular base. Here is a structural and geometric breakdown of the sculpture:

1. Base: The sculpture sits on a flat, textured, circular base with a slightly raised, broad rim and a smooth, bulging center from which the elements arise. The base has a crisscross texture resembling a finely woven basket or brushed metal finish.

2. Elements: The metallic elements are elongated, flattened, and have varying lengths and widths. They all originate from the center of the base and spread outwards, somewhat resembling the individual petals or leaves of a plant. Think of the base as the center of a flower, and the elements as the petals.

3. Design of Elements: Each element has a smooth finish, with a gentle curve that gives them a three-dimensional and organic shape. Some taper to a rounded point, while others appear to have a tear or oval-shaped tip. The elements are not uniform; they display a variety of widths and shapes, with some being more elongated and slender while others are broader and more leaf-like.

4. Arrangement: The arrangement of the elements is such that they create open spaces between them, which contributes to an airy, plant-like appearance. Some elements are quite vertical, while others curve outward more strongly. The overall effect is dynamic and resembles a natural growth pattern.

5. Light and Shadow: The sculpture is illuminated in a way that suggests a light source from above. This creates shadows that fall toward the viewer, emphasizing the curvature of the elements and their three-dimensional form. Light reflects off the surfaces differently, indicating a variety of polished finishes, some with a more satin texture and others with a mirrored shine.

6. Color and Texture: The sculpture is uniformly metallic in color, hinting at a material like steel, aluminum, or some type of metal alloy. The finish is mostly smooth, with reflectivity indicating a polished surface, although the base has a noticeably different texture. There is no color variation--it's a monochromatic silver-gray palette throughout.

Considering these details as guides, one could recreate a drawing or model of the sculpture paying attention to the organic distribution of its elements, the variety in shapes and reflections, and the textural differences between the base and the petal-like protrusions.

![0xhlpizukqkgm](/blog/images/2023/12/14/0xhlpizukqkgm.png)

```mathematica
describe[%]
visualize[%]
```

The sculpture depicted in the image displays a complex assembly of abstract, organic shapes, which collectively evoke the image of a lush, fantastical arrangement of flora. It resides on a cylindrical base with an intricate relief texture that could resemble either organic or geometric patterns upon close inspection.

From this base, a multitude of leaf-like and petal-like elements emerge, varying greatly in size and form. They have a metallic finish that ranges from high-gloss to matte, likely to emulate different metallic materials or surface treatments.

Each leaf/petal element is characterized by distinct repeated line patterns, simulating the fine veins of leaves or the texture of petals. These lines give an impression of movement and flow, enhancing the dynamism of the sculpture.

Some of the shapes take on a conventional leaf-like appearance with pointed tips and a central vein-like line from which the other lines emanate, similar to the structure of a feather. Others are more abstract, involving spirals and undulating forms, some resembling twisted ribbons or thinly stretched cones. A few elements appear as spherical nodes with concentric circular lines, interspersed amongst the petals, giving the impression of bloomed flowers or perhaps seedpods.

Structurally, the elements overlap and intertwine, suggesting growth and interaction, yet each retains its own distinct texture and curvature. The sculpture appears to bloom outwards from the central axis, with the elements positioned at various angles to create a sense of fullness and three-dimensional depth.

For a redraw, it is important to create a wide variety of these leaf/petal shapes, each with its own individual line pattern that imitates organic textures. The metallic shine and different brightness levels should be represented by varying shades, highlights, and shadows to convey the material quality of the separate components. Emphasis should be placed on the interplay of light, shadow, and line to depict the sculpture's reflective surface and intricate details accurately.

![1i3iey5j2h5sv](/blog/images/2023/12/14/1i3iey5j2h5sv.png)

```mathematica
describe[%]
visualize[%]
```

The sculpture depicted in the image is a highly detailed and elaborate work, consisting of multiple organic and ornamental elements that evoke a sense of flora and possibly some abstract qualities. The sculpture appears to be symmetrical along a vertical axis. 

Starting from the bottom center, there's a vase-like structure with intricate patterns, including what appear to be diamond and triangular shapes, possibly symbolizing a container or base of the sculpture.

Rising up from this base are assorted elements that mimic natural flora, with varying textures and patterns that are reminiscent of leaves, feathers, and possibly flower petals. The elements are arranged to create a sense of fullness and expansion outward from the central axis.

Key geometric and structural components include:

- S-curve tendrils: These spiral, curling shapes emerge from several points around the sculpture, reminiscent of fern fronds or vine tendrils with a consistent width and thickness, tapering into a spiral.

- Layered leaves or feathers: These elements are elongated, with a central spine and a series of parallel lines emanating from this spine to create the impression of veins in leaves or the vane of a feather. Different sections of these components are overlapped to create a sense of depth and volume.

- Fan-shaped motifs: Some elements resemble the fanned-out leaves or feathers, widening towards the outer edge and growing narrower towards the inner base. These display a sequential size gradient, either growing larger or smaller from the central axis.

- Spherical and clustered elements: Interspersed among the leaves and tendrils are spherical shapes, some appearing in clusters like berries or seeds. They provide a contrast in form to the more linear and extended parts of the sculpture.

- Textures and Patterns: Various elements have distinct textures, such as fine lines mimicking hatching that gives a sense of shadow and three-dimensionality, overlaid with a pattern that perhaps could emulate filigree or engraving.

The color palette seems limited to monochromatic hues that range from silvery gray to dark gray with bronze or gold accents, which may imply the use of metal or a metallic finish within these elements, enhancing their reflective and ornamental properties.

The intricate overlapping and interplay between these elements create a rich tapestry of forms and structures, providing ample detail for an observer or artist to capture the essence of this work through drawing or another medium.

![1ro3l2mr5o7hx](/blog/images/2023/12/14/1ro3l2mr5o7hx.png)

```mathematica
describe[%]
visualize[%]
```

This image depicts a highly detailed bas-relief sculpture with botanical and ornamental motifs, displayed in monochrome. The sculpture is symmetrical along the vertical axis. Here is a breakdown of its structural and geometric aspects:

Base:
- The sculpture is anchored on a square platform with a protruding beveled edge, featuring a pyramidal pattern.
- Above it sits a two-tiered base with the lower tier having an inverted frustum shape with diagonal etchings, and the top tier resembling a truncated pyramid with a zigzag pattern.

Pedestal:
- Rising from the base is a ribbed pedestal with a bulging midsection and ornate garlands draped around the widest part. A series of small concentric circles accents the top of the bulge.

Vase:
- The pedestal supports an urn-shaped vase with a wide, flaring opening.
- The vase has two primary sections: the lower has vertical fluting, and the upper is decorated with a leaf-and-dart pattern.
- A narrow band divides these sections, and another encircles the lip of the vase, both adorned with intricate motifs.

Composition:
- From the vase erupts an ornate arrangement resembling a grand bouquet consisting of various foliage and flower-like forms, bordered by large symmetrical leaves on either side.
- At the center, a series of elongated, spear-shaped leaves rise to the highest point, with a smooth sphere at the very top and in smaller, spherical forms scattered symmetrically throughout.
- Flanking these central leaves are shorter, feather-like fronds, curling scrolls, and flowers with detailed petals.

Detailing:
- A multitude of floral and botanical elements are represented, including sunburst flowers, daisies with tubular petals, and spherical blossoms with radiating spines.
- Several globe-like forms are embellished with different patterns such as stripes, dots, and star-like impressions.
- Additionally, there are smaller leafy elements with either smooth, veined surfaces or more stylized, curling designs.

The bas-relief exhibits a mixture of realism and stylization, with attention to light and shadow to give depth to the various textures and contours. The overall effect is one of lush abundance and exquisite craftsmanship, designed to catch the eye and project opulence and natural beauty.

![1jvzrdfj9ke92](/blog/images/2023/12/14/1jvzrdfj9ke92.png)

```mathematica
describe[%]
visualize[%]
```

You are looking at an elaborate sculpture that depicts a classical urn overflowing with an abundance of vegetation, primarily acanthus leaves and fruits. The artwork is very symmetric and highly detailed, following the aesthetic traditions of neoclassical or baroque ornamentation. Here's a thorough structural and geometric description:

1. Base: The sculpture rests on a structured, multi-tiered base. Starting from the bottom:
   - The lowest tier is a simple rectangular plinth with a subtle bevel.
   - The second tier features a molded design with repeated oval and circular motifs.
   - The third tier has a wider band with a densely patterned relief resembling foliage or small abstract motifs.

2. The Urn:
   - The urn sits above the base and is designed with a bulbous, elongated body that tapers into a narrower bottom. The top widens into a scalloped edge, reminiscent of the opening of a flower.
   - The urn's surface is adorned with layered, vertical fluting, adding texture and depth to its appearance.
   - The rim of the urn is decorated with a detailed, embossed frieze featuring intricate leaf-like patterns and circular rosettes.

3. The Overflowing Contents:
   - The central feature of this sculpture is the lavish arrangement of acanthus leaves emanating from the urn's opening. These leaves are large, intricately veined, and curl at their tips with a high degree of realism.
   - Interspersed among the acanthus leaves are clusters of fruits. These spherical elements are of various sizes, suggesting grapes, pomegranates, and perhaps figs or other fruit. The texture and volume of these fruits create an interesting interplay of light and shadow.

4. The Supporting Elements:
   - Flanking the urn on both sides are additional vegetal motifs that are nearly symmetrical. At the base of these, just above the top tier of the base, are two large, curling acanthus leaves that mirror each other.
   - Above these are elaborately rendered bundles of leaves and fruits that produce a sense of abundance and decadence. These clusters are complex, with each individual element carefully sculpted to mimic natural forms.

5. The Background:
   - Behind the overflowing contents, there is a flat, decorative back panel that seems to mimic a tapestry or wall. It has a border with a geometrical pattern, adding to the feeling of depth by providing contrast against the profusion of the foreground elements.

When redrawing this sculpture, it is important to account for the symmetry, repetition of motifs, organic shapes of leaves and fruits, as well as the structural hierarchy from the stable base up to the vibrant, dynamic overflow. Emphasizing the texture through shading and attention to detail in the varying elements will be important to capture the three-dimensional quality and the baroque sense of movement and lushness.

![00dvsaroctcoq](/blog/images/2023/12/14/00dvsaroctcoq.png)

**Comment:**  Interesting how it has collapsed into a baroque bas relieve sculpture over time...

```mathematica
ToJekyll["Computational Sculpture: After Damon Hamm, part 1", 
  "sculpture art llm"]
```
