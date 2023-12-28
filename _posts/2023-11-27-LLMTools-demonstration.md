---
Title: "LLMTools demonstration"
Date: 2023-11-27
Tags: llm ai ml science chemistry cheminformatics
---

Large-language models (LLMs) struggle with precise calculations needed for chemistry-related tasks.  In a recent paper, [Bran et al. described ChemCrow](https://arxiv.org/abs/2304.05376)--a series of computational [tools](https://platform.openai.com/docs/assistants/tools) that can be used by the LLM to perform intermediate calculations. **Here we show how to implement a few ChemCrow-style tools from scratch and use it to get GPT-3.5/4 to correctly compute SMILES and molecular weight information given an input chemical name...** 

We begin by defining an example case and the correct answer so we can check our own work:

```mathematica
knownAnswer = Molecule["2-pyridyl(3-pyridyl) dithiophosphinic acid"]
knownAnswer["CanonicalSMILES"]
knownAnswer["MolarMass"]
```

![1l78nhmeikxbz](/blog/images/2023/11/27/1l78nhmeikxbz.png)

```
(*"S=P(S)(c1cccnc1)c1ccccn1"*)
```

![1fv36zbei9v3e](/blog/images/2023/11/27/1fv36zbei9v3e.png)

Without providing the tool, the LLM is not capable of generating the correct [SMILES](https://chem.libretexts.org/Courses/Intercollegiate_Courses/Cheminformatics/02%3A_Representing_Small_Molecules_on_Computers/2.04%3A_Line_Notation) string (note that it can do it for relatively simple molecules, like 2-bromohexanoic acid, but fails in more complicated cases like the one selected here):

```mathematica
LLMSynthesize["What is the SMILES string of 2-pyridyl(3-pyridyl) dithiophosphinic acid?"]

(*"The SMILES string for 2-pyridyl(3-pyridyl) dithiophosphinic acid is as follows:C1=CC=NC=C1. P(=S)(SC2=CC=NC=C2)SC3=CC=NC=C3"*)
```

(this is clearly wrong--notice the disconnection)

We can solve this by writing an [LLMTool](http://reference.wolfram.com/language/ref/LLMTool.html); most of the definition is just a description of the tool; the actual function is just a one-liner:

```mathematica
(*define the tool*)
  name2SMILES = LLMTool[
     {"name2SMILES", (*tool name and descriptions*)
      "converts a given chemical name into the corresponding SMILES representation"}, 
     "name", (*input parameter*)
     Molecule[#name]["CanonicalSMILES"] & (*function to evaluate*) 
    ] 
   
  (*use the tool*) 
   LLMSynthesize["What is the SMILES string of 2-pyridyl(3-pyridyl) dithiophosphinic acid?", 
    LLMEvaluator -> <|"Tools" -> name2SMILES|>]
```

![15wqqj7gg2agh](/blog/images/2023/11/27/15wqqj7gg2agh.png)

```
(*"The SMILES string for 2-pyridyl(3-pyridyl) dithiophosphinic acid is \"S=P(S)(c1cccnc1)c1ccccn1\"."*)
```

Tools can also be chained together.  For example, we might want our agent to first compute the SMILES string and then use that to compute the molecular weight of a molecule (these are two of the other  tools described in the [ChemCrow paper](https://arxiv.org/abs/2304.05376)...it is straightforward to implement them):

```mathematica
name2CAS = LLMTool[
    {"nameToCAS", 
     "looks up the Chemical Abstracts Service (CAS) number of a given molecule"}, 
    "name", 
    With[
      {searchResults = 
        ResourceFunction["CommonChemistrySearch"][#name, MaxItems -> 1]}, 
      searchResults[1, "CASRegistryNumber"]["ExternalID"]] & 
   ] 
 
smiles2Weight = LLMTool[
   {"SMILES2Weight", 
    "calculate the molecular weight of a molecule given a SMILES representation of that molecule"}, 
   "smiles", 
   QuantityMagnitude@MoleculeProperty["MolarMass"]@Molecule[#smiles] & 
  ]
```

![0af19xucreg3u](/blog/images/2023/11/27/0af19xucreg3u.png)

![19vtni952m9ss](/blog/images/2023/11/27/19vtni952m9ss.png)

Without the tools available, the results are very poor; here are three examples:

```mathematica
LLMSynthesize["What is the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid?"]

(*"The molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid can be calculated by adding the atomic weights of all the atoms in the molecule. 2-pyridyl(3-pyridyl) dithiophosphinic acid:- 2 pyridyl groups (C5H4N): (5 x 12.01) + (4 x 1.01) + 14.01 = 79.10 g/mol- 1 dithiophosphinic acid group (C5H6NO2PS2): (5 x 12.01) + (6 x 1.01) + 14.01 + 16.00 + 32.06 + (2 x 32.06) = 222.36 g/mol Adding these together, the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid is approximately 301.46 g/mol."*)
```

```mathematica
LLMSynthesize["What is the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid?"]

(*"The molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid is 277.26 g/mol."*)
```

```mathematica
LLMSynthesize["What is the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid? Think step by step."]

(*"To calculate the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid, we need to sum the atomic masses of all the atoms in the molecule. Here are the steps to determine the molecular weight:1. Determine the chemical formula of the compound:The formula is given as \"2-pyridyl(3-pyridyl) dithiophosphinic acid.\" From this name, we can determine the components:- 2-pyridyl: C5H4N (pyridine) multiplied by 2- 3-pyridyl: C5H4N (pyridine) multiplied by 3- Dithiophosphinic acid: H3PO2S22. Calculate the molecular weight of each component:- 2-pyridyl: C5H4N: (5 x 12.01 g/mol) + (4 x 1.008 g/mol) + (1 x 14.01 g/mol) = 79.10 g/mol- 3-pyridyl: C5H4N: (5 x 12.01 g/mol) + (4 x 1.008 g/mol) + (1 x 14.01 g/mol) = 79.10 g/mol- Dithiophosphinic acid: H3PO2S2: (1 x 1.008 g/mol) + (3 x 1.008 g/mol) + (1 x 15.99 g/mol) + (2 x 32.06 g/mol) + (2 x 14.01 g/mol) = 156.13 g/mol3. Add the molecular weights of all components:(2 x 79.10 g/mol) + (3 x 79.10 g/mol) + 156.13 g/mol = 553.63 g/molTherefore, the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid is approximately 553.63 g/mol."*)
```

Providing the tools solves the problem.  Note that we can provide an unnecessary CAS lookup tool and GPT will use the descriptions to determine the relevant tools to use:

```mathematica
LLMSynthesize[
  "What is the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid? Obtain the result by converting to SMILES and computing the weight using the provided tools", 
  LLMEvaluator -> <|"Tools" -> {name2SMILES, name2CAS, smiles2Weight}|>]

(*"The molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid is 252.29 g/mol."*)
```

```mathematica
LLMSynthesize[
  "Use the tools to compute the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid", 
  LLMEvaluator -> <|"Tools" -> {name2SMILES, name2CAS, smiles2Weight}|>]

(*"The molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid is approximately 252.29 g/mol."*)
```

```mathematica
LLMSynthesize[
  "What is the molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid", 
  LLMEvaluator -> <|"Tools" -> {name2SMILES, name2CAS, smiles2Weight}|>]

(*"The molecular weight of 2-pyridyl(3-pyridyl) dithiophosphinic acid is approximately 252.29 g/mol."*)
```

```mathematica
ToJekyll["LLMTools demonstration", "llm ai ml science chemistry cheminformatics"]

(*ToJekyll[]*)
```
