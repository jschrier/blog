---
Title: "Imaginary Cinema: Titanic, but with Manatees"
Date: 2023-12-26
Tags: imaginary-cinema art manatees llm
---

**Premise:**  Remake [Titanic](https://en.wikipedia.org/wiki/Titanic_(1997_film)) but with all the characters played by [manatees](https://en.wikipedia.org/wiki/Manatee)...

That's it. Think about it. (See also: [The Titanic, but with Chiguiros]({{ site.baseurl }}{% post_url 2023-03-04-Imaginary-Cinema:-Titanic-but-with-Chiguiros %}))

```mathematica
description = LLMSynthesize["Describe 10 of the most visually compelling scenes in the movie \"Titanic\" with Leonardo DiCaprio.  Describe the visual aspects of the background and the characters look like, without their names, using descriptive language. Make each description a separate string in a JSON list", 
     LLMEvaluator -> <|"Model" -> "gpt-4"|>]; 
 
descriptionText = First /@ Values@ImportString[#, "RawJSON"] &@Transliterate[description]; 
 
withManatees[description_String] := With[
     {prompt = "Depict all of the characters as manatees having the physical descriptions in the text.  Create these in a photorealistic cinematic style, as if in a movie. The scene is: " <> description}, 
     ServiceExecute["OpenAI", "ImageCreate", 
      {"Prompt" -> prompt, "Model" -> "dall-e-3"}]]; 
 
result = AssociationMap[ withManatees, descriptionText]
```

![0w5kuzxrpb2s8](/blog/images/2023/12/26/0w5kuzxrpb2s8.png)

## Part II:  The Drawing Room Sketch Scene

Inspired by the previous work, [Crayonfou](http://crayonfou.com) helped describe one other scene that was missing in the above, but is equally iconic. Here, we explored some basic prompt engineering to improve the designs.  Some take-home lessons included:

- Some additional descriptions were confusing

- Forcing manatees to have blond hair or wear suspenders seemed to revert the characters to humans instead of manatees.

- Occasional service outages due to content issues.  Unclear whether this is just the preview service giving errors on Boxing Day holiday or something else. Trying exactly the same prompt again would result in images being generated.

Some of our best work below, with prompt details following:

![0rdqxgfi992zg](/blog/images/2023/12/26/0rdqxgfi992zg.png)

![0l3cx87c3ghs7](/blog/images/2023/12/26/0l3cx87c3ghs7.png)

![1xu2ymjha7ph5](/blog/images/2023/12/26/1xu2ymjha7ph5.png)

![1dzmtrx9g8d3h](/blog/images/2023/12/26/1dzmtrx9g8d3h.png)

![07l7iu9xgbi4k](/blog/images/2023/12/26/07l7iu9xgbi4k.png)

![03vmvv8ju1db3](/blog/images/2023/12/26/03vmvv8ju1db3.png)

![00y752fbqs1s4](/blog/images/2023/12/26/00y752fbqs1s4.png)

**Computational explorations/notebook:**

We started maximally, and it was too much:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "In the background: a female nude manatee is reclining, wearing only a giant blue diamond necklace around her neck. She is reclining on an ornate 18th century sofa with red cushions.  In the foreground: is a male manatee artist with blong hair who is holding a charcoal stick drawing the female manatee on an easel.", 
   "Model" -> "dall-e-3"}]
```

![0zvef0tw4ph17](/blog/images/2023/12/26/0zvef0tw4ph17.png)

![1r0zgt6prabh5](/blog/images/2023/12/26/1r0zgt6prabh5.png)

So, instead we decided to start minimally and build things up:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "In the background is a manateee reclining in an odalisque pose and wearing a blue diamond necklace around her neck.", 
   "Model" -> "dall-e-3"}]
```

![1ooebsye8mn8z](/blog/images/2023/12/26/1ooebsye8mn8z.png)

![0w66cpqsoq018](/blog/images/2023/12/26/0w66cpqsoq018.png)

Happy with those results, we then try to add the drawing in the foreground:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "In the background is a manateee reclining in an odalisque pose and wearing a blue diamond necklace around her, but no other jewelry. The manatee reclines on a ornate red sofa.  In the foreground is a manatee who is drawing her.", 
   "Model" -> "dall-e-3"}]
```

![16yx6985gxiq3](/blog/images/2023/12/26/16yx6985gxiq3.png)

![1ez0e0sc1yetv](/blog/images/2023/12/26/1ez0e0sc1yetv.png)

Some fiddling with the prompt to specify explicitly that something is being drawn:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "In the background is a manateee reclining in an odalisque pose and wearing a blue diamond necklace around her, but no other jewelry. The manatee reclines on a ornate red sofa.  In the foreground is another manatee who is making a charcoal sketch of the reclining manatee.", 
   "Model" -> "dall-e-3"}]
```

![0l5rup2qi3e9g](/blog/images/2023/12/26/0l5rup2qi3e9g.png)

![1jjzh5kzr0op4](/blog/images/2023/12/26/1jjzh5kzr0op4.png)

We tried to add hair, but it reverted the Leonardo diMantina back to a human:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "In the background is a manateee reclining in an odalisque pose and wearing a blue diamond necklace around her neck, but no other jewelry. The manatee reclines on a ornate red sofa.  In the foreground is another manatee with blond hair, who is making a charcoal sketch of the reclining manatee.", 
   "Model" -> "dall-e-3"}]
```

![1qpcqvn5rh8ob](/blog/images/2023/12/26/1qpcqvn5rh8ob.png)

![1mtawg8gpbf9v](/blog/images/2023/12/26/1mtawg8gpbf9v.png)

Maybe it is the hair?  Trying clothing instead also reverted him back to a human:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "In the background is a manateee reclining in an odalisque pose and wearing a blue diamond necklace around her neck, but no other jewelry. The manatee reclines on a ornate red sofa.  In the foreground is another manatee with hair and wearing suspenders, who is making a charcoal sketch of the reclining manatee.", 
   "Model" -> "dall-e-3"}]
```

![1g5surjrbcql3](/blog/images/2023/12/26/1g5surjrbcql3.png)

![0yp2f2pij11l0](/blog/images/2023/12/26/0yp2f2pij11l0.png)

We also realized that the necklace was not placed correctly because we made a grammar mistake, so we try to force it back *around* her neck: 

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "In the background is a manateee reclining in an odalisque pose and wearing a blue diamond necklace around her neck, but no other jewelry. The manatee reclines on a ornate red sofa.  In the foreground is another manatee who is making a charcoal sketch of the reclining manatee.", 
   "Model" -> "dall-e-3"}]
```

![1h8h1vrxgsmtf](/blog/images/2023/12/26/1h8h1vrxgsmtf.png)

![1qdfu6chxle14](/blog/images/2023/12/26/1qdfu6chxle14.png)

This seemed to work, we spin the dice to generate another one:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
  {"Prompt" -> "In the background is a manateee reclining in an odalisque pose and wearing a blue diamond necklace around her neck, but no other jewelry. The manatee reclines on a ornate red sofa.  In the foreground is another manatee who is making a charcoal sketch of the reclining manatee.", 
   "Model" -> "dall-e-3"}]
```

![15a3satdk4e8w](/blog/images/2023/12/26/15a3satdk4e8w.png)

![13zmm3dp7ddxi](/blog/images/2023/12/26/13zmm3dp7ddxi.png)

Looking good! So now we generate 10 of them in parallel:

```mathematica
outputs = ParallelTable[
   ServiceExecute["OpenAI", "ImageCreate", 
    {"Prompt" -> "In the background is a manateee reclining in an odalisque pose and wearing a blue diamond necklace around her neck, but no other jewelry. The manatee reclines on a ornate red sofa.  In the foreground is another manatee who is making a charcoal sketch of the reclining manatee.", 
     "Model" -> "dall-e-3"}], 
   {10}]
```

![0tjsgb9b3srl7](/blog/images/2023/12/26/0tjsgb9b3srl7.png)

![0zwsav9hbjfxr](/blog/images/2023/12/26/0zwsav9hbjfxr.png)

```mathematica
ToJekyll["Imaginary Cinema: Titanic, but with Manatees", "imaginary-cinema art manatees llm"]
```
