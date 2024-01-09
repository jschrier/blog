---
title: "Three LLM Summarization Strategies"
date: 2023-08-27
tags: ai mathematica llm gpt3.5
---

[User5601 asks:](https://mathematica.stackexchange.com/questions/288538/need-short-summary-of-60-page-document-using-llmfunctions)*Is there any append/chunking solutions for getting OpenAI to summarize docs longer than the input limit through either one large or multiple ChatInput cells or some other programmatic way (using the [new LLM functionality in Mathematica 13.3](https://writings.stephenwolfram.com/2023/06/llm-tech-and-a-lot-more-version-13-3-of-wolfram-language-and-mathematica/))?* **A summary of strategies and implementations...**

Text summarization is useful in many contexts, such as generating abstracts of creating podcast previews.  [Isaac Tham (May 2023) describes a three strategies for text summarization with LLMs](https://towardsdatascience.com/summarize-podcast-transcripts-and-long-texts-better-with-nlp-and-ai-e04c89d3b2cb) and we shall explore them here. This example uses GPT-3.5, running on OpenAI for all examples, although the strategies are generalizable.

## Data

We will demonstrate this on the 2023 State of the Union Address delivered by US President Joe Biden;  for convenience, [Tham provides a plain text form on his Github](https://github.com/thamsuppp/llm_summary_medium/blob/master/stateoftheunion.txt), which we shall use below: 

```mathematica
url = "https://raw.githubusercontent.com/thamsuppp/llm_summary_medium/master/stateoftheunion.txt";
sentences = Import[url, "List"] // DeleteCases[""];
```

## Default Prompt

Oh right:  [Wolfram provides a prompt repository](https://writings.stephenwolfram.com/2023/06/prompts-for-work-play-launching-the-wolfram-prompt-repository/) we can use for this...How does it work?

The text is too long to provide it in its entirety as an input using the [Summarize](https://resources.wolframcloud.com/PromptRepository/resources/Summarize/) prompt:

```mathematica
With[
  {completeText = StringJoin[sentences]}, 
  LLMResourceFunction["Summarize"][ completeText]]
```

![0xhx1flbex419](/blog/images/2023/8/27/0xhx1flbex419.png)

However, the [SummarizeURLContent](https://resources.wolframcloud.com/PromptRepository/resources/SummarizeURLContent/) prompt (which presumably uses a server-side tool) can do this just fine:

```mathematica
LLMResourceFunction["SummarizeURLContent"][url]

(*"The contents of the given URL are the transcript of a State of the Union address. The speaker congratulates members of Congress and the Cabinet, discusses the progress and resilience of America, and highlights achievements in job creation, COVID-19 control, and democracy. The speaker emphasizes the need to work together and mentions bipartisan laws that have been passed. The focus then shifts to rebuilding the middle class, creating manufacturing jobs, and addressing inflation. The speaker also discusses the importance of American-made products, the bipartisan CHIPS and Science Act, and the Bipartisan Infrastructure Law. The address concludes with a commitment to investing in forgotten places and people."*)
```

But this is too easy, so instead we will demonstrate [three strategies.](https://towardsdatascience.com/summarize-podcast-transcripts-and-long-texts-better-with-nlp-and-ai-e04c89d3b2cb) As far as I can tell, [Prompt Engineering is mostly voodoo,](https://lilianweng.github.io/posts/2023-03-15-prompt-engineering/) so we will just use the [Wolfram Summarize prompt](https://resources.wolframcloud.com/PromptRepository/resources/Summarize/); of course, you can substitute as you see fit. 

## Recursive Summarization

**Approach:**  Split a long text into equally shorter chunks that fit inside the LLM context window.  Each chunk is summarized independently and the summaries are concatenated together and then passed through the LLM to be further summarized.  Repeat until the final summary is the desired length

**Pro:**  This is widely used and easy to parallelize.

**Con:** Disregards logical flow and structure of the text (splitting by word count will break across sentences, paragraphs, chains of thought)

**Implementation:**  For sake of demonstration we'll implement a chunk function we can use in subsequent work.  

```mathematica
(*divide into chunks with default length of 3000 words*)
chunk[sentences_List, chunkLength_ : 3000] := With[
  {chunkGroups = Ceiling[#/chunkLength] &@Accumulate@WordCount@sentences}, 
  StringRiffle /@ Values@ResourceFunction["GroupByList"][sentences, chunkGroups]]
```

```mathematica
(*summarize each chunk*)
summarizeChunks[sentences_List, chunkLength_ : 3000] := With[
  {chunks = chunk[sentences, chunkLength]}, 
  TextSentences@StringRiffle@
  ParallelMap[ LLMResourceFunction["Summarize"], chunks]] 
   
(*see if the current list of sentences exceeds a total word count*) 
exceedsWordCountQ[targetWordCount_Integer][sentences_List] := 
  GreaterThan[targetWordCount]@WordCount@StringRiffle@sentences 
   
  (*apply summarizeChunks repeatedly until we are below the target wordcount length*) 
recursiveSummarize[sentences_List, targetLength_ : 3000] := 
  NestWhile[ summarizeChunks, sentences, exceedsWordCountQ[targetLength]] // StringRiffle
```

```mathematica
(*demo*)
output = recursiveSummarize[sentences] 
WordCount[%]

(*"In his address, President Biden congratulates members of Congress and highlights key leaders in the government. He emphasizes the progress and resilience of the United States, citing economic growth, the handling of COVID-19, and the preservation of democracy. He calls for unity and collaboration between Democrats and Republicans and outlines his plans to rebuild the middle class, invest in infrastructure, and address healthcare and climate change issues. The speaker claims that their administration has cut the deficit by over $1.7 trillion, the largest reduction in American history, while criticizing the previous administration for increasing the deficit. They also express their commitment to protecting Social Security and Medicare benefits and ask Congress to follow suit. Additionally, they discuss their plans to lower the deficit, extend the Medicare Trust Fund, and make the wealthy and big corporations pay their fair share in taxes. The text highlights America's commitment to defending democracy and standing against aggression, particularly in relation to Ukraine and China. It emphasizes the strength of America's position in the world and the progress made in areas such as healthcare, mental health, and veterans' support. The text also emphasizes the importance of democracy, the need to protect the right to vote, and the responsibility to uphold the rule of law."*)

(*210*)
```

## Refining Method

**Approach:**  Pass every chunk of text along with a summary of previous chunks through the LLM to generate a progressive summary 

**Pro:**  This is even easier to implement than recursive summarization and only requires some simple prompting.

**Con:**  This is sequential (so it does not take advantage of parallelism) and may over-represent the initial parts of the source material in the final summary.

**Implementation:** In practice, you may also have to work with smaller chunks, as there is no strong guarantee on the summary size.  In practice this also has some challenges with controlling the final word count, unless you do something special with the prompt (FWIW, the [Summarize prompt allows for an optional sentence-count target](https://resources.wolframcloud.com/PromptRepository/resources/Summarize/).) 

```mathematica
(*join the previous summary with the current chunk*)
joinedSummary[previousSummary_String, currentChunk_String] := With[
  {input = StringRiffle[{previousSummary, currentChunk}]}, 
  LLMResourceFunction["Summarize"][input]] 
   
(*just fold in the summary and the next chunk until you're done*) 
refiningSummarize[sentences_List, chunkLength_ : 1000] := With[
  {chunks = chunk[sentences, chunkLength]}, 
  Fold[joinedSummary, chunks]]
```

```mathematica
(*demo*)
refiningSummarize[sentences] 
WordCount[%]

(*"President Biden addressed Congress, discussing a range of issues including healthcare reform, climate action, police reform, immigration reform, protection of LGBTQ rights, and America's stance against China's aggression. He also emphasized the need to end cancer as we know it and restore trust in our institutions of democracy, calling for unity and a rejection of hate and extremism. Despite the challenges, he expressed optimism about the future of America and the capacity to overcome them together."*)

(*76*)
```

## Combined Summarization and Topic Modeling

This is the strategy that [Tham advocates in his article](https://towardsdatascience.com/summarize-podcast-transcripts-and-long-texts-better-with-nlp-and-ai-e04c89d3b2cb); Tham does something complicated with providing topic titles and topic summaries at each summarization stage.  I suppose it is useful as a demonstration for defining custom prompts, but seems out of our scope for now.  The core idea is:

1. Divide the text into groups of 10 sentences each (with an overlap of 2 sentence for continuity.)

2. Summarize each chunk

3. Compute an embedding vector for each chunk

4. Cluster the embedding vectors--Tham uses [Louvain community detection](https://en.wikipedia.org/wiki/Louvain_method), aka Modularity optimization, which is one of the methods available in [FindGraphCommunities](http://reference.wolfram.com/language/ref/FindGraphCommunities.html).  But there is nothing intrinsically special about this, and we might instead think about using the variety of methods implemented in [FindClusters](http://reference.wolfram.com/language/ref/FindClusters.html) to do this for us.

5. Aggregate the summaries in each cluster as new chunks

We will demonstrate how to do this for a single round (defining functions as we proceed) and then put it all together to do it iteratively until we reach a desired summary size.  To begin, define a function to do the sentence group chunking:

```mathematica
(*chunk by sentence --- instead of by word count as we did above*)
sentenceChunk[sentences_List, chunkSize_ : 10, chunkOverlap_ : 2] :=
  StringRiffle /@ 
    Partition[sentences, UpTo[chunkSize], chunkSize - chunkOverlap]
```

Compute summaries of each chunk:

```mathematica
summaries = ParallelMap[ 
  LLMResourceFunction["Summarize"], sentenceChunk[sentences]];
```

Then generate embeddings for each chunk. It seems like an oversight, but [Mathematica 13.3](https://writings.stephenwolfram.com/2023/06/llm-tech-and-a-lot-more-version-13-3-of-wolfram-language-and-mathematica/) does not[^1] include a function for this; instead we will use the [OpenAILink](https://resources.wolframcloud.com/PacletRepository/resources/ChristopherWolfram/OpenAILink/) paclet.  Be sure to install it first, if you have not done so already.  We will use OpenAILink to generate embedding vectors for each chunk:

```mathematica
Needs["ChristopherWolfram`OpenAILink`"]
embeddings = ParallelMap[OpenAIEmbedding, summaries];
```

Visualize how close the different chunks are to one another:

```mathematica
ArrayPlot@DistanceMatrix[embeddings, DistanceFunction -> CosineDistance]
```

![11qoaisrqulx2](/blog/images/2023/8/27/11qoaisrqulx2.png)

Now let's cluster them together:

```mathematica
clusters = StringRiffle /@ 
  FindClusters[
    embeddings -> summaries, 
    DistanceFunction -> CosineDistance];
Length[%]

(*13*)
```

Note that [FindClusters](http://reference.wolfram.com/language/ref/FindClusters.html) returns a result that is sorted by the first element in a cluster (this is quite useful for our purpose):

```mathematica
FindClusters[embeddings -> Range[Length[embeddings]], DistanceFunction -> CosineDistance]

(*{ {1, 2, 23}, {3, 42}, {4, 5, 6, 8, 9, 11, 13, 14, 18, 20, 21, 22, 25, 26, 27, 28, 29, 31, 32}, {7, 10, 15, 16, 17}, {12, 38, 39, 40}, {19}, {24, 30, 41}, {33}, {34, 35, 36, 37}, {43, 44, 45, 52, 53, 54, 55}, {46, 47}, {48}, {49, 50, 51}}*)
```

All of our new clusters are below the token limit, but otherwise we might need to go in and break these up too.  For now we can skip this:

```mathematica
WordCount /@ clusters

(*{238, 113, 1308, 402, 262, 63, 212, 85, 247, 417, 116, 64, 226}*)
```

At this point we would continue until we got to the desired word count. 

Having demonstrated what a single pass looks like, we will define a function to perform each of the steps, and then another function that can be called recursively to generate the final summary with a desired target word length:

```mathematica
Needs["ChristopherWolfram`OpenAILink`"] 
 
clusterSummarize[sentences_List] := Module[ 
  {summaries, embeddings, clusters}, 
  summaries = ParallelMap[ 
    LLMResourceFunction["Summarize"], sentenceChunk[sentences]]; 
  embeddings = ParallelMap[OpenAIEmbedding, summaries]; 
  clusters = StringRiffle /@ 
    FindClusters[
      embeddings -> summaries, 
      DistanceFunction -> CosineDistance]; 
  (*return a list of new sentences*) 
  TextSentences@StringRiffle[clusters] 
] 
  
 (*repeat this until we meet the target*)
recursiveCluster[sentences_List, targetLength_ : 500] := 
  NestWhile[ clusterSummarize, sentences, exceedsWordCountQ[targetLength]] // StringRiffle 
  
 (*demo*)
recursiveCluster[sentences]
WordCount[%]

(*"The speaker addresses various political figures, congratulating Kevin McCarthy as the new Speaker of the House and Hakeem Jeffries as the first Black House Minority Leader. They also acknowledge Mitch McConnell and Chuck Schumer as Senate leaders, with Schumer being re-elected as Senate Majority Leader with a larger majority. The speaker praises Nancy Pelosi as the greatest Speaker in US history and highlights the nation's progress and resilience, with the economy rebounding and COVID no longer dominating daily life. The text also mentions measures such as the Inflation Reduction Act to lower healthcare costs and provide financial security, and emphasizes goals of lowering utility bills, creating jobs, transitioning to clean energy, and investing in resilient infrastructure. The speaker proposes implementing a billionaire minimum tax, increasing taxes on corporate stock buybacks, and protecting Social Security and Medicare benefits, while promising not to raise taxes for those earning under $400,000 a year. The speaker proposes implementing a billionaire minimum tax, increasing taxes on corporate stock buybacks, and protecting Social Security and Medicare benefits, while promising not to raise taxes for those earning under $400,000 a year. They emphasize efforts to protect consumers, crack down on fraud, and promote competition in capitalism. The text also advocates for bipartisan legislation to strengthen antitrust enforcement, prevent unfair advantages for big online platforms, and address \"junk\" fees imposed by companies to protect consumers. The text highlights the importance of supporting veterans and their families, addressing veteran suicide, and reducing the cancer death rate. It also emphasizes the need for action on police reform and the importance of conserving historic lands due to the climate crisis. Additionally, the speaker calls for defending democracy, speaking out against political violence, protecting the right to vote, upholding the rule of law, and restoring trust in democratic institutions. The speaker highlights the significance of safeguarding democracy by condemning political violence, advocating for the right to vote, and maintaining the rule of law. They also stress the need to rebuild trust in democratic institutions."*)

(*334*)
```

```mathematica
NotebookFileName[]
ToJekyll["Three LLM Summarization Strategies", "ai mathematica llm"]

(*"/Users/jschrier/Dropbox/journals/mathematica/2023.08.26_llm_summarization_strategies.nb"*)
```

[^1]: Fake news!  You can use retrieve Embeddings directly using [OpenAI Service Connection](https://reference.wolfram.com/language/ref/service/OpenAI.html); `ServiceExecute["OpenAI", "Embedding", ...]`.  This also eliminates the need for the `ParallelMap` call, as the embedding service can take a list of texts as inputs and returns the list of embeddings.   However, I still think it would be a good idea to make this a top-level function, like `LLMSynthesize[]` rather than making it specific to a particular LLM service (I hope that 13.4 will support Claude, local-Llama, etc.)

# Parerga and paralipomena

- (09 Jan 2024) The upcoming Mathematica 14.0 has a new [TextSummarize](https://reference.wolfram.com/language/ref/TextSummarize.html) function that provides control of context padding and window sizes, etc. if you do not want to deal with implementing this yourself.