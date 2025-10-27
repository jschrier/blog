---
title: "How to compute RDKit molecular features in Mathematica"
date: 2025-10-16
tags: chemistry cheminformatics mathematica
---

**How to compute** **[RDKit molecular features](https://www.rdkit.org/docs/GettingStartedInPython.html#descriptor-calculation)** **in Mathematica...**

First, initialize your code by creating an [external python evaluation session](http://reference.wolfram.com/language/ref/StartExternalSession.html) which sets up a temporary virtual environment for RDKit (and associated dependencies), and then begin by importing the relevant RDKit libraries:

```mathematica
session = ResourceFunction["StartPythonSession"][{"rdkit"}]
ExternalEvaluate[session, "from rdkit.Chem import MolFromSmiles, Descriptors"]
```

![12ss2xaemp3q8](/blog/images/2025/10/16/12ss2xaemp3q8.png)

Second, define a function (`features`) which will run in that session:

```mathematica
features = ExternalFunction[session, 
   "def features(smiles):
      m = MolFromSmiles(smiles)
      vals = Descriptors.CalcMolDescriptors(m)
      return vals"]
```

![0lat68wk70a34](/blog/images/2025/10/16/0lat68wk70a34.png)

You may now use the defined [ExternalFunction](http://reference.wolfram.com/language/ref/ExternalFunction.html) like any other Mathematica function:

```mathematica
features["CCN(CC)C(=O)[C@H]1CN([C@@H]2CC3=CNC4=CC=CC(=C34)C2=C1)C"]
```

![0ic5gwwh3h1x5](/blog/images/2025/10/16/0ic5gwwh3h1x5.png)

Be a good citizen and clean up your session when you are finished:

```mathematica
DeleteObject[session]
```
# Parerga and Paralipomena

- "Under the hood", Mathematica actually uses RDKit to compute many of the various [MoleculeValue](http://reference.wolfram.com/language/ref/MoleculeValue.html) properties; however these do not include all of the descriptors, nor do the names match.
- If your goal is to compute binary fingerprint vectors, it is more elegant to use the [MoleculeFingerprints paclet](https://resources.wolframcloud.com/PacletRepository/search/?i=WolframChemistry/MoleculeFingerprints) instead


```mathematica
ToJekyll["How to compute RDKit molecular features in Mathematica", "chemistry cheminformatics mathematica"]
```
