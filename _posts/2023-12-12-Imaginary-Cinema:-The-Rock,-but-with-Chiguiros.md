---
Title: "Imaginary Cinema: The Rock, but with Chiguiros"
Date: 2023-12-12
Tags: imaginary-cinema art chiguiro llm chatgpt
---

**Premise:**  Remake [The Rock](https://en.wikipedia.org/wiki/The_Rock_(film)), but with all the characters played by [chiguiros](https://en.wikipedia.org/wiki/Capybara)...

That's all. Think about it.

```mathematica
ServiceExecute["OpenAI", "ImageCreate", 
   {"Prompt" -> "A scene from the movie \"The Rock\" but with a capybara as the character.  Depict Alcatraz in the background", 
   "Model" -> "dall-e-3"}]
```

![0zv64l06kze9b](/blog/images/2023/12/12/0zv64l06kze9b.png)

```mathematica
description = LLMSynthesize[
   "Describe some of the most visually compelling scenes in the movie \"The Rock\" with Sean Connery and Nicholas Cage.  Describe the visual aspects and what the characters look like, without their names. Make each description a separate string in a JSON list", 
    LLMEvaluator -> <|"Model" -> "gpt-4"|>];
```

```mathematica
descriptionText = First /@ Values @ ImportString[#, "RawJSON"]& @ Transliterate[description];
```

```mathematica
withChiguiros[description_String] := With[
   {prompt = "Depict all of the characters as capybaras having the physical descriptions in the text.  Create these in a photorealistic cinematic style, as if in a movie. The scene is: " <> description}, 
   ServiceExecute["OpenAI", "ImageCreate", 
      {"Prompt" -> prompt, "Model" -> "dall-e-3"}]]
```

```mathematica
result = AssociationMap[ withChiguiros, descriptionText]
```

![12wkyfrow00bn](/blog/images/2023/12/12/12wkyfrow00bn.png)

```mathematica
ToJekyll["Imaginary Cinema: The Rock, but with Chiguiros", "imaginary-cinema art chiguiro"]
```
