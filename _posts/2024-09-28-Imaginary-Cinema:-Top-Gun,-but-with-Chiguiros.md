---
title: "Imaginary Cinema: Top Gun, but with Chiguiros"
date: 2024-09-28
tags: imaginary-cinema art chiguiro gpt4 dall-e-3
---

**Premise:**  Remake [Top Gun](https://en.wikipedia.org/wiki/Top_Gun), but with [chiguiros](https://en.wikipedia.org/wiki/Capybara)...

That's all.  Think about it. (Stimulated by a discussion about chiguiros in[ jumpsuits](https://www.madepants.com/products/mens-slim-fit-zip-jumpsuit).)  

```mathematica
chat = ChatObject[
     LLMEvaluator -> <|"Model" -> "gpt-4o-2024-08-06", "Temperature" -> 1|>]; 
 
chat //= ChatEvaluate[
  "You are a film director describing a storyboard. Describe the 10 most visually compelling scenes in the movie \"Top Gun\".  Provide a detailed visual description of the scene and the appearance of the characters, but do not include any actor names. Make each description a separate string in a Wolfram language list."]
```

![16s47bxl875q3](/blog/images/2024/9/28/16s47bxl875q3.png)

```mathematica
chat //= ChatEvaluate[
  "Rewrite each of the scene descriptions replacing the human characters with capybaras. Describe how the capybaras' costumes and styling in detail, preserving as much similarity to the human characters as possible.  Return the results as a Wolfram language list."]
```

![1kb1rrqe5plx5](/blog/images/2024/9/28/1ettgf04a1wfw.png)

```mathematica
markdownToList[md_String] := ToExpression@ StringReplace[StartOfString ~~ "```wolfram\n" ~~ Longest[x___] ~~ "\n```" ~~ EndOfString :> x]@md 
  
 
image[description_] := With[
    {prompt = "The image should be styled like a 1980s Hollywood blockbuster film. The description is: " <> description}, 
    ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> prompt, "Model" -> "dall-e-3"}]] 
  
 
With[
  {descriptions = markdownToList@ chat["Messages"][[-1, "Content", 1, "Data"]]}, 
  AssociationMap[image, descriptions]]

```

![14g0meeygbahj](/blog/images/2024/9/28/14g0meeygbahj.png)

```mathematica
ToJekyll["Imaginary Cinema: Top Gun, but with Chiguiros", "imaginary-cinema art chiguiro gpt4 dall-e-3"]
```
