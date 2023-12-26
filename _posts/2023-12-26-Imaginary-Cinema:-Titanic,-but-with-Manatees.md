---
Title: "Imaginary Cinema: Titanic, but with Manatees"
Date: 2023-12-26
Tags: imaginary-cinema art manatee llm
---

**Premise:**  Remake [Titanic](https://en.wikipedia.org/wiki/Titanic_(1997_film)) but with all the characters played by [manatees](https://en.wikipedia.org/wiki/Manatee)...

That's it. Think about it. (See also: [The Titanic, but with Chiguiros]({{ site.baseurl }}{% post_url 2023-03-04-Imaginary-Cinema:-Titanic-but-with-Chiguiros %}))

```mathematica
description = LLMSynthesize[
     "Describe 10 of the most visually compelling scenes in the movie \"Titanic\" with Leonardo DiCaprio.  Describe the visual aspects of the background and the characters look like, without their names, using descriptive language. Make each description a separate string in a JSON list", 
     LLMEvaluator -> <|"Model" -> "gpt-4"|>]; 
 
descriptionText = First /@ Values @ ImportString[#, "RawJSON"]& @ Transliterate[description]; 
 
withManatees[description_String] := With[
     {prompt = "Depict all of the characters as manatees having the physical descriptions in the text.  Create these in a photorealistic cinematic style, as if in a movie. The scene is: " <> description}, 
     ServiceExecute["OpenAI", "ImageCreate", 
      {"Prompt" -> prompt, "Model" -> "dall-e-3"}]]; 
 
result = AssociationMap[ withManatees, descriptionText]
```

![0w5kuzxrpb2s8](/blog/images/2023/12/26/0w5kuzxrpb2s8.png)

```mathematica
ToJekyll["Imaginary Cinema: Titanic, but with Manatees", "imaginary-cinema art manatees llm"]
```
