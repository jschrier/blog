---
title: "Detecting LLM confabulations with semantic entropy"
date: 2024-07-31
tags: llm gpt4 ml mathematica nyc science
---

Farquhar et al. recently described a method for *[Detecting hallucinations in large language models using semantic entropy ](https://doi.org/10.1038/s41586-024-07421-0)*[(Nature 2014)](
https://doi.org/10.1038/s41586-024-07421-0). The core idea is to use an LLM to cluster statements depending together if they have a bidirectional entailment (*A entails B* and *B entails A* must both be true).  If the answers form only one cluster, then there is very little entropy and the LLM is confident; if there are many clusters each with a few examples, then the entropy is high and the LLM likely to be [confabulating](https://en.wikipedia.org/wiki/Hallucination_(artificial_intelligence)).  **Let's write a minimal implementation from scratch with worked examples...**

The paper describes two general procedures: a version for short question/answer statements, and a version for paragraph length topics.  (We shall implement both.) The paper also describes two calculation types: the main one uses the returned statement [logits](https://en.wikipedia.org/wiki/Log_probability) to perform the calculation, and a *discrete* version in which you just count the response. We will implement the discrete version, as it is easier to understand the calculation, avoids [the need to manually write API requests to pull the OpenAI logits](https://mathematica.stackexchange.com/questions/301338/openai-serviceconnect-for-chat-completion-api-does-not-properly-implement-log), and as the authors say it gives similar performance empirically. So why work harder than we have to? 

## Basic setup

We will implement this using [gpt-4o](https://openai.com/index/hello-gpt-4o/) for generation and entailment checking; otherwise we will follow the paper using *T*=1 and *M=10* generation samples  (line 2144 in the SI) 

Before we get started, define the model and temperature for generation, entailment checking, etc. throughout:

```mathematica
config = LLMConfiguration[<|"Model" -> "gpt-4o-2024-05-13", "Temperature" -> 1|>] ;
```

## Detecting Confabulations in QA questions

The version is assesses confabulations of short, single sentence answers to a question.  The core process is:

1. Generate *M=10* sample answers to a question

1. Cluster them using bidirectional entailment

1. Compute the entropy of the clusters

We will implement each of these steps in turn.

### 1. Generation of sample output sequences

The prompting template is described in **Methods: Prompting templates:**

```mathematica
qaPrompt = LLMFunction[
    "Answer the following question in a single brief but complete sentence.
    Question: `1`
    Answer: ", 
    LLMEvaluator -> config];
```

To see how it works, let's ask a contentious question about [Arthur Avenue in da Bronx](https://en.wikipedia.org/wiki/Arthur_Avenue): 

```mathematica
(*demo*)
  question = "Who makes the best pizza on Arthur Avenue?"; 
   answers = ParallelTable[ qaPrompt[question], {10}]

(*
{"The best pizza on Arthur Avenue is widely considered to be from Full Moon Pizzeria.", 
"The best pizza on Arthur Avenue is often said to be from Mario's Restaurant.", 
"Many consider Roberto's or Zero Otto Nove to make the best pizza on Arthur Avenue.", "Emilia's Restaurant is often praised for making the best pizza on Arthur Avenue.",
 "Bronx's Best Pizza on Arthur Avenue is often hailed as the top spot for pizza.",
"Zero Otto Nove is widely acclaimed for making the best pizza on Arthur Avenue.",
"opinions vary, but many people believe that Full Moon Pizzeria makes the best pizza on Arthur Avenue.", 
"The best pizza on Arthur Avenue is often attributed to Full Moon Pizzeria.", 
"Many people say that Zero Otto Nove makes the best pizza on Arthur Avenue.", 
"The best pizza on Arthur Avenue is often attributed to Roberto's."}
*)
```

**Comment:**  Clearly the answers vary and one should be skeptical of LLM output.However, all of these places *do* exist, but I will also note that there are good places not on this list.  (For my safety, I shall not reveal my preferences.) So clearly the genre of confabulation here is whether any one of them is actually "the best" (which would be something humans would disagree on) rather than the model making things up.

### 2. Clustering:  Cluster sequences by their meaning by bidirectional entailment

We use an LLM to ask if two answers have an entailment.  The prompt is from **Methods: Entailment estimator.** (I turn off the interactive `ProgressReporting` because it is annoying to see it flash on the screen.)

```mathematica
entailmentEstimatorPrompt = LLMFunction[
    "We are evaluating answers to the question `1`
    
    Here are two possible answers:
    
    Possible Answer 1: `2`
    Possible Answer 2: `3`
    
    Does Possible Answer 1 semantically entail Possible Answer 2?  Respond with only Entailment, Contradiction, or Neutral", 
    LLMEvaluator -> config, 
    ProgressReporting -> None];
```

Use this prompt to check entailment and bidirectional entailment:

```mathematica
entailmentQ[q_, a1_, a2_] := 
   StringMatchQ[#, "Entailment", IgnoreCase -> True]&@
    entailmentEstimatorPrompt[q, a1, a2] 
 
bidirectionalEntailmentQ[question_, answer1_, answer2_] := With[
   {left = entailmentQ[question, answer1, answer2], 
    right = entailmentQ[question, answer2, answer1]}, 
   left && right]
```

Next, we need to cluster them based on the bidirectional entailment.  Line 2235 of the Supporting Information states that semantic equivalence is transitive, so they only compare each new answer only to the first answer in each of the existing clusters; this is also implied by the algorithm in **Extended Data: Algorithm 1.**  We implement this in functional form below, (I am impatient, so I run the bidirectional entailment checks against the first item in each of the existing clusters in parallel).   

```mathematica
(*base case when no clusters exist*)
  cluster[q_String][{}, a_String] := {{a}} 
   
  (* check if the current answer belongs to any existing clusters*) 
   cluster[q_String][clusters_List, a_String] := With[
     {match = FirstPosition[True]@ 
        ParallelMap[
         bidirectionalEntailmentQ[q, First[#], a] &, 
         clusters]}, 
     If[MissingQ[match], 
      Insert[clusters, {a}, -1], (* add a new cluster if we don't match *)
      Insert[clusters, a, Append[-1]@match]]] (* otherwise append to existing cluster *) 
   
  (*fold this function over each entry in the list of answers*) 
   cluster[q_String, a_List] := Fold[cluster[q], {}, a]
```

We expect to have many clusters, and indeed we do:

```mathematica
(*demo *)
  nc = cluster[question, answers]

(*{{"The best pizza on Arthur Avenue is widely considered to be from Full Moon Pizzeria.", "The best pizza on Arthur Avenue is often attributed to Full Moon Pizzeria."}, {"The best pizza on Arthur Avenue is often said to be from Mario's Restaurant."}, {"Many consider Roberto's or Zero Otto Nove to make the best pizza on Arthur Avenue."}, {"Emilia's Restaurant is often praised for making the best pizza on Arthur Avenue."}, {"Bronx's Best Pizza on Arthur Avenue is often hailed as the top spot for pizza."}, {"Zero Otto Nove is widely acclaimed for making the best pizza on Arthur Avenue."}, {"opinions vary, but many people believe that Full Moon Pizzeria makes the best pizza on Arthur Avenue."}, {"Many people say that Zero Otto Nove makes the best pizza on Arthur Avenue."}, {"The best pizza on Arthur Avenue is often attributed to Roberto's."}}*)
```

### 3. Entropy estimation:  Sum probabilities of sequences that share a meaning

To implement the discrete semantic entropy, each answer item has a unit size assigned each outcome to be a unit size, and then we determining the proportion of answers in each bin. The worked example **Supporting Information** line 1939 uses the base-10 logarithm when computing the entropy (so we shall also), but this does not really matter:

```mathematica
entropy[p_] := N@Total[ -p * Log[10, p]] 
 
discreteSemanticEntropy[clusters_] := With[
   {empiricalProbabilities =  (#/Total[#])&@ N@ Map[Length]@ clusters}, 
   entropy@ empiricalProbabilities]
```

```mathematica
(*demo*)
  discreteSemanticEntropy[nc]

(*0.939794*)
```

### Another demonstration: The Low Entropy Case

Now consider a question with less uncertainty:

```mathematica
question  = "What university is closest to Arthur Avenue?";
answers = ParallelTable[ qaPrompt[question], {10}]
clusters = cluster[question, answers];
discreteSemanticEntropy@clusters

(*{"Fordham University is closest to Arthur Avenue.", 
"Fordham University is the closest university to Arthur Avenue.", 
"The university closest to Arthur Avenue is Fordham University.", 
"Fordham University is the closest university to Arthur Avenue.", 
"Fordham University is closest to Arthur Avenue.", 
"Fordham University is closest to Arthur Avenue.", 
"Fordham University is the closest university to Arthur Avenue.", 
"Fordham University is the closest university to Arthur Avenue.", 
"Fordham University is closest to Arthur Avenue.", 
"Fordham University is closest to Arthur Avenue."}*)

(*0.*)
```

**Comment:**  As suggested by the paper, even though the words in the statements differ, they all are assigned into the same cluster.  And this low entropy response is more certain than the high entropy opinion about pizza; it is also something that humans will not disagree on.

### Exercise for the reader

Apply this to questions about other [Bronx](https://en.wikipedia.org/wiki/The_Bronx) trivia, like: W[here did Charles Fort live?](https://jschrier.github.io/blog/2024/07/13/Charles-Fort,-Son-of-the-Bronx.html)

### How to implement the (non-discrete) semantic entropy.

As noted, we are using the discrete semantic entropy.  The (not-discrete) semantic entropy uses length-normalized log-probabilities. To do this you would need to:

- Rewrite the code to call the OpenAI API more directly (because log-probs is not exposed in the Mathematica 14.0 LLM convenience wrappers) to obtain log-probs

    - Note: If we call the API directly, we can also request all of the examples at once (N parameter in the API), which speeds up the initial question generation.

- Perform the calculation following **Methods: Computing the Semantic Entropy** and **Supporting Information** 

## Detecting Confabulations in Longer Paragraphs (e.g., Biographies)

To assess the presence of confabulations in a longer output (for example a paragraph), we will use the same general idea, but first we decompose the longer output into a set of claims, and for each claim construct new question/answer pairs. The general process, described in **Methods: Detecting confabulations in biographies:  Prompting and generation**, as are all of the prompts that we will use in subsequent sections:

1. Decompose the paragraph into specific factual claims

2. For each factual claim, construct *Q*=6 questions which might have produced that claim.

3. For each question, generate answers and compute the semantic entropy of those answers.

4. Average the semantic entropies over the questions to arrive at a score for the factual claim.

In their work they use generated biographies. So to have some fun, we will make our own autobiography using [gpt-4o](https://openai.com/index/hello-gpt-4o/): 

```mathematica
bioQuestion = "Who is Joshua Schrier (chemist)?"
exampleBiography = LLMSynthesize[bioQuestion, LLMEvaluator -> config]

(*"Who is Joshua Schrier (chemist)?"*)

(*"Joshua Schrier is an American computational chemist known for his significant contributions to the field of materials science, particularly in the areas of machine learning, quantum chemistry, and the computational design of materials. He is currently a Professor of Chemistry at Fordham University. His research leverages computational techniques to solve complex chemical problems, including the exploration of new materials for energy applications and the development of algorithms to predict chemical properties and behaviors. 

Schrier's academic and research work aims to facilitate a deeper understanding of chemical systems and to innovate in the realm of materials chemistry by integrating computational methodologies. His research often involves the use of advanced computational tools to model, simulate, and predict the properties of materials at the atomic and molecular levels."*)
```

### 1. Decompose the paragraph into specific factual claims using an LLM 

Implement the prompt and split up the results (which are returned as a markdown list):

```mathematica
decomposePrompt = LLMFunction[
  "Please list the specific factual propositions included in the answer above. Be complete and do not leave any factual claims out. Provide each claim as a separate sentence in a separate bullet point.\n\n`1`", 
     LLMEvaluator -> config]; 
 
splitClaims[text_String] := StringDelete["\n"]@ StringSplit[text, StartOfLine ~~ "- "] 
 
decompose[text_String] := splitClaims@ decomposePrompt@ text
```

```mathematica
(*demo*)
  claims = decompose@exampleBiography

(*{"Joshua Schrier is an American computational chemist.", 
"Joshua Schrier is known for his significant contributions to the field of materials science.", 
"Joshua Schrier has made contributions in the areas of machine learning, quantum chemistry, and the computational design of materials.", 
"Joshua Schrier is currently a Professor of Chemistry at Fordham University.", 
"Joshua Schrier's research leverages computational techniques to solve complex chemical problems.", 
"Joshua Schrier's research includes the exploration of new materials for energy applications.", 
"Joshua Schrier develops algorithms to predict chemical properties and behaviors.", 
"Schrier's academic and research work aims to facilitate a deeper understanding of chemical systems.", 
"Schrier's research aims to innovate in the realm of materials chemistry by integrating computational methodologies.", 
"Schrier's research often involves the use of advanced computational tools to model, simulate, and predict the properties of materials at the atomic and molecular levels."}*)
```

**Comment:**  This is [reasonably correct](https://scholar.google.com/citations?hl=en&user=zJC_7roAAAAJ&view_op=list_works).

### 2. For each factual claim, use an LLM to automatically construct Q questions which might have produced that claim.

In the paper, they do this in two batches of three questions each; as this is slightly annoying to write the support coding for, so I am just going to generate all 6 together: 

```mathematica
questionGenerationPrompt =  LLMFunction[
    "Following this text:
    
    `1`
    
    You see the sentence:
    
    `2`
    
    Generate a list of six questions, that might have generated the sentence in the context of the preceding original text, as well as their answers. Please do not use specific facts that appear in the follow-up sentence when formulating the question. Make the questions and answers diverse. Avoid yes-no questions. The answers should not be a full sentence and as short as possible, e.g. only a name, place, or thing. Use the format \"1. {question} - {answer}\"", 
    LLMEvaluator -> config, 
    ProgressReporting -> None];
```

The idea is that it takes all of the previous text as an input and checks a new claim each time.  So, for example, to check claim N, we need to provide claims 1..*N*-1 as input.  For example, we check claim 2 and provide claim 1 for the first part:

```mathematica
(*demo *)
  example = questionGenerationPrompt[claims[[1]], claims[[2]]]

(*"1. What area of research is Joshua Schrier particularly known for? - Computational materials science
2. Which field does Joshua Schrier mainly contribute to? - Materials science 
3. What kind of impact has Joshua Schrier had in his field of study? - Significant
4. Joshua Schrier's work primarily advances which scientific discipline? - Materials science
5. In which area of scientific research has Joshua Schrier achieved notable recognition? - Materials science
6. What is a primary focus of Joshua Schrier's research activities? - Computational chemistry in materials science"*)
```

Now we have to do a bit of programming.  First some text wrangling to divide these into question/answer pairs (I suppose we could have asked the LLM to output this as a JSON dictionary, but let's stay close to source):

```mathematica
extractQA [text_String] := StringSplit[#, "? - "]&@ StringReplace[{"?" -> "??", "\n" -> ""}]@ StringSplit[text, StartOfLine ~~ NumberString ~~ ". "] 
  
 (*demo*)
extractQA[example]

(*{{"What area of research is Joshua Schrier particularly known for?", "Computational materials science"}, 
{"Which field does Joshua Schrier mainly contribute to?", "Materials science"}, 
{"What kind of impact has Joshua Schrier had in his field of study?", "Significant"}, 
{"Joshua Schrier's work primarily advances which scientific discipline?", "Materials science"}, 
{"In which area of scientific research has Joshua Schrier achieved notable recognition?", "Materials science"}, 
{"What is a primary focus of Joshua Schrier's research activities?", "Computational chemistry in materials science"}}*)
```

Put these together and return the results as a dictionary:

```mathematica
generateQuestions[previousClaims_List, currentClaim_String] := With[
   {qa = extractQA@questionGenerationPrompt[
       StringRiffle[previousClaims], currentClaim]}, 
   <|"previous text" -> StringRiffle[previousClaims], 
    "current claim" -> currentClaim, 
    "questions" -> Map[First, qa], 
    "answers" -> Map[Last, qa] 
   |>]
```

```mathematica
(*demo*)
  ex2 = generateQuestions[claims[[;; 3]], claims[[4]]]

(*<|
"previous text" -> "Joshua Schrier is an American computational chemist. Joshua Schrier is known for his significant contributions to the field of materials science. Joshua Schrier has made contributions in the areas of machine learning, quantum chemistry, and the computational design of materials.", 
"current claim" -> "Joshua Schrier is currently a Professor of Chemistry at Fordham University.", 
"questions" -> {"Where does Joshua Schrier currently teach?", "What is Joshua Schrier's current academic position?", "At which university does Joshua Schrier hold a professorship?", "What subject does Joshua Schrier currently teach?", "Which university is Joshua Schrier affiliated with as a professor?", "What is Joshua Schrier's role at his current institution?"}, 
"answers" -> {"Fordham University", "Professor of Chemistry", "Fordham University", "Chemistry", "Fordham University", "Professor"}|>*)
```

###  3. For each question, prompt the original LLM to generate M answers.

```mathematica
generateNewAnswersPrompt = LLMFunction[
   "We are writing an answer to the question \"`1`\".  So far we have written:
   
   `2`
   
   The next sentence should be the answer to the following question:
   
   `3`
   
   Please answer this question. Do not answer in a full sentence. Answer with as few words as possible, e.g. only a name, place, or thing.", 
   LLMEvaluator -> config]
```

![1ihqlnytdpr4m](/blog/images/2024/7/31/1ihqlnytdpr4m.png)

```mathematica
(*demo*)
```

```mathematica
bioQuestion (*user question*)
ex2["previous text"] (* text so far*)
ex2[["questions"]][[1]] (* question *) 
 
generateNewAnswersPrompt[bioQuestion, ex2["previous text"], ex2["questions"][[1]]]

(*"Who is Joshua Schrier (chemist)?"*)

(*"Joshua Schrier is an American computational chemist. Joshua Schrier is known for his significant contributions to the field of materials science. Joshua Schrier has made contributions in the areas of machine learning, quantum chemistry, and the computational design of materials."*)

(*"Where does Joshua Schrier currently teach?"*)

(*"Fordham University"*)
```

Now we just need to do this three times for every question and repeat it over all of the questions.  As stated in the **Methods** section, these are returned along with the original factual claim:

```mathematica
generateNewAnswers[originalQuestion_String, currentQuestion_Association] := With[
   {previousText = currentQuestion["previous text"], 
    originalClaim = currentQuestion["current claim"], 
    q = Flatten@ ConstantArray[currentQuestion["questions"], 3], 
    a = currentQuestion["answers"]}, (* make three copies of each question *)
   
   a~Join~ParallelMap[generateNewAnswersPrompt[originalQuestion, previousText, #] &, q] 
  ]
```

Implementation notes: 

- In the **Methods** section the authors state "We then compute the semantic entropy over these (generated) answers plus the original factual claim." But if you do this using the claim sentence then it breaks the bidriectional entailment clustering (original claim sentence "Joshua Schrier is a [chiguiro](https://jschrier.github.io/blog/tag/chiguiro)" does not bidirectionally entail the generated answer consisting only of the word "[chiguiro](https://jschrier.github.io/blog/tag/chiguiro)"). So I read this as being about the generated answers during the question/answer pair.  

- If doing this through the API, you can have all three completions returned in one request, but the MMA14.0 LLMFunction does not let you do this, so we just query it three independent times and run the queries in parallel.  

```mathematica
(*demo*)
  answers = generateNewAnswers[bioQuestion, ex2]

(*{"Fordham University", "Professor of Chemistry", "Fordham University", "Chemistry", "Fordham University", "Professor", "Fordham University", "Professor at Fordham University", "Fordham University", "Chemistry", "Fordham University", "Professor at Fordham University", "Fordham University", "Haverford College", "Haverford College", "Chemistry", "Fordham University", "Professor at Fordham University", "Fordham University", "Chair of the Department of Chemistry at Fordham University", "Fordham University", "Chemistry", "Fordham University", "Professor at Fordham University"}*)
```

Now just go ahead and perform the bidirection entailment clustering, using the functions defined in the section on Q/A problems:

```mathematica
 cluster[bioQuestion, answers] 
 discreteSemanticEntropy@%

(*{{"Fordham University", "Fordham University", "Fordham University", "Fordham University", "Fordham University", "Fordham University", "Fordham University", "Fordham University", "Fordham University", "Fordham University", "Fordham University"}, {"Professor of Chemistry"}, {"Chemistry", "Chemistry", "Chemistry", "Chemistry"}, {"Professor"}, {"Professor at Fordham University", "Professor at Fordham University", "Professor at Fordham University", "Professor at Fordham University"}, {"Haverford College", "Haverford College"}, {"Chair of the Department of Chemistry at Fordham University"}}*)

(*1.55916*)
```

**Observation:** Clearly the questions have different types of answers (*university* versus *position* versus *university+position* statements) and this breaks the bidirectional entailment calculation.  This might be less broken if it was provided in full sentence form, yet the authors are pretty clear about their prompts for this section requesting a short answer only. [Boh?!?](https://italian.stackexchange.com/questions/1142/what-does-boh-mean-precisely) 

### 4. Average the semantic entropies over the questions to arrive at a score for the factual claim.

**Left as an exercise for the reader:**  Write a wrapper function for the functions above, loop over each question, and then take the average.  Watch out for the edge case of no first entry by passing in a "empty" item or something.

```mathematica
ToJekyll[
  "Detecting LLM confabulations with semantic entropy", 
  "llm gpt4 ml mathematica nyc science"]
```
