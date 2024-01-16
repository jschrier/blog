---
title: "A Few of My Favorite Transformer Tutorials "
date: 2023-03-07
tags: machinelearning ml
---

So, you want to learn about [transformer models](https://en.wikipedia.org/wiki/Transformer_(machine_learning_model))?  Here are some of my favorite learning resources to get started:
- Peter Bloem [Transformers from Scratch](https://peterbloem.nl/blog/transformers):  I like how he builds up attention from simple vector dot products (without invoking the query/key/value notation until late in the game after he has given you a firm mathematical understanding of what is going on and why it makes sense). Code examples in pytorch, but easily understandable without it
- Brandon Roehrer [Transformers from Scratch](https://e2eml.school/transformers.html):  I like how he motivates the idea of Markov models for text generation, and then motivates the idea of attention in terms of having variable lookback (without too many parameters).  Also a lucid explanation of positional encoding tricks
- Jay Alammar [The Illustrated Transformer](https://jalammar.github.io/illustrated-transformer/): This seems to be perenially popular on hackernews...I guess if you are into pictures and youtube videos it would be your thing.  Included here for completeness, but I prefer the two above
- My favorite [My Favorite Things](https://www.youtube.com/watch?v=UlFNy9iWrpE) is Coltrane, naturally, but that's a story for another post. 
- *Addendum: 15 Mar 2023*:  [FastGPT](https://ondrejcertik.com/blog/2023/03/fastgpt-faster-than-pytorch-in-300-lines-of-fortran/)--GPT-2 in 300 lines of Fortran.  'Nuff said.
- *Addendum: 15 Jan 2023*: [Random Transformer](https://osanseviero.github.io/hackerllama/blog/posts/random_transformer/) Nicely worked simple example, multiply the matrices yourself for concreteness. 