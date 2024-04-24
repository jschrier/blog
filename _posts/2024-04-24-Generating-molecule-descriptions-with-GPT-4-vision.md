---
title: "Generating molecule descriptions with GPT-4-vision"
date: 2024-04-24
tags: gpt4v llm chemistry cheminformatics
---

I have had a few conversations in the past week about how one might build RAG-for-molecules to chat with molecular datasets.  An idea that I find appealing is to have a text representation of the molecule, motivated by [a paper in which Robocrystallographer was used to generate a text description of solids as an input for LLM use](http://arxiv.org/abs/2310.14029).   If you could generate text descriptions of molecules, perhaps this would serve as an alternative to [SMILES as inputs to LLMs](https://www.nature.com/articles/s42256-023-00788-1), which might help handle the [problems that LLM-based molecule property regressors have with handling 3d structure](https://arxiv.org/abs/2403.05075). There is a [Familiena"hnlichkeit](https://en.wikipedia.org/wiki/Family_resemblance) with the problem of [molecule captioning](http://arxiv.org/abs/2306.06615), but that is typically presented in terms of properties, whereas here we want just a structural description.  **Here we try to see what gpt-4-vision can do for generating text descriptions from molecular images...**

Start by defining an example.  [Who cares what games we choose? Little to win, but nothing to lose.](https://en.wikipedia.org/wiki/Incense_and_Peppermints)..so pick something whimsical:   

```mathematica
lsd = Molecule["CCN(CC)C(=O)[C@H]1CN([C@@H]2Cc3c[nH]c4c3c(ccc4)C2=C1)C"];
picture2d = MoleculePlot[lsd]
picture3d = MoleculePlot3D[lsd]
```

![0k7z7mf4ng5q7](/blog/images/2024/4/24/0k7z7mf4ng5q7.png)

![0g35gsr0oakwr](/blog/images/2024/4/24/0g35gsr0oakwr.png)

```mathematica
Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/Misc/LLMVision.m"];

```

![16jirb0w6epoa](/blog/images/2024/4/24/16jirb0w6epoa.png)

Apparently GPT-4 knows that this might be a drug, and blocks the result:

```mathematica
TextCell@
  LLMVisionSynthesize["You are an expert organic chemist. Describe the molecule in this image:", 
   Image[picture2d], "MaxTokens" -> 4000]
```

![108jdaw4kdff9](/blog/images/2024/4/24/108jdaw4kdff9.png)

However if you ask about general properties you get some description but it is pretty vanilla: 

```mathematica
TextCell@
  LLMVisionSynthesize["You are an expert organic chemist. Describe the structural properties of the molecule in this image and other aspects that would be useful in describining its bonding and properties:", 
   Image[picture2d], "MaxTokens" -> 4000]
```

![0n2s5d9fzz7c9](/blog/images/2024/4/24/0n2s5d9fzz7c9.png)

Let's try another one: 

```mathematica
TextCell@
  LLMVisionSynthesize["You are an expert organic chemist. Describe the 2d and 3d structural properties of the molecule in this image, which might be useful to compare or contrast it to other molecules:", 
   Image[picture2d], "MaxTokens" -> 4000]
```

![0d0afgxnfgd89](/blog/images/2024/4/24/0d0afgxnfgd89.png)

What happens if we provide the 3d structure as input? Admittedly, this is not a great example because the molecule is pretty planar:

```mathematica
TextCell@
  LLMVisionSynthesize["You are an expert organic chemist. Describe the structural properties of the molecule in this image, in particular its three dimensional geometric properties: ", 
   Image[picture3d], "MaxTokens" -> 4000]
```

![1ivz5llks99b8](/blog/images/2024/4/24/1ivz5llks99b8.png)

Another trial (umm...this is not caffeine...):

```mathematica
TextCell@
  LLMVisionSynthesize["You are an expert organic chemist. Describe the 2d and 3d structural properties of the molecule in this image, which might be useful to compare or contrast it to other molecules:", 
   Image[picture3d], "MaxTokens" -> 4000]
```

![0imwh76fbg50u](/blog/images/2024/4/24/0imwh76fbg50u.png)

```mathematica
TextCell@
  LLMVisionSynthesize["You are an expert organic chemist. Describe the 3d structural properties of the molecule in this image, especially those which may not be evident simply based on the functional groups that are present or 2d connectivity.", 
   Image[picture3d], "MaxTokens" -> 4000]
```

![1r981d0bilcsp](/blog/images/2024/4/24/1r981d0bilcsp.png)

Enough beating around the bush, tell me about *this* molecule, not vague generalities.  (But no...it is still not caffeine...)

```mathematica
TextCell@
  LLMVisionSynthesize["You are an expert organic chemist. Describe the 3d structural properties of the molecule in this image, especially those which may not be evident simply based on the functional groups that are present or 2d connectivity. Do not speak in generalities, but describe only specific attributes of the molecule in this image:", 
   Image[picture3d], "MaxTokens" -> 4000]
```

![045yhk1xswmo9](/blog/images/2024/4/24/045yhk1xswmo9.png)

**Conclusion:**  

- Yes, current gpt-4-vision can take molecule images and say something about them.

- Descriptions tend to focus on functional groups and connectivities; presumably this would be information that could be learned from SMILES strings as input

- Higher order 3d structural descriptions tend to be vague.

- Problem of hallucinating molecule identities may hinder RAG applications.

```mathematica
ToJekyll["Generating molecule descriptions with GPT-4-vision", "gpt4v llm chemistry cheminformatics"]
```
