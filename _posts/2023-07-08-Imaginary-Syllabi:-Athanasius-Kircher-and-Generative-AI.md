---
title: "Imaginary Syllabi:  Athanasius Kircher and Generative AI"
date: 2023-07-08
tags: llm culture ai jesuits imaginary-syllabi teaching
---

*Premise:*  Consider a general intelligence capable of producing text and images on demand about topics as diverse as chemistry, mathematics, music making, ancient and foreign languages, biblical hermaneutics, the invention of gadgets and scientific instruments, and descriptions of far-away lands.[^1] The output is voluminous, verbose, and presents arguments and sources about things that are true...and also about topics that are mythical or completely fabricated. Are we talking about [ChatGPT](https://writings.stephenwolfram.com/2023/02/what-is-chatgpt-doing-and-why-does-it-work/) or the 17th century Jesuit polymath [Athansius Kircher](https://en.wikipedia.org/wiki/Athanasius_Kircher)? **How might a study of Kircher inform our approach to generative AI? A syllabus...**   

# Backstory and Motivations

I went to the movies with [Joseph Tardio](https://amzn.to/3PNyQ02) to see the new documentary [Umberto Eco: A Library of the World](https://www.nytimes.com/2023/06/29/movies/umberto-eco-a-library-of-the-world-review.html). [Umberto Eco](https://en.wikipedia.org/wiki/Umberto_Eco) was a huge fan of Kircher: [Eco boasted of possessing all but one of Kircher's books](https://lithub.com/umberto-ecos-favorite-books-give-new-meaning-to-the-phrase-deep-cut/) and Kircher has a walk-on roles in some of Eco's novels and scholarly works.  Eco described Kircher as "the most contemporary among our ancestors, and the most outdated among our contemporaries" and in the film, Eco expresses an admiration for which Kircher's writings seamlessly (and perhaps unknowingly to the author) blur fact and fiction.

Discussing the documentary at the bar across the street (while we waited to see Godard's [Le Mépris](https://en.wikipedia.org/wiki/Contempt_(film))...double feature!), I had a thought:[^2] In what ways is criticism of Kircher like the [stochastic parrots](https://dl.acm.org/doi/10.1145/3442188.3445922) critique of generative AI? Like Kircher, [generative AI models are trained on a vast corpus of human knowledge and draw upon this to generate high-probability combinations that are surprisingly good, but equally susceptible to hallucinations](https://writings.stephenwolfram.com/2023/02/what-is-chatgpt-doing-and-why-does-it-work/).  Kircher was clearly learned---he knew 11 languages---but then uses this probabilistic training to go off-the-rails in a totally [bogus deciphering of Egyptian hieroglyphics](https://fathom.lib.uchicago.edu/1/777777122590/).

**How might an engagement with Kircher and his ways of knowing be insightful for students as they try to live in a world with generative AI?** Or:  How might the future that we live in be a future filled with digital Athanasius Kirchers (and would that be a good or bad thing)


# Course topics

- Athanasius Kircher and the Society of Jesus in the 17th Century
- Learn some Latin reading skills (to engage with Kircher's manuscripts)
- Methods of Generative AI: Do some practical stuff with LLMs and Diffusion models and explore limitations
- Do a final project---produce and critique a Kircherian work with Generative AI

# Readings: Books about Kircher

There are a few biographical-ish works on Kircher:

* Godwin, [Athanasius Kircher's Theatre of the World: His Life, Work, and the Search for Universal Knowledge](https://amzn.to/3tJE8ko) --- an examination of Kircher's work, with reproductions of his book etchings across the disciplines 
* Glassie, [A Man of Misconceptions: The Life of an Eccentric in an Age of Change](https://amzn.to/44j2dvq) (2013) -- popular book, had positive reviews in Sci Am, NYT, New Yorker
* Findlen (ed), [Athanasius Kircher: The Last Man Who Knew Everything](https://amzn.to/3D2iwAC) (2004) -- edited volume of essays on Kircher. Probably useful to have on reserve for reference 
* Peters, [The Man Who Knew Everything: The Strange Life of Athanasius Kircher](https://amzn.to/3XEfzQx) (2017) -- my sense is that this is too popular/juvenile for our purposes, based on a skim online 

# Readings: Books by Kircher

- [Monumenta Kircheri](https://gate.unigre.it/mediawiki/index.php/Monumenta_Kircheri)

# Readings: Latin

Given that Kircher's works are all in Latin, and English translations are lacking, it is probably desirable that students build up some very basic Latin reading skills.  Also, [Claude Pavur, SJ](https://amzn.to/3pD6avM) would approve of us continuing to make Latin part of the Jesuit higher-education curriculum, in lines with the *Ratio Studiorum*

Use Orberg's [Lingua Latina](https://amzn.to/44hu1jI) for this purpose and have students work through it over the course of the semester.   

# Readings: Generative AI methods

I'm a contrarian, and the students taking this course aren't necessarily technical, so I would be inclined to use our favorite Mathematica for this purpose.

- Start with Etienne Bernard's [Introduction to Machine Learning](https://www.wolfram-media.com/products/introduction-to-machine-learning/)
- Then move into more [generative things with LLMs](https://www.wolfram.com/wolfram-u/courses/language-integrations/new-llm-functionality-in-wolfram-language/) using the [new LLM functionality in Mathematica 13.3](https://writings.stephenwolfram.com/2023/06/llm-tech-and-a-lot-more-version-13-3-of-wolfram-language-and-mathematica/)
- Demonstrate different strategies of using/building LLMs, for example [retrieval augmented generation]({{ site.baseurl }}{% post_url 2023-08-24-Retrieval-Augmented-Generation %}) or [prompt engineering]({{ site.baseurl }}{% post_url 2023-08-02-Imaginary-Syllabi:-Prompt-Engineering-And-Addressative-Magic %})
- Do some [image generation]({{ site.baseurl }}{% post_url 2023-11-24-Dall-E-3-image-generation-in-Mathematica %})

# Ideas on organization and correspondences between Kircher and topics in a course

- Kircher's Mathematics (e.g., [Arithmologia](https://maa.org/press/periodicals/convergence/mathematical-treasure-kircher-s-arithmologia))  --> basic vectors and matrix operations
- Kircher's [Organum Mathematicum](https://gate.unigre.it/mediawiki/index.php/Athanasius_Kircher’s_Organum_mathematicum._On_the_Evolutionary_Improbability_of_an_Information_Processing_Innovation) --> Intro to computing
- Kircher's [Polygraphia Nova](https://en.wikipedia.org/wiki/Polygraphia_Nova) --> [word/sentence embeddings](https://en.wikipedia.org/wiki/Word_embedding)
- Kircher's writings on China --> [summarization methods]({{ site.baseurl }}{% post_url 2023-08-27-Three-LLM-Summarization-Strategies %})
- Kircher's Hieroglyphic deciphering --> hallucinations
- Kircher's encyclopedism --> [retrieval augmented generation methods]({{ site.baseurl }}{% post_url 2023-08-24-Retrieval-Augmented-Generation %})
- [Noah's ark](https://honorsbookculture.ace.fordham.edu/kirchers-encyclopedic-visions) --> [image generation]({{ site.baseurl }}{% post_url 2023-11-24-Dall-E-3-image-generation-in-Mathematica %})/CLIP/[exploration of latent space](https://writings.stephenwolfram.com/2023/07/generative-ai-space-and-the-mental-imagery-of-alien-minds/)

# Fordham stuff

 - [Eric Bianchi](https://www.fordham.edu/academics/departments/music/faculty-and-staff/eric-bianchi/) in the music department has done work on intellectual and scientific underpinnings of Kircher's musical writing and [supervised a student hypertext project about Kircher's book on Noah's ark](https://honorsbookculture.ace.fordham.edu/kirchers-encyclopedic-visions)
- The Fordham library has at least one Kircher manuscript in its holdings (I saw it in a display case)
 - Run this as an [Interdisciplinary Capstone](https://bulletin.fordham.edu/undergraduate/fordham-college-core-curriculum/capstone-courses/) with history plus philosophy plus computer science plus alchemy

# Parerga and Paralipomena

- Riff on the idea of [word embeddings](https://en.wikipedia.org/wiki/Word_embedding) used in ML and Kircher's [Polygraphia Nova](https://en.wikipedia.org/wiki/Polygraphia_Nova).  c.f. Eco's [The Search for the Perfect Langauge](https://amzn.to/43f3UIX)
    - (31 Dec 2025) [Physics Intuition About Vectors Can Help Us Understand Generative Artificial Intelligence, The Physics Teacher (2025)](https://dx.doi.org/10.1119/5.0149555) --- gives concrete examples about word embedding arithmetic and the limits/relationships to the way vectors are used in physics
- Kircher's [Organum Mathematicum](https://gate.unigre.it/mediawiki/index.php/Athanasius_Kircher’s_Organum_mathematicum._On_the_Evolutionary_Improbability_of_an_Information_Processing_Innovation) was a type of proto-computer, with a human-machine interface for creativity.  A great starting point for an interdisciplinary course.
- The [cat organ](https://en.wikipedia.org/wiki/Cat_organ) would be an excellent addition to a [cat cafe]({{ site.baseurl }}{% post_url 2023-06-27-Great-ideas-from-Korea %})
- [Arca Musarithmica](https://www.arca1650.info/about.html) super cool website implementing Kircher's automatic music compositional theme. 
    - (06 June 2025) A video blogger [built an Arca Musarithmica](https://www.youtube.com/watch?v=ko3kZr5N61I) and describes how it works

- [Deviant interdisciplinarity](https://www.jstor.org/stable/41932111?seq=1) 
- (06 June 2025) 


# Footnotes

[^1]: Any resemblance to the author of this blog is purely coincidental.
[^2]: Not completely spontaneous:  I was on a [committee about the university's response to generative AI](https://www.fordham.edu/media/home/departments-centers-and-offices/office-of-the-provost/pdfs/AI-Visioning-Committee-Recommendations.pdf), and also we were discussing ChatGPT and education at dinner the night before. 
