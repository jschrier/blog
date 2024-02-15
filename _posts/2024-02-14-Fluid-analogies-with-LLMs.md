---
title: "Fluid Analogies with LLMs"
date: 2024-02-14
layout: post
tags: ai leibniz llm gpt4
---

Richard Halpern's *[Leibnizing: A Philosopher in Motion](https://amzn.to/3T8GHGN)* *(2023)* in Chapter 22 discusses [Douglas Hofstadter's](https://en.wikipedia.org/wiki/Douglas_Hofstadter) "[Leibnizian](https://en.wikipedia.org/wiki/Gottfried_Wilhelm_Leibniz)" modes of though.  **Some notes on fluid concepts and how they might relate to LLM use...**

Briefly summarize the following websites:
- https://en.wikipedia.org/wiki/Copycat_(software)
- https://en.wikipedia.org/wiki/Fluid_Concepts_and_Creative_Analogies
- https://www.amazon.com/Surfaces-Essences-Analogy-Fuel-Thinking/dp/0465018475 

> To summarize the content of the websites you've provided, I will access each one and provide a brief overview. Please allow me a moment to gather the necessary information. 
> 
> The webpage from Wikipedia about Copycat (software) describes it as a computational model of analogy-making and human cognition. This model was developed in 1988 by Douglas Hofstadter, Melanie Mitchell, and others at the Center for Research on Concepts and Cognition at Indiana University Bloomington. Copycat is based on the concept of the parallel terraced scan and was originally written in Common Lisp. The software is designed to solve problems by making analogies, such as determining what ijk relates to, given that abc relates to abd. The architecture of Copycat consists of three parts: a slipnet, a working area, and a coderack. The slipnet is an associative network with nodes representing concepts and weighted links indicating relations. The working area is where the codelets build structures and modify activations in the slipnet. The coderack hosts the codelets that run in parallel, and their activity is influenced by the current state of the slipnet.
> 
> Copycat's approach to cognition and analogy-making differs from other cognitive architectures like ACT-R or Soar, and it is considered one of Hofstadter's most popular models. Since the publication of the book "Fluid Concepts and Creative Analogies" in 1995, which describes the work of the Fluid Analogies Research Group (FARG), development on Copycat-like models has continued, with modern implementations in languages like C# and Java.
> 
> Next, I'll provide summaries for the remaining two webpages. 
> 
> The Wikipedia page for "Fluid Concepts and Creative Analogies" details a 1995 book by Douglas Hofstadter and members of the Fluid Analogies Research Group (FARG). The book explores the mechanisms of intelligence through computer modeling and posits that analogy and fluidity are essential to understanding how the human mind solves problems. It also discusses the development of computer programs that exhibit intelligent behavior. The book is significant for being the first ever sold by Amazon.com. The content is formed by revised articles accompanied by introductions from Hofstadter, showcasing the scientific work of him and his collaborators in the 1980s and 1990s. Various AI projects are covered, such as SeekWhence, Jumbo, Numbo, and the Copycat Project, each addressing different aspects of cognition and perception in the domain of artificial intelligence.
> 
> Lastly, I will summarize the Amazon webpage for the book "Surfaces and Essences: Analogy as the Fuel and Fire of Thinking." 
> 
> The Amazon webpage for "Surfaces and Essences: Analogy as the Fuel and Fire of Thinking" presents the book authored by Douglas Hofstadter and French psychologist Emmanuel Sander. The book, published in 2013, explores the premise that analogy is at the core of all thinking. Hofstadter, a Pulitzer Prize-winning author known for his work on human thought and cognition, collaborates with Sander to present a novel perspective on cognition. The book delves into how the human brain makes sense of chaotic stimuli through the use of analogies, which help in recognizing patterns and triggering memories or words. The authors suggest that understanding the role of analogies and categories in thought processes can enhance our thinking abilities. They argue that these mechanisms are fundamental to intelligence, creativity, learning, and expertise, and they support their thesis with a range of examples and analogies. The book spans 592 pages and is written in English, published by Basic Books.
> 
> To summarize all three sources:
> 
> 1. "Copycat (software)" - A Wikipedia page describing a computational model developed by Douglas Hofstadter and others to explore human cognition and analogy-making. The model uses a parallel terraced scan to solve analogical problems and differs from other cognitive architectures.
> 
> 2. "Fluid Concepts and Creative Analogies" - A Wikipedia page outlining a 1995 book by Hofstadter and the FARG, which discusses computer models of intelligence and posits that analogy and fluidity are essential to understanding problem-solving in the human mind.
> 
> 3. "Surfaces and Essences: Analogy as the Fuel and Fire of Thinking" - An Amazon listing for a book co-authored by Hofstadter and Sander, which examines the role of analogy in all forms of human thinking, proposing that it is a fundamental cognitive mechanism.

Describe how these ideas relate to the use of large-language models (such as ChatGPT) to solve problems.  Use analogies.

> The concepts presented in the works related to Douglas Hofstadter's research into analogy-making and cognition have intriguing parallels to the operation of large language models like ChatGPT.
> 
> 1. Copycat (software): The Copycat model, with its parallel terraced scan and codelets, can be likened to the multitude of neural network nodes in a language model that function simultaneously. Just as Copycat uses a slipnet to relate concepts, a language model uses a vast web of weighted connections between words and phrases that it has learned from its training data. The probabilistic nature of Copycat's decision-making process also reflects how a language model generates text based on probability distributions over possible next words or phrases, rather than deterministic rules.
> 
> 2. Fluid Concepts and Creative Analogies: Hofstadter's emphasis on fluid concepts echos the way large language models like ChatGPT handle ambiguous and context-dependent language. In human cognition, we fluidly shift and adapt our understanding of concepts based on context---analogous to how a language model adjusts its predictions by considering surrounding text. Creative analogies are at the heart of problem-solving and innovation; similarly, ChatGPT uses patterns it has learned to draw analogies between different domains, thereby generating novel solutions or creative responses.
> 
> 3. Surfaces and Essences: Analogy as the Fuel and Fire of Thinking: The book's central thesis that analogy is foundational to all thinking mirrors the underlying mechanics of language models which generate text by drawing on analogies inherent in the training data. When a user interacts with ChatGPT, the model draws upon its 'understanding' (analogous to human memory) to find connections between the current prompt and what it has 'seen' before, much like how the authors describe human cognition navigating through a sea of analogies.
> 
> In essence, the way large language models function is reminiscent of Hofstadter's view of human cognition: complex, parallel, and heavily reliant on the formation and use of analogies. These models don't 'think' in the human sense, but they simulate a form of understanding by leveraging statistical patterns in data, akin to how Hofstadter describes the human brain's ability to perceive, categorize, and ultimately make analogies.

Schrier adds:  

- More explicitly, the analogy I see here is in the use of memory storage (either as RAG or something else) and tool use, with the LLM serving the role of a type of working memory.

- The relevance to [Surfaces and Essences](https://amzn.to/48gL074) is to think about prompting strategies that draw on analogies 

- Copycat articles: [https://pcl.sitehost.iu.edu/rgoldsto/courses/concepts/copycat.pdf ]