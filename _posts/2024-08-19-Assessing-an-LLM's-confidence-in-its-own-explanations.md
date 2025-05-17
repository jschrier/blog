---
title: "Assessing an LLM's confidence in its own explanations"
date: 2024-08-19
tags: llm science gpt4
---

**Background:**  We can ask an LLM to generate scientific explanations, but why should we believe them? (Case study here is for inorganic synthesizability predictions like those in [our recent JACS paper](https://pubs.acs.org/doi/abs/10.1021/jacs.4c05840), but strategy should be general).  Our goal here is to show a process by which we can dissect the reasons and try to determine the model's confidence. Empirically, [language models (mostly) know what they know](http://arxiv.org/abs/2207.05221), that is to say, pre-trained LLMs provide well-calibrated true/false self-evaluation on factual questions.  We will thus use a prompt chaining approach, in which we first use the LLM to extract an underlying rule for a statement, and then use the LLM to assess the veracity of that rule....

## Load Example

Begin by loading two example explanations that were previously generated as part of a separate workflow:

```mathematica
SetDirectory@ NotebookDirectory[];
examples = Import["./two_explanation_examples.json", "RawJSON"];
```

Before we start, take a look at the system, user, and agent response (explanation) for the first example:

```mathematica
system = Query[1, "Prompt", 1, "content"]@ examples
in1 = Query[1, "Prompt", 2, "content"]@ examples
ex1 = Query[1, "Explanation"]@ examples

(*"Return only output of the following format for each reason, and no other information: ### Reason 1. **[Keyword of reason]**[Detailed description] "*)

(*"Explain why an inorganic compound with the following structural information is synthesizable: 
ScIr3 is Uranium Silicide structured and crystallizes in the cubic Pm-3m space group. Sc(1) is bonded to twelve equivalent Ir(1) atoms to form a mixture of corner and face-sharing ScIr12 cuboctahedra. All Sc(1)-Ir(1) bond lengths are 2.78 Ao. Ir(1) is bonded in a distorted square co-planar geometry to four equivalent Sc(1) atoms."*)

(*
"### Reason 1. **Consistency in Crystal Structure**
The ScIr3 compound adopts a uranium silicide structure, which is a well-known, stable crystal structure model. The consistency of this compound with an established crystalline framework supports its plausibility and synthesizability.

### Reason 2. **Symmetry and Space Group**
The compound crystallizes in the cubic Pm-3m space group, a high-symmetry structure that is commonly seen in many stable materials. Cubic structures typically lend themselves to stability and thereby to easier synthesis.

### Reason 3. **Bond Lengths**
The uniform Sc(1)-Ir(1) bond lengths of 2.78  A indicate a regular and stable bonding environment. Uniform bond lengths generally correspond to lower internal strain in the crystal, suggesting a synthesizable compound.

### Reason 4. **Coordination Geometry**
Sc(1) atoms are bonded to twelve equivalent Ir(1) atoms to form a coordination polyhedron (cuboctahedron), which is a typically stable and energetically favorable configuration in metal alloys and intermetallic compounds. The distorted square co-planar geometry of Ir(1) atoms further suggests a stable interaction conducive to the synthesis."*)
```

## Examine the claims  

We can programmatically split the reasons:

```mathematica
(* define a function to split the explanations into the specific claims/reasons *)

splitClaims[text_] := StringTrim /@ StringSplit[text, StartOfLine ~~ "### Reason " ~~ Shortest[__] ~~ EndOfLine] 
   
  (* demo *) 
   claims1 = splitClaims@ex1

(*{"The ScIr3 compound adopts a uranium silicide structure, which is a well-known, stable crystal structure model. The consistency of this compound with an established crystalline framework supports its plausibility and synthesizability.", 
"The compound crystallizes in the cubic Pm-3m space group, a high-symmetry structure that is commonly seen in many stable materials. Cubic structures typically lend themselves to stability and thereby to easier synthesis.", 
"The uniform Sc(1)-Ir(1) bond lengths of 2.78 Ao indicate a regular and stable bonding environment. Uniform bond lengths generally correspond to lower internal strain in the crystal, suggesting a synthesizable compound.", 
"Sc(1) atoms are bonded to twelve equivalent Ir(1) atoms to form a coordination polyhedron (cuboctahedron), which is a typically stable and energetically favorable configuration in metal alloys and intermetallic compounds. The distorted square co-planar geometry of Ir(1) atoms further suggests a stable interaction conducive to the synthesis."}*)
```

**Observation:**  The "facts" provided in the response are taken directly from the ([Robocrystallographer](https://hackingmaterials.lbl.gov/robocrystallographer/index.html)-generated) input text, so a direct application of the [semantic entropy method ](https://jschrier.github.io/blog/2024/07/31/Detecting-LLM-confabulations-with-semantic-entropy.html)is not applicable (as it tests the "facts" that are generated in response to a question).

## Exploration:  What information do we have and how might we rephrase it?

All examples use the latest GPT-4o (2024-08-06) model:

```mathematica
LLMFunction["In one sentence, describe the underlying principle used by this explanation: ``"] /@ claims1 // TableForm
```

![1tu25th2eho7x](/blog/images/2024/8/19/1tu25th2eho7x.png)

```mathematica
LLMFunction["In one sentence, describe the underlying principle used by this explanation.  Do not use the phrase \"The underlying principle is\", but instead just state the principle in the form \"X indicates Y\": ``"] /@ claims1 // TableForm
```

![1kgtikmt65wpl](/blog/images/2024/8/19/1kgtikmt65wpl.png)

```mathematica
LLMFunction["In one sentence, describe an \"if-then\" rule based on the underlying principle used by this explanation, which could be applied to a new compound: ``"] /@ claims1 // TableForm
```

![1eo6jkpyyiddk](/blog/images/2024/8/19/1eo6jkpyyiddk.png)

One idea (not pursued) was to rewrite as questions, but the problem is that these tend to be too specific:

```mathematica
LLMFunction["Write a one-sentence true/false question based on the underlying principle used by this explanation, which could be applied to a new compound: ``"] /@ claims1 // TableForm
```

![1ghy3x6w68ega](/blog/images/2024/8/19/1ghy3x6w68ega.png)

## Using log-probs to assess the veracity of implied rules

**Background:** We independently rediscovered the self-evaluation pattern of [Kadavath et al.](http://arxiv.org/abs/2207.05221), in which the statement to be assessed is posed as true/false question for evaluation.  However, whereas they sample generations, we look directly at the log-probs, which is better.  Additionally, we break this up into two separate LLM calls (so-called *prompt chaining*) rather than put them into one call. The original reason for this was just practical (it was easier to do this in separate steps), and it better conforms to the idea of compositionality in functional programming (even if it costs a few more tokens).  But there is also some [empirical evidence that prompt chaining gives better results than asking the model to do both steps in one shot for GPT-4-and-below level models. ](https://arxiv.org/abs/2406.00507v1)
**
Method:**  For each rule extracted above, ask GPT-4o (with system prompt: `You are provided with a statement of unknown veracity. Return only True or False and nothing else depending on the veracity of the statement.*`) Then get log-probabilities of these responses and convert to probabilities. Apply this to each rule, store in a data structure for later use or storage.

**Implementation:**

First, set up the model and our function for extracting rules (copied from above):

```mathematica
(* general model choice settings *)
model = "gpt-4o-2024-08-06"; 
temperature = 1; 
config = LLMConfiguration[<|"Model" -> model, "Temperature" -> temperature|>]; 
   
(* LLM query to extract rules from an input explanation *) 
ruleExtraction = LLMFunction[
  "In one sentence, describe an \"if-then\" rule based on the underlying principle used by this explanation, which could be applied to a new compound: ``", 
  LLMEvaluator -> config, ProgressReporting -> None];
```

We are going to perform the evaluation in two steps. First we extract a list of rules:

```mathematica
(* example: extract rules from the first example *)
rules = ParallelMap[ruleExtraction, claims1]

(*{"If a new compound adopts a well-known and stable crystal structure model, then its plausibility and synthesizability are supported by its consistency with an established crystalline framework.", 
"If a new compound crystallizes in a high-symmetry cubic space group like Pm-3m, then it is likely to be stable and easier to synthesize.", 
"If a new compound exhibits uniform bond lengths, then it likely has low internal strain, indicating that the compound is stable and synthesizable.", 
"If a compound has a metal atom bonded to twelve equivalent metal atoms forming a cuboctahedral coordination polyhedron with additional distorted co-planar geometries, then the compound is likely to exhibit stability and energetic favorability in metal alloys and intermetallic compounds."}*)
```

Then we run the rule through gpt-4o, and [extract the logprobs response (we have to do this through RawChat)](https://mathematica.stackexchange.com/questions/301338/openai-serviceconnect-for-chat-completion-api-does-not-properly-implement-log); convert the log-probs to probabilities, and see what the model believes:

```mathematica
(* input: response from OpenAI API (as Association)
   output: dictionary of truth values and probabilities *)

extractProbability[chatResponse_Association] := With[
  {result = Query["choices", 1, "logprobs", "content", 1, "top_logprobs", All, {"token", "logprob"}]@chatResponse}, 
  Map[Exp]@ Apply[AssociationThread]@ Transpose@ Values@ result] 
   
(* input: a rule sentence string
   output: dictionary of response tokens (True/False) and their associated probability *) 
checkRule[rule_String] := With[
  {return = ServiceExecute["OpenAI", "RawChat", 
  {"messages" -> {
     <|"role" -> "system", "content" -> "You are provided with a statement of unknown veracity. Return only True or False and nothing else depending on the veracity of the statement."|>, 
    <|"role" -> "user", "content" -> rule|>}, 
  "logprobs" -> True, "top_logprobs" -> 2, 
   "model" -> model, 
   "temperature" -> 1}]}, 
  extractProbability@ return]
```

Apply this to our first example:

```mathematica
result1 = AssociationMap[checkRule, rules]

(*<|"If a new compound adopts a well-known and stable crystal structure model, then its plausibility and synthesizability are supported by its consistency with an established crystalline framework." -> <|"True" -> 0.999965, "False" -> 0.0000353563|>, 
"If a new compound crystallizes in a high-symmetry cubic space group like Pm-3m, then it is likely to be stable and easier to synthesize." -> <|"False" -> 0.95791, "True" -> 0.0420876|>, 
"If a new compound exhibits uniform bond lengths, then it likely has low internal strain, indicating that the compound is stable and synthesizable." -> <|"True" -> 0.817573, "False" -> 0.182425|>, 
"If a compound has a metal atom bonded to twelve equivalent metal atoms forming a cuboctahedral coordination polyhedron with additional distorted co-planar geometries, then the compound is likely to exhibit stability and energetic favorability in metal alloys and intermetallic compounds." -> <|"True" -> 0.989012, "False" -> 0.0109869|>|>*)
```

**Observation:**  This seems OK.  Interesting that the "uniform bond length" claim is the weakest supported.

### Example 2 (predicted non-synthesizable)

Now apply to the other example; before we start, what did the model originally provide as an explanation?

```mathematica
ex2 = Query[2, "Explanation"]@examples

(*"### Reason 1. **Atomic Size Mismatch**
The synthesis of CaAcIn2 might not be feasible due to significant differences in atomic sizes, leading to distortions in the crystal lattice. The detailed description indicates that Ca(1) and Ac(1) both form body-centered cubic geometries with equivalent In(1) atoms, but the bond length uniformity suggests potential strain in the lattice. 

### Reason 2. **Valence Electron Imbalance**
The inability to synthesize CaAcIn2 can be attributed to an imbalance in valence electrons. For Heusler structures, the total number of valence electrons typically follows specific rules to stabilize the electronic structure. The given compound may not satisfy these rules, resulting in electronic instabilities.

### Reason 3. **Incompatibility in Coordination Numbers**
The coordination environment described a body-centered cubic geometry for Ca and Ac each bonded to eight equivalent In atoms. There could be a geometric incompatibility in achieving this coordination number for all involved atoms simultaneously, ultimately preventing stable formation of the crystal structure.

### Reason 4. **Charge Distribution Imbalance**
The synthesis issue might be due to inappropriate charge distribution among Ca, Ac, and In. For stable Heusler compounds, the charge distribution and resulting oxidation states must complement each other to maintain charge neutrality and structural integrity. If the charged states deviate significantly, the compound might not form or be stable.

### Reason 5. **Lattice Energy Considerations**
The structural configuration may result in unfavorable lattice energies, making the compound thermodynamically unstable. The need to maintain consistent Ca(1)-In(1) and Ac(1)-In(1) bond lengths at 3.46 Ao could lead to lattice strain, increasing the overall energy of the system and preventing synthesis."*)
```

What are the rules and the model confidence in these rules? Use the functions defined above to obtain the answer

```mathematica
result2 = AssociationMap[checkRule]@Map[ruleExtraction]@splitClaims@ex2

(*<|"If a compound's constituent atoms exhibit significant differences in atomic sizes, then the synthesis of that compound might not be feasible due to resulting distortions and potential strain in the crystal lattice." -> <|"True" -> 0.979667, "False" -> 0.0203323|>, 
"If a new compound does not meet the specific valence electron count rules required for stabilizing the electronic structure in Heusler compounds, then it is likely to exhibit electronic instabilities, hindering its successful synthesis." -> <|"True" -> 0.999934, "False" -> 0.0000660521|>, 
"If a new compound's coordination environment requires all involved atoms to achieve a high coordination number simultaneously within a specific geometric arrangement, then geometric incompatibility may prevent stable formation of the crystal structure." -> <|"True" -> 1.,"False" -> 1.12535*10^-7|>, 
"If the charge distribution and resulting oxidation states of the elements in a new compound do not complement each other to maintain charge neutrality and structural integrity, then the compound may not form or be stable." -> <|"True" -> 1., "False" -> 1.12535*10^-7|>, 
"If a compound's structural configuration requires maintaining specific bond lengths that deviate from the preferred distance and causes lattice strain, then the compound may experience unfavorable lattice energies and be thermodynamically unstable, hindering its successful synthesis." -> <|"True" -> 0.999999, "False" -> 5.04347*10^-7|>|>*)
```

**Observation:**  All of these have a high confidence. 

## Exploration of counterfactual case

**Background:** By the classical logical [Principle of Non-Contradiction](https://plato.stanford.edu/ENTRIES/contradiction/), a statement and its negation cannot both be true. This allows us to generate an internal consistency test.  (We will ignore [dialethism](https://en.wikipedia.org/wiki/Dialetheism).)

**Method:**  Use the LLM to rewrite the extracted rules in the opposite sense, and then check the rules. 

```mathematica
rewrite = LLMFunction["Rewrite the following sentence so that it would become false: ``"];
```

**First example:** What do these rewritten rules look like?

```mathematica
opposite = rewrite /@ rules

(*{"If a new compound adopts a well-known and stable crystal structure model, then its plausibility and synthesizability are not supported by its consistency with an established crystalline framework.", 
"If a new compound crystallizes in a high-symmetry cubic space group like Pm-3m, then it is unlikely to be stable and harder to synthesize.", 
"If a new compound exhibits uniform bond lengths, then it likely has high internal strain, indicating that the compound is unstable and unsynthesizable.", 
"If a compound has a metal atom bonded to twelve equivalent metal atoms forming a cuboctahedral coordination polyhedron with additional distorted co-planar geometries, then the compound is unlikely to exhibit stability and energetic favorability in metal alloys and intermetallic compounds."}*)
```

What does the LLM think of these statements? 

```mathematica
AssociationMap[checkRule]@opposite

(*<|"If a new compound adopts a well-known and stable crystal structure model, then its plausibility and synthesizability are not supported by its consistency with an established crystalline framework." -> <|"False" -> 0.994088, "True" -> 0.00591106|>, 
"If a new compound crystallizes in a high-symmetry cubic space group like Pm-3m, then it is unlikely to be stable and harder to synthesize." -> <|"False" -> 0.999769, "True" -> 0.000230507|>, 
"If a new compound exhibits uniform bond lengths, then it likely has high internal strain, indicating that the compound is unstable and unsynthesizable." -> <|"False" -> 0.999995, "True" -> 4.78509*10^-6|>,
"If a compound has a metal atom bonded to twelve equivalent metal atoms forming a cuboctahedral coordination polyhedron with additional distorted co-planar geometries, then the compound is unlikely to exhibit stability and energetic favorability in metal alloys and intermetallic compounds." -> <|"False" -> 0.867032, "True" -> 0.132964|>|>*)
```

**Observation:**  Great!  It indeed appears that it correctly assesses these false statements as `False`

**Second example:**  What about the negative (U) example? 

```mathematica
AssociationMap[checkRule]@ Map[rewrite]@ Keys@ result2

(*<|"If a compound's constituent atoms exhibit significant differences in atomic sizes, then the synthesis of that compound is always feasible without any resulting distortions or potential strain in the crystal lattice." -> <|"False" -> 1., " False" -> 3.58175*10^-10|>, 
"If a new compound does not meet the specific valence electron count rules required for stabilizing the electronic structure in Heusler compounds, then it is unlikely to exhibit electronic instabilities, facilitating its successful synthesis." -> <|"False" -> 0.962671, "True" -> 0.0373268|>, 
"If a new compound's coordination environment requires all involved atoms to achieve a high coordination number simultaneously within a specific geometric arrangement, then geometric incompatibility will always ensure stable formation of the crystal structure." -> <|"False" -> 1., "True" -> 1.12535*10^-7|>, 
"If the charge distribution and resulting oxidation states of the elements in a new compound do not complement each other to maintain charge neutrality and structural integrity, then the compound will definitely form and be stable." -> <|"False" -> 1., " False" -> 1.6919*10^-10|>, 
"If a compound's structural configuration requires maintaining specific bond lengths that deviate from the preferred distance and causes lattice strain, then the compound will experience favorable lattice energies and be thermodynamically stable, facilitating its successful synthesis." -> <|"False" -> 1., " False" -> 2.17244*10^-10|>|>*)
```

**Observation:**  Again, the LLM appears to get this correct (by identifying these as false statements).  

Note the three edge case occurences where the two tokens returned are `False` and `\sFalse` and no `True` token gets returned.  This is logically OK, but we will want to consider this carefully when implementing at scale. 

## Ideas for future projects

- Is  a case study with a few examples sufficient? If so, we show these results (with code) and we are done (maybe apply to a few others or even all others?)

- Does it make sense to assess the model's confidence of the overall set of reasons?  Is the aggregate confidence the product of the probabilities associated with each rule (A-and-B-and-C-...)?  Or is it the lowest of the probabilities (weakest claim?) Or something else?  A further complication is that we have different numbers of claims/rules/reasons for each example.

- Could we extract all of the rules and say something about them? (This would require some type of semantic grouping which we would have to figure out.)

- Do synthesizability predictions we get wrong (false negative, should be P) have lower probability reasons?  If that is supported, then we could hypothesize the other direction too (that our false positive-like cases should be actual positives)

```mathematica
ToJekyll["Assessing an LLM's confidence in its own explanations", "llm science gpt4"]
```

# Addendum

- We put this to work at scale in a the (open-access) paper S. Kim, J. Schrier, Y. Jung, Explainable Synthesizability Prediction of Inorganic Crystal Polymorphs Using Large Language Models *Angew. Chemie Int. Ed.* 2025; [doi:10.1002/anie.202423950](https://dx.doi.org/10.1002/anie.202423950). Seungmin also wrote a [python implementation of this workflow](https://github.com/snu-micc/StructLLM/), if you swing that way. 
