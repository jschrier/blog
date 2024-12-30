---
title: "Retrieval Augmented Generation, Revisited"
date: 2024-12-26
tags: ai mathematica llm theology gpt4
---

Last year I started my study of LLM programming by [implementing a retrieval augmented generation (RAG)]({{ site.baseurl }}{% post_url 2023-08-24-Retrieval-Augmented-Generation %}) over the [Catechism of the Catholic Church](https://www.vatican.va/archive/ENG0015/_INDEX.HTM) using the LLM functionality in Mathematica 13.3. (Cue [Tom Lehrer's Vatican Rag](https://www.youtube.com/watch?v=pvhYqeGp_Do).) Since then, I have learned a few tricks and there are some new features in Mathematica 14.1 that make this even easier...**time for an update!...**

## Control Experiment

The idea of retrieval augmented generation is to make the LLM response be rooted in the specific, relevant content that we provide.  Here is the control experiment where we do **not** provide the context information of the Catechism:

```mathematica
LLMSynthesize["What must I do to gain eternal life?"]
```

> The question of gaining eternal life has been contemplated by many religious and philosophical traditions, each offering different perspectives and teachings. Here are some common viewpoints from several major world religions and philosophies:
> 1. **Christianity**: Eternal life is often described as being in a relationship with God through Jesus Christ. According to the New Testament, faith in Jesus, repentance from sin, and living according to God's commandments are key. Verses like John 3:16 emphasize belief in Jesus as a path to eternal life.
> 2. **Islam**: Eternal life in paradise (Jannah) is achieved through submission to the will of Allah, following the Five Pillars of Islam, and living a righteous life. The Quran describes a belief in Allah and good deeds as essential for attaining eternal bliss.
> 3. **Judaism**: The concept of eternal life is less emphasized than in Christianity and Islam. Instead, focus is often on living a life in accordance with God's laws as described in the Torah. The afterlife is less defined and can vary in understanding, but living a life of righteousness and justice is a central theme.
> 4. **Hinduism**: The cycle of reincarnation and the ultimate goal of moksha, or liberation from this cycle, is key to attaining eternal life. This involves living a life according to dharma (moral duty), karma (actions and their consequences), and seeking spiritual knowledge and detachment.
> 5. **Buddhism**: Similar to Hinduism, Buddhism teaches about the cycle of birth and rebirth (samsara) and the attainment of nirvana, which is often described as liberation from this cycle. This involves following the Eightfold Path and cultivating wisdom, ethical conduct, and mental discipline.
> 6. **Philosophical Perspectives**: Outside of organized religion, some philosophical traditions may focus on leaving a legacy through one's actions and contributions to society or achieving a form of "eternal life" through knowledge and understanding.
> Your personal beliefs and worldview will significantly influence the path you choose to explore in seeking eternal life. Engaging with spiritual teachings, reflecting on moral values, and seeking guidance from spiritual leaders in the tradition you resonate with can offer deeper insights.


## Pre-processing

[As before]({{ site.baseurl }}{% post_url 2023-08-24-Retrieval-Augmented-Generation %}), we will use the English language version of the [Catechism of the Catholic Church](https://www.vatican.va/archive/ENG0015/_INDEX.HTM), which is a useful example because it is a large document that comes with a built-in segmentation into smaller pieces, is mostly plain-text HTML with minimal formatting, and is [available for free online](https://www.vatican.va/archive/ENG0015/_INDEX.HTM).   

We'll retrieve the index page, and then use the links in the page to retrieve the remainder of the content:

```mathematica
sectionLinks = With[
    {url = "https://www.vatican.va/archive/ENG0015/_INDEX.HTM"}, 
    Drop[#, 10] &@Import[url, "Hyperlinks"]]; (* first 10 links are navigation tools *)
```

Note that we do not even need to retrieve the texts...just the links.  

## Create the Vector Database using CreateSemanticSearchIndex

[Previously]({{ site.baseurl }}{% post_url 2023-08-24-Retrieval-Augmented-Generation %}), we retrieved the text, computed the embedding vectors by making an API call to OpenAI, and then used Nearest to create a lookup function. While there is an underlying lower-level [VectorDatabaseObject](http://reference.wolfram.com/language/ref/VectorDatabaseObject.html) that can be used to construct this, for text-related queries the new [SemanticSearch](http://reference.wolfram.com/language/ref/SemanticSearch.html) functionality streamlines this into a single function.  We can provide a list of texts (or in our case, a list of URLs from which to retrieve the text), handle the necessary chunking, and use a local copy of SentenceBERT to generate the embedding vectors, returning a searchable index.  This took about 5 minutes to retrieve and embed the text on my laptop:

Let's also compare to the **default chunking**: 

```mathematica
CreateSemanticSearchIndex[
  URL /@ sectionLinks, (* retrieve URLs directly *)
  "catechism_default", (*optional index name*)
  DistanceFunction -> CosineDistance] (* traditional to use cosine distance*)
```

![1h140p0lwsex6](/blog/images/2024/12/26/1h140p0lwsex6.png)

A few comments:

- The input method (first argument) is quite flexible.  One can provide a list of strings or a list of URLs or Files to retrieve plain text from.

- The `DistanceFunction` defaults to `EuclideanDistance`, which seems a bit odd as usually `CosineDistance` is the typical choice.

- SentenceBERT is the default embedding method (so we did not strictly have to specify it), but you can provide other functions to generate embeddings any other way you like. We will demonstrate below

- Providing a name (`catechism_default`) creates a persistent local copy, which is cool. You can see what you have lurking with [SemanticSearchIndices](http://reference.wolfram.com/language/ref/SemanticSearchIndices.html)

- It is also possible to incrementally update an existing index with [UpdateSemanticSearchIndex](http://reference.wolfram.com/language/ref/UpdateSemanticSearchIndex.html)

- The default chunks are 500 tokens, which is about 375 words.

Just for fun, let's also compare to **generating a search index using a longer context length and custom chunking:**

```mathematica
CreateSemanticSearchIndex[
  URL /@ sectionLinks, (* retrieve URLs directly *)
  "catechism", (*optional index name creates a persistent local storage object*)
  DistanceFunction -> CosineDistance, (* traditional to use cosine distance*)
  FeatureExtractor -> "SentenceBERT", (*default, runs locally*)
  Method -> 
   <|"MaximumItemLength" -> 3000,(* chunks of 3000 tokens, padded...*)
    "ContextPadding" -> 500|>]
```

![1dndyjl99ryt0](/blog/images/2024/12/26/1dndyjl99ryt0.png)

Or just long chunks:

```mathematica
index2 = CreateSemanticSearchIndex[
   URL /@ sectionLinks, (* retrieve URLs directly *)
   "catechism_long_context", (*optional index name*)
   DistanceFunction -> CosineDistance, (* traditional to use cosine distance*)
   Method -> 
    <|"MaximumItemLength" -> 4000(* chunks of 4000 tokens, no padding...*)|>]
```

![0zp7gbkywkfv2](/blog/images/2024/12/26/0zp7gbkywkfv2.png)

Additionally, let's also **compare to using the OpenAI embeddings**.  We do this by providing a function as the `FeatureExtractor` option; this function has to take a list of inputs (not a scalar) and return a list of vectors. By default the embedding vectors returned are [NumericArrays](http://reference.wolfram.com/language/ref/NumericArray.html) and `CreateSemanticSearchIndex` only wants `Normal` list representations, so we have to do a conversion (this seems a bit unpolished to me, maybe it will change in future versions):

```mathematica
openAIEmbedding[texts_List] := Normal@Lookup["Content"]@ServiceExecute["OpenAI", "Embedding", {"Input" -> texts}] 
 
indexOAI = CreateSemanticSearchIndex[
   URL /@ sectionLinks, (* retrieve URLs directly *)
   "catechism_long_openAI", (*optional index name*)
   DistanceFunction -> CosineDistance, (* traditional to use cosine distance*)
   FeatureExtractor -> openAIEmbedding, 
   Method -> 
    <|"MaximumItemLength" -> 4000(* chunks of 4000 tokens, no padding...*)|>]
```

![0ls2j9rr7itn8](/blog/images/2024/12/26/0ls2j9rr7itn8.png)

## Vector Retrieval with SemanticSearch

Use [SemanticSearch](http://reference.wolfram.com/language/ref/SemanticSearch.html) to retrieve the relevant chunk(s).  Once you define the search, all of the other handling takes place magically:

```mathematica
SemanticSearch["catechism", (* uses the persistant local copy with this name *)
  "What must I do to have eternal life?" (* query *), 
  MaxItems -> 1] (* by default, returns 10 items *)


(*{" eternal life, filiation, rest in God.  1727 The beatitude of eternal life is a gratuitous gift of God. It is supernatural, as is the grace that leads us there.  1728 The Beatitudes confront us with decisive choices concerning earthly goods; they purify our hearts in order to teach us to love God above all things.  1729 The beatitude of heaven sets the standards for discernment in the use of earthly goods in keeping with the law of God.  Previous - NextCopyright (c) Libreria Editrice Vaticana"}*)
```

It is also convenient that you can metadata information together:

```mathematica
SemanticSearch["catechism", (* uses the persistant local copy with this name *)
  "What must I do to have eternal life?" (* query *), 
  {"Query", "Item", "Source"}, 
  MaxItems -> 1]

(*{<|
"Query" -> "What must I do to have eternal life?", 
"Item" -> " eternal life, filiation, rest in God.  1727 The beatitude of eternal life is a gratuitous gift of God. It is supernatural, as is the grace that leads us there.  1728 The Beatitudes confront us with decisive choices concerning earthly goods; they purify our hearts in order to teach us to love God above all things.  1729 The beatitude of heaven sets the standards for discernment in the use of earthly goods in keeping with the law of God.  Previous - NextCopyright (c) Libreria Editrice Vaticana", 
"Source" -> "https://www.vatican.va/archive/ENG0015/__P5L.HTM"
|>}*)
```

How do the different embeddings and chunking options compare?

```mathematica
TableForm@Table[
   {i, SemanticSearch[i, "What must I do to have eternal life?", MaxItems -> 1]}, 
   {i, {"catechism_default", "catechism", "catechism_long_context", "catechism_long_openAI"}} 
  ]
```

![0nvkq70mafy2z](/blog/images/2024/12/26/0nvkq70mafy2z.png)

## One-step RAG with LLMPromptGenerator

By default, when [LLMPromptGenerator](http://reference.wolfram.com/language/ref/LLMPromptGenerator.html) gets a `SemanticIndex` as an input, it adds the typical contextual information, drawing from the top ten items, using the embedding methods and distances defined by the `CreateSemanticIndex` definition:

```mathematica
LLMPromptGenerator@ indexOAI
```

![0xa6oaw22br2x](/blog/images/2024/12/26/0xa6oaw22br2x.png)

Consequently, once you've defined your data, it is as simple as:

```mathematica
LLMSynthesize[
  "What must I do to gain eternal life?", 
  LLMEvaluator -> <|"Prompts" -> LLMPromptGenerator@indexOAI|>]
```

> According to the Catechism of the Catholic Church, to gain eternal life you must keep the commandments (Mt 19:16-17). It involves living a life in God's grace and friendship, as well as loving God, yourself, and your neighbor. Eternal life is the fulfillment of God's promise and the deepest human longing, which involves being perfectly purified and united with God. Additionally, the Church emphasizes the importance of faith in Jesus Christ, adherence to the teachings of the Church, and the practice of prayer and the sacraments as part of the journey towards achieving eternal life.


(All examples use the default gpt-4o for generation; you may modify this by changing the [LLMConfiguration](http://reference.wolfram.com/language/ref/LLMConfiguration.html) provided to LLMEvaluator.)

Prompts can take a list of inputs, which provides a way add other style modifiers, etc.; we will pull one from the [Prompt Repository](https://resources.wolframcloud.com/PromptRepository/):

```mathematica
LLMSynthesize[
  "What must I do to gain eternal life?", 
  LLMEvaluator -> <|"Prompts" -> { LLMPrompt["Yoda"], LLMPromptGenerator@indexOAI}|>]
```

> Ah, seek eternal life you do. Into life, enter you must by keeping the commandments, as it is said. (Mt 19:16-17, hmm.) In God's grace and friendship, live; follow the path of love and righteousness. Through faith in Christ and His teachings, walk steady. Eternal life, to know the true God and Jesus Christ, whom sent He did.


You can also specify RAG against the named persistent indices you have previously created on your machine, which is quite handy.  Here is a generation using the SentenceBERT with default settings:

```mathematica
LLMSynthesize[
  "What must I do to gain eternal life?", 
  LLMEvaluator -> <|"Prompts" -> LLMPromptGenerator@SemanticSearchIndex["catechism_default"]|>]
```

> According to the context provided, gaining eternal life involves several key components: 
> 1. **Faith and Grace**: Eternal life is a supernatural gift that depends on God's gratuitous initiative. Belief in Christ and the grace infused by the Holy Spirit are essential.
> 2. **Purification from Sin**: One must purify themselves in action, thought, and word, striving for a pure soul. This involves a life free from sin and its consequences through God's grace.
> 3. **Following Christ's Example**: Emulate Christ's life and teachings, leading a life of charity and holiness. This is done by acting rightly and doing good as a reflection of one's faith.
> 4. **Participating in the Sacraments**: Baptism and the Eucharist play a significant role in experiencing and receiving the grace that leads to eternal life.
> 5. **Desiring Union with God**: Cultivate a desire to be with Christ, transforming one's death into an act of obedience and love towards God. This demonstrates trust in the promise of eternal life.
> 6. **Practice of Charity**: A conversion with fervent charity helps in attaining complete purification, freeing one from the temporal punishment of sin.
>
> The Beatitudes and a life aligned with God's divine plan are also significant in this journey. These involve discernment in the use of earthly goods and aligning one's life with the vision and values of the Kingdom of Heaven.


## tl;dr--RAG in 3 easy steps:

I've shown a lot of options and variations, but in the end it is quite simple:

**Step 1:**  Collect your documents (only needed once) 

```mathematica
sectionLinks = With[
    {url = "https://www.vatican.va/archive/ENG0015/_INDEX.HTM"}, 
    Drop[#, 10] &@Import[url, "Hyperlinks"]]; (*first 10 links are navigation tools*)

```

**Step 2:**  Create a persistent local datastore (only needed once) 

```mathematica
CreateSemanticSearchIndex[
  URL /@ sectionLinks, (* retrieve URLs directly *)
  "catechism_default", (*specify name for a persistent local index*)
  DistanceFunction -> CosineDistance] (* traditional to use cosine distance*)

```

**Step 3:**  Query your semantic index (repeated as needed)

```mathematica
LLMSynthesize[
  "What must I do to gain eternal life?", (*input text *)
  LLMEvaluator -> <|  (*default RAG query *) "Prompts" -> LLMPromptGenerator@SemanticSearchIndex["catechism_default"]|>]
```

[Ite, missa est.](https://en.wikipedia.org/wiki/Ite,_missa_est)  

```mathematica
ToJekyll["Retrieval Augmented Generation, Revisited", "ai mathematica llm theology gpt4"]
```
