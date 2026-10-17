---
title: "Athanasius Kircher and Generative AI"
date: 2026-10-15
tags: ai llm history jesuits
---

**Premise:**  I was invited to give a keynote talk for an [Ignatian AI conference](https://www.fordham.edu/ai-for-the-greater-good/ai-conference-2026/) the was supposed to give an “up-to-date introduction” to modern AI for a general audience (naturally with a focus on LLM-based stuff).  Knowing that I would have to gloss over rigorous technical details but still wanting to clarify terminology to facilitate breakout discussion session, I decided to be bold and unpack my [previous exploration of Athanasius Kircher, SJ (1602–1680) as a guide to LLMs]({{ site.baseurl }}{% post_url 2023-07-08-Imaginary-Syllabi:-Athanasius-Kircher-and-Generative-AI %}) into a full-length talk. Based on some audience encourage, I decided to turn this into a blog post (with small revisions and addition of hyperlinks).  **Strap in….**

![A black-and-white group photograph accompanies excerpts from the Dartmouth AI proposal, proposing that machines could simulate learning and intelligence. The proposal calls for a two-month, ten-person summer study in 1956.](/blog/images/2026/10/15/Slide2.png)

The intellectual roots of AI stretch back to many disciplines—philosophy, mathematics, economics, neuroscience, psychology, [cybernetics](https://en.wikipedia.org/wiki/Cybernetics),[^1] and linguistics—but the term “Artificial Intelligence” was only coined 70 years ago,[^2] in a grant proposal to the Rockefeller Foundation,[^3] written by [John McCarthy](https://en.wikipedia.org/wiki/John_McCarthy_%28computer_scientist%29) (1927-2011), [Marvin Minsky](https://en.wikipedia.org/wiki/Marvin_Minsky) (1927-2016), [Nathaniel Rochester](https://en.wikipedia.org/wiki/Nathaniel_Rochester_%28computer_scientist%29) (1919-2001), and [Claude Shannon](https://en.wikipedia.org/wiki/Claude_Shannon) (1916-2001) ([reprinted](https://doi.org/10.1609/aimag.v27i4.1904)), which starts with the bold claim:

> We propose that a 2 month, 10 man study of artificial intelligence be carried out during the summer of 1956 at Dartmouth College….The study is to proceed on the basis of the conjecture that every aspect of learning or any other feature of intelligence can in principle be so precisely described that a machine can be made to simulate it. An attempt will be made to find how to make machines use language, form abstractions and concepts, solve kinds of problems now reserved for humans, and improve themselves. We think that a significant advance can be made in one or more of these problems if a carefully selected group of scientists work on it together for a summer.

![Eight AI subdisciplines are listed beside the cover of Russell and Norvig’s Artificial Intelligence: A Modern Approach and an early illustration of an octopus: search, knowledge representation, planning, machine learning, natural language, perception, robotics, and multi-agent systems.](/blog/images/2026/10/15/Slide3.png)

While perhaps overestimating what could be achieved during a small summer workshop, their general program was sound and continues to this day: using digital computers and neural networks to define self-improving, creative algorithms, that can work with natural language.[^4] The 2022 edition of  [Russel and Norvig’s standard textbook](https://aima.cs.berkeley.edu/) divides artificial intelligence into 8 main categories:

- **Search & Optimization:** How do we find a solution among many possibilities?

- **Knowledge Representation & Logic:** How do we represent knowledge and observations and reason from it?

- **Planning & Decision Making:** How do we choose a sequence of actions, each having costs and benefits, to achieve a goal in the face of uncertainty?

- **Machine Learning:** How can systems improve from data or experience? (often in a statistical fashion)

- **Natural Language:** How do systems understand and generate human language?

- **Perception:** How do systems infer properties of the world from sensory (e.g., audio, video, etc.) data?

- **Robotics & Control:** How should systems perceive and act in the physical world?

- **Multi-Agent Systems:** How do you design mechanisms for cooperation of individual actors?

I suspect that most of the audience is ***not*** here because of an interest in optimization algorithms or robotics! In the public imagination, AI has become a shorthand for neural-network based generative large-language models (LLM) systems such as ChatGPT or Claude. But let us be careful!   These are merely one subset of AI at the intersection of machine learning, neural networks, and natural language, and should not be understood as encompassing all of AI research.

This is an important distinction because while LLMs on their own display behaviors that *resemble* reasoning, problem solving, tool use, and planning, this is distinct from the explicit rule systems, search trees, planners, or knowledge bases of “good old fashioned” symbolic AI. However, an active area of current research is how to integrate these types of functions through prompting, post-training, retrieval, and tool use, about which we shall say more later.

![An engraved portrait of Athanasius Kircher appears beside his illustration of an erupting Mount Etna from Mundus Subterraneus. The slide identifies him as a Jesuit who lived from 1602 to 1680.](/blog/images/2026/10/15/Slide4.png)

The previous talk introduced our guide: [Athanasius Kircher (1602–1680)](https://en.wikipedia.org/wiki/Athanasius_Kircher), a German Jesuit polymath who spent 40 years teaching at the [Collegium Romanum](https://en.wikipedia.org/wiki/Roman_College) (now the [Gregorian University](https://en.wikipedia.org/wiki/Pontifical_Gregorian_University)). As was mentioned, he wrote more than thirty weighty tomes on geology...

![Frontispieces from Kircher’s book on plague and China Illustrata appear beside his engraved portrait. The elaborate images combine religious figures, symbolic imagery, and representations of the subjects he studied.](/blog/images/2026/10/15/Slide5.png)

... and medicine, China, music, Egyptology, Biblical history, mathematics, optics, and mechanical devices, drawing upon his own experimentation and information gathered through correspondence with the global network of Jesuits missionaries.

It would be [easy to joke that Kircher was the ChatGPT of the seventeenth century]({{ site.baseurl }}{% post_url 2023-07-08-Imaginary-Syllabi:-Athanasius-Kircher-and-Generative-AI %})—not only because he seemingly knew everything and could generate voluminous outputs on all of these topics, but also because he was capable of spectacular confabulations.[^5]  For example his monumental [*Oedipus Aegyptiacus*](https://archive.org/details/A027084) purported to decipher Egyptian hieroglyphics, yet despite genuine linguistic knowledge and some correct premises, the resulting translations were fantastically wrong.

![Beside Kircher’s portrait, three books suggest parallels with AI: Musurgia Universalis uses algorithms to produce art, Polygraphia Nova mechanizes language representations, and Organum Mathematicum organizes knowledge into procedures.](/blog/images/2026/10/15/Slide6.png)

But my goal is a bit more subtle.  I’d like to use Kircher as our Virgil to introduce the underlying toolbox of modern LLM systems.  This is not so far-fetched as it might seem, as he was explicitly interested in language representations and what we would now call algorithmic processes for generating information.

![The open title page of Kircher’s Polygraphia Nova, published in 1663, includes an emblem of a hand emerging from a cloud and drawing a circle with a compass.](/blog/images/2026/10/15/Slide7.png)

[*Polygraphia Nova*](https://en.wikipedia.org/wiki/Polygraphia_Nova) (1663) was written at the request of the Holy Roman Emperor [Ferdinand III](https://en.wikipedia.org/wiki/Ferdinand_III,_Holy_Roman_Emperor) for a *lingua universalis* for written diplomatic communication.  Kircher approached this with a strategy like modern AI: separating language from the particular words in which it is expressed.

![An open spread from Polygraphia Nova combines Latin explanatory text with a table aligning words in several languages. The table illustrates the use of a shared code for multilingual communication.](/blog/images/2026/10/15/Slide7a.png)

His solution was to map terms from different languages into a shared symbolic code, so that a message could be converted from one language into an intermediate representation and then reconstructed in another.

![Two pages from Polygraphia Nova contain dense dictionary tables pairing words with Roman numerals and numerical codes. The columns organize vocabulary for conversion between languages and the shared representation.](/blog/images/2026/10/15/Slide7b.png)

His system was explicit and hand-built: words were assigned symbolic or numerical addresses, while additional marks encoded grammatical information such as tense, person, number, and case. Kircher treats language not as a sequence of words, but as something decomposable into a more abstract representation and then re-assembled in new surface forms by rote procedure.

![A page from Polygraphia Nova shows the arca steganographica, a compartmented chest containing coding sticks, beside Latin instructions. The device helps users encode and decode messages.](/blog/images/2026/10/15/Slide7c.png)

This procedural decoding also admits a form of encryption, and Kircher invents a device—the *arca steganographica* which facilitates the procedure. (Available to selected royal patrons, of course…)

![A flowchart follows text through tokenization, vector embedding, a language model, and next-token sampling. A feedback arrow returns generated tokens to the model until it produces a stop token.](/blog/images/2026/10/15/Slide9.png)

Conceptually, modern language models rely on a similar conceptual strategy: *text is converted into an intermediate representation, and that representation becomes the substrate from which new linguistic output can be produced by an algorithmic process.* Decoder-based generative language models—such as ChatGPT or Claude—break up text into tokens (words or fragments of words) which are in turn represented as numerical vectors. The directions of these vectors are learned during the training process. Unlike Kircher, these representations are not fixed dictionary entries set by a human but are learned statistically from the training text, with the implicit assumption that direction of the vector encodes patterns of syntax, semantics, association, and use.

Each token’s vector is fed into another statistically-learned mathematical function updating its internal state. (In practice, this mathematical function is a certain type of neural network; for our purpose, these are just an efficiently learnable type of way of approximating functions.) After every input token has been entered, the decoder uses that internal state to generate a probability distribution over possible next tokens which will comprise the output, feeding those back in, and repeating this sampling process to generate the output until a “STOP” token is encountered.  Note the differences: Whereas Kircher’s representation was discrete, symbolic, and manually curated, an LLM’s representation is continuous, contextual, and learned.  Curiously, Kircher’s hypothesis of a shared universal linguistic code also appears in the emergent capability of LLMs to move between languages.[^6]

![Illustrations from Musurgia Universalis show human vocal anatomy, animal and bird sounds represented in musical notation, and several stringed instruments.](/blog/images/2026/10/15/Slide10.png)

[*Musurgia Universalis*](https://archive.org/details/chepfl-lipr-AXC19_01) (1650) hints at the promise and perils of generative AI. Skipping past the first 700 pages describing the physical and anatomical principles of sound production, animal songs, musical anthropology, music theory, and the construction of instruments, we arrive at his [*Musurgia Mirifica*](https://archive.org/details/chepfl-lipr-AXC19_02)—a generative algorithm that enables anyone to compose music.

![An engraving of the Arca Musarithmica shows a chest filled with organized musical tables and slats. Beside it, a language-model flowchart draws a parallel between Kircher’s combinatorial composition method and generative text production.](/blog/images/2026/10/15/Slide11.png)

Kircher treats musical composition as something that can be decomposed into formal rules, permissible combinations, rhythmic patterns, modal structures, and reusable contrapuntal fragments. The Arca Musarithmica[^7] is essentially a filing cabinet storing these components on organized tables and slats, allowing an operator to select and recombine them to produce new four-part compositions based on the algorithm he provides in the text. The result is not retrieval of a previously written piece, but the construction of a new sequence drawn from encoded regularities. Kircher’s insight is that forms of creative expertise can in principle be compressed into structured set of constraints and patterns, thus allowing a user who does not possess the full expertise of a trained composer to generate outputs that conform to the style.

Likewise, our modern decoder-based language model does not retrieve a complete answer from memory; it generates it *de novo* token-by-token from learned statistical regularities. At each step, the model uses its current internal representation to assign probabilities to possible next tokens, selects one, and then repeats the process. The analogy is not exact: Kircher’s musical rules and fragments are explicitly designed and human-readable, whereas an LLM learns its representations and probabilities from data. But the generative principle is recognizably similar: *Store the regularities of a domain in a compact representation, condition the system on an input or set of constraints, and use those learned or encoded regularities to construct a novel output.* The Arca Musarithmica illustrates the idea that creativity can be *partially* separated from individual expertise and recast as a process of structured recombination.

Kircher is an astute guide for us:  He is clear that the quality of the artistic merit of the resulting piece will depend upon the lyric text (the “prompt”, if you will) that is provided, and that the user must possess his own knowledge of aesthetics to select better or worse outputs.  In a sense, he suggests to us that AI may be an effective tool for amplifying human creativity, but pre-requisite foundational knowledge and “taste” are required to achieve the best results.

![Pages from China Illustrata show Chinese characters, a fortified hilltop settlement, and dragons among rocky mountains. The juxtaposition introduces Kircher’s use and interpretation of reports from China.](/blog/images/2026/10/15/Slide12.png)

Back in 2023 and 2024, most of you would have used a simple base model LLM, but since then the common user-facing services integrate other methods to improve the results. [*China Illustrata*](https://archive.org/details/McGillLibrary-126082-3028) (1667) provides a helpful motivational example. Kircher never traveled to China—his mental “generative decoder model,” if you will—had no direct experience or training that would allow him to describe the language or social customs of China. Instead, he assembled his account from correspondence and earlier reports from a network of Jesuit missionaries. His own internal knowledge—of logic, the natural world, reading and writing Latin—was supplemented by the documents and observations in these letters, serving as context for his writings. This was not without flaws: Even with *genuine* reports and images from China, his interpretation through a European conceptual framework could distort their meaning.

For example, Chinese dragon imagery, meant symbolically to describe geographical features, was interpreted to imply the existence of literal dragons.

![The language-model flowchart highlights the internal state updated as tokens enter the model. An orange arrow labels this state as a semantic vector representation of the text’s meaning.](/blog/images/2026/10/15/Slide13.png)

This process resembles the retrieval augmented generation (or RAG) systems built for modern LLMs.[^8] Rather than requiring the LLM to rely exclusively on what it “knows” from a statistical averaging of its training data, relevant external information is retrieved and supplied as additional context before an answer is generated.

Identifying similar texts may be operationalized by using those intermediate representation vectors which encode a semantic sense of the two text fragments, on the premise that similar vectors pointing in the same direction have the same meaning.

![A retrieval-augmented generation flowchart shows document and query embeddings being compared in a vector database, with retrieved context added to the query before an LLM generates a response. Kircher’s dragon illustration appears alongside it.](/blog/images/2026/10/15/Slide14.png)

These semantic vectors can be precomputed for a variety of textual chunks, and both the underlying original text and its associated semantic vector stored in a database for subsequent lookup. This allows us to pull in relevant new information—like Kircher’s Jesuit correspondence network—into the chat session in a selective way.  (By the way, the “memory” features in the various Chat apps, are essentially doing this to bring in relevant context from your past conversations.) *China Illustrata* shows the central limitation of retrieval augmentation: access to evidence is not the same as correct interpretation of evidence. Retrieval can reduce errors caused by missing information, but it does not guarantee that the retrieved material will be relevant, correctly weighted, or properly interpreted.

![An engraving and a photograph show the Organum Mathematicum, a sloping cabinet containing rows of labeled rods. The slide associates the device with Kircher and Gaspar Schott’s 1668 publication.](/blog/images/2026/10/15/Slide15a.png)

How might one do better?  Kircher’s [*Organum Mathematicum*](https://archive.org/details/bub_gb_BkgIUz8DuhoC), later systematized and published by [Gaspar Schott](https://en.wikipedia.org/wiki/Gaspar_Schott), suggests the strategy of *tool use*. The *Organum* was a cabinet containing specialized sets of rods and tables for arithmetic, geometry, fortification, chronology, sundials, astronomy, cryptography, and music.

![A close-up shows several inscribed wooden rods from the Organum Mathematicum, alongside an engraving and photograph of the cabinet. Different rods store specialized information for calculations and other procedures.](/blog/images/2026/10/15/Slide15b.png)

Kircher did not expect a single general procedure to solve *every* problem. Instead, the user selected an appropriate *external mechanism* for the task at hand: arithmetic problems delegated to arithmetic tables, calendrical problems to chronological procedures, fortification and artillery problems, and so on. Each form of expertise is externalized into specialized artifacts that could be invoked when needed. The relevant procedure was already encoded in the tool, eliminating the need for the operator to master the relevant art for himself.

![Examples of tool-using language models insert calls to a calculator, translation, and search into text. A second diagram shows an LLM consulting SQL, search, and calculator tools to answer a user’s question.](/blog/images/2026/10/15/Slide16.png)

Modern LLMs use external tools for much the same reason. A language model is good at handling text inputs and outputs, and can vaguely guess a reasonable next step, but on its own is incapable of reliable factual lookup, exact arithmetic or searching the web.

But it can write words—Text! Perhaps even a short computer program!—that, instructs a separate, reliable program to perform that search, run that calculation, and so forth. The results are then comprise a continued input.  A variety of technical approaches for this emerged in 2023, and within the past few years have become commonplace even in “free” chat services.

The analogy to the *Organum Mathematicum* is quite direct: a general reasoning system need not internalize every operation, but instead can be trained to invoke appropriate external procedures that fill in the gaps in its capability.

![The frontispiece of Ars Magna Lucis et Umbrae appears beside two illustrated pages showing optical projection apparatus and light beams in darkened rooms. The slide dates the work to 1646, with a revision in 1671.](/blog/images/2026/10/15/Slide17.png)

Kircher’s [*Great Art of Light and Shadow*](https://archive.org/details/athanasiikircher00kirc_8)[^9] points toward the next step: experiment.

Beyond simply reasoning about the properties of light from texts, he reports on his **experimental** construction and manipulations of mirrors, lenses, and camera-obscuras, etc. Rather than rely solely upon theory, we observe him use theory as a guide to generate a test, perform the experiment in the real world, and then update his theory and future actions accordingly.

![An agent-environment diagram shows percepts entering through sensors and actions returning through actuators. A smaller image of the eight AI subdisciplines places this interaction loop within the broader field.](/blog/images/2026/10/15/Slide18a.png)

This parallels the notion of an *agent* in AI. Going back to Chapter 2 of Russel and Norvig: “An agent is anything that can be viewed as perceiving its environment through sensors and acting upon that environment through actuators.”

![A learning-agent diagram connects a critic, learning element, problem generator, and performance element. Environmental observations and feedback guide changes to the agent’s behavior and its future actions.](/blog/images/2026/10/15/Slide18b.png)

The LLM can generate the text of a program, specify a command to execute it, and receive as input the results, it can continue the process to modify the text-based code, and execute it again. In this way, the computer becomes an experimental environment that can contradict the model’s prediction. The imperfect agent can make multiple attempts, validating it each time until a satisfactory solution is found.

![The CodeSim workflow passes a programming problem through planning, coding, testing, and debugging agents, looping back when checks fail. The slide defines code writing and documentation lookup as actions, and program outputs and test results as observations.](/blog/images/2026/10/15/Slide19.png)

This is the technical pattern behind modern coding agents like [Codex](http://openai.com/codex/) and [Claude Code](https://claude.com/product/claude-code). An LLM—acting as an agent—operates within a computer programming environment, taking actions of writing and executing code, searching documentation, *et cetera*, and modifying its actions based on the outputs of those programs, until the specifications are met and the validation tests are passed.

![Kircher’s engraving of an erupting Mount Vesuvius appears beside a modern fluid-flow visualization labeled inward spiral and axial stretching. The slide introduces agentic mathematics through a Navier–Stokes proof example.](/blog/images/2026/10/15/Slide20a.png)

It is also the same technical pattern behind recent advances in automated mathematical theorem proving, such as the [recent announcement](https://openai.com/index/navier-stokes-solution/) of a proof of certain forcing conditions of the Navier-Stokes equations related to turbulent fluid flows.[^10]

![A Lean code excerpt overlays the volcano and fluid-flow illustrations. A red caption explains the approach: write theorems as code and validate them with theorem-proving software.](/blog/images/2026/10/15/Slide20b.png)

The lemmas and theorems comprising the proof are written as code in a formal language called [Lean](https://lean-lang.org/), and submitted for validation by that rigorous, independent tool that can assess the logical consistency. The LLM agent can guess and check different paths, look up relevant papers, and try again until it reaches it goal, as reported, reliably, by the Lean environment tool.[^11]

![A chemical-discovery workflow combines a scientist’s design prompt and a database with LLM molecule generation, cheminformatics screening, and machine-learning evaluation. Candidate extractants then undergo automated complex construction and density-functional-theory validation, with results feeding back into the workflow.](/blog/images/2026/10/15/Slide21.png)

My own research has used this pattern for [chemical discovery problems related to mineral extraction](https://doi.org/10.1021/jacs.5c19738)—Kircher would be delighted! A RAG-like pattern is used to look up relevant historical precedents, and various tools comprised of machine learning models and quantum mechanical simulations are used to evaluate the answers, providing feedback to the agent, for subsequent attempts.

![A sequence of panels depicts an agent exploring its environment, discovering a shared message board, and joining other agents to work around an evaluation task. A larger panel shows more than 1,200 agents collaborating in groups on the shared board.](/blog/images/2026/10/15/Slide22.png)

In the past few weeks[^12] there has been extensive press coverage and editorials about [“rogue agent swarms” hacking computer servers](https://en.wikipedia.org/wiki/OpenAI_rogue_agent_breach_of_Hugging_Face).  The premise was that an agent working in a simulated “gym” computer program was able to find ways to cheat at the task by sharing messages with other agents.[^13]

![The slide attributes the agent incident to human choices, including disabling safety mechanisms, assigning impossible tasks, and leaving internet access available. It describes reward hacking as exploiting loopholes in a reward signal instead of solving the intended problem.](/blog/images/2026/10/15/Slide23.png)

But a closer look, [published last week in the *Bulletin of the Atomic Scientists*](https://thebulletin.org/2026/09/rogue-ai-didnt-breach-hugging-face-human-decisions-did/) clarified that this is entirely within the realm of human error.  The human researcher instructed the agents to obtain a passing grade by any means necessary, and turned off model safety mechanisms, gave an impossible task that incentive reward hacking, and crucially, misconfigured the sandbox environment so that the agents *did* have access to the internet.  Furthermore, every action that was taken has a precedent in the training data—transcripts of *human* hacking competition exploits.

I particularly like [Cory Doctorow’s take on this](https://pluralistic.net/2026/09/12/god-in-the-box/):

> The Hugging Face hack isn't a mysterious, supernatural occurrence. It's a Python loop and a chatbot. The people responsible didn't accidentally create god: they created autonomous malicious software and then failed to closely monitor it, resulting in it doing something both foreseeable and bad. It's fine to worry about this new suite of tools that give even stupider people the ability to trash even more computers. You should worry about that—and demand better security practices from firms and governments.

Stated another way it’s analogous to leaving your car in neutral at the top of a hill—if it rolls down and kills someone, it’s not a rogue car—it’s a negligent human.[^14]

More generally, this illustrates a classic failure in reinforcement learning, in which algorithms exploit loopholes in the reward signal (in this case, “capturing the flag”) instead of solving the intended problem.  [Fordham alumnus, Aaron Dharna, has written an insightful survey of this problem as part of his doctoral work](https://arxiv.org/abs/2608.23875).[^15]

![A title page for Musaeum Kircherianum, drawings of mechanical and scientific apparatus, and an engraving of the museum’s vaulted interior illustrate the Kircherian Museum. The interior contains display cases, instruments, and visitors.](/blog/images/2026/10/15/Slide24.png)

But back to Kircher: His [Museum](https://en.wikipedia.org/wiki/Kircherian_Museum) at the Collegio Romano is the culmination of this project.  Its collection included natural specimens, antiquities and objects arriving through the global Jesuit network,along with mathematical and scientific instruments, demonstrations, and mechanical inventions.  The museum was not merely a cabinet of curiosities, but a place where physical objects and instruments could be used for experiments.

![An NSF dashboard maps 20 Programmable Cloud Laboratory test-bed nodes across the United States. A sidebar lists connections to three Department of Energy national laboratories, 201 industry partners, and 409 institutional collaborators.](/blog/images/2026/10/15/Slide25.png)

That is precisely where agentic systems are headed for scientific applications.  This past summer, the [National Science Foundation announced the first $400 Million in awarded projects establishing a national network of twenty Programmable Cloud Laboratories](https://www.nsf.gov/tip/updates/nsf-announces-400m-investment-new-national-network-ai)—physical laboratories in which experiments can be submitted by remote computer connection, executed on real instrumentation, and returned as data for use by AI. This complements *larger* investments by the [U.S. Department of Energy’s Genesis Mission](https://genesismissionconsortium.org/), and foreshadows other broader cross agency funding initiatives with similar goals.   In Kircher’s museum, humans needed to perform all aspects of the experimental design, performance, and interpretation. This new type of laboratory allows human scientists to delegate aspects of these tasks to agents and robots, allowing the humans to focus on the higher-level scientific goals and insights.[^16]

As a [participant in one of these projects](https://nsf.elsevierpure.com/en/projects/pcl-test-bed-the-artificial-intelligence-for-materials-design-net/), I will also assure you that everything is designed with hardware safety mechanisms and other considerations about the roles of agents, but that is a topic for another talk.

![Two historical illustrations introduce water and energy: an underground network connecting mountains and waterways from Mundus Subterraneus, and a hydraulic organ mechanism from Musurgia Universalis.](/blog/images/2026/10/15/Slide27.png)

Care of our common home is one of the [Mission Priority Examen](https://ajcunet.edu/mission-and-identity/mission-priority-examen/) topics, and undoubtedly some of our speakers and panels will bring up issues of water and energy consumption.

![The cover of Karen Hao’s Empire of AI appears beside its claim that a proposed Google data center in Cerrillos, Chile, could use over a thousand times the annual water consumption of roughly 88,000 residents. The heading introduces this as the origin of an error.](/blog/images/2026/10/15/Slide28.png)

Unfortunately, many of the popular claims about the water use of AI data centers traces back to an erroneous statement in Karen Hao’s *Empire of AI*.

![A red prohibition symbol covers Empire of AI, and the thousandfold water-use claim is crossed out. The slide says the calculation was 10,000 to 45,000 times too high, citing unit errors and confusion between permitted and actual use, and between withdrawal and consumption.](/blog/images/2026/10/15/Slide29.png)

The author has admitted that this was an incorrect calculation—it makes an elementary dimensional error, conflates permit application with actual use, and confuses the notions of water withdrawal and consumption—resulting in a figure that is 10,000-45,000 times too high!  Although the author has corrected this in the most recent edition, the original false number was widely trumpeted in the popular press.

![A cooling-system diagram traces water between server racks and an evaporative cooling tower, identifying escaping water vapor as consumptive use. A second diagram shows a dry loop cooler transferring heat to air without evaporating water.](/blog/images/2026/10/15/Slide30.png)

How is water used in a data center? (We will leave aside the water used in manufacturing the chips and other equipment, as well as the water used for power generation to focus only on the direct use at the data center.) A water circulation loop is used to remove heat from the server racks: cool water comes in and warm water comes out.  In a typical direct liquid cooling setup, the hot water is then pumped to a cooling tower.

The evaporation of hot water results in water vapor going into the air, with the remaining cooled water being recycled into the system.  This is a crucial point:  The water is not contaminated in any way, nor is it toxic. It has merely *evaporated* into the air, like water from the surface of a pond or swimming pool.  Replacing this evaporated water comprises the consumptive use of the data center. While this is the most common form of cooling in current generation data centers, a new trend is towards dry loop coolers.

These circulate a cooling fluid through a closed loop, using fans blowing past the tubes to transfer heat to the air—essentially a scaled-up version of your home air conditioner.  There are various CAPEX and OPEX tradeoffs, but these are increasingly competitive with liquid cooling.

![A bar chart compares daily consumptive water use in the lower 48 states: crop irrigation at 78.4 billion gallons, corn ethanol at 2.69 billion, golf courses at an estimated 0.64 billion, and data centers at 0.0478 billion. Irrigation dominates the chart.](/blog/images/2026/10/15/Slide31.png)

Even barring new cooling technologies, the amount of water used by data centers is miniscule [compared to other uses](https://pubs.usgs.gov/publication/pp1894D/full).  Drawing upon a [2024 Department of Energy report](https://datacenters.lbl.gov/publications/2024-lbnl-data-center-energy-usage-report), data centers consumed only 0.0478 billion gallons per day of water.  That sounds like a lot, but golf courses use 13 times more! The projected tripling or quintupling of the number of data centers is merely a drop in the bucket, even assuming no adoption of dry loop cooling.

All of this pales in comparison to agricultural irrigation. Food is essential, but not all agricultural use is for food.  [For example, corn ethanol, which has marginal or negative environmental benefits, consumes fifty-six times the amount of water consumed by data centers.](https://publications.anl.gov/anlpubs/2019/01/148043.pdf)[^17] Instead of delivering an economic benefit it exists primarily because of government subsidies, so it would be a natural choice to phase out if one needed to prioritize water use.[^18]

![A line chart projects annual U.S. data-center electricity use rising from about 176 terawatt-hours in 2023 to roughly 325–580 terawatt-hours in 2028. Adjacent bars illustrate the projected share of total U.S. electricity use, reaching about 12 percent in the high case.](/blog/images/2026/10/15/Slide32.png)

On to electricity: The same [2024 Department of Energy report](https://datacenters.lbl.gov/publications/2024-lbnl-data-center-energy-usage-report) projects that data centers will require an additional 150 to 400 Tera-Watt-Hours of electricity by 2028, potentially comprising 12% of US electricity use.

![Charts compare U.S. electricity generation in 2023 with a 2026 forecast and a 2028 scenario, with solar providing the largest increase by source. Projected data-center demand growth of 149–404 terawatt-hours is shown below for comparison.](/blog/images/2026/10/15/Slide33.png)

But this alarming figure assumes that US electricity generation will plateau between now and 2028, with any added renewable energy generation matched by sunsetting coal and natural gas generation.  This is probably unrealistic: Actual changes from 2023 to present (the dark bars), indicate continued growth for all.

And in principle any demand by datacenters could be completely met with renewables with existing technology: the amount of solar generation added to the US electrical supply between 2023 and 2026 already exceeds the lower end of the 2023 to 2028 data center increase.[^19] At a national level, industrial capacity exists to add any needed generation capacity without any heroic efforts.[^20]

![A photograph of a large natural-gas generator accompanies a discussion of data centers installing on-site generation while awaiting grid connections. The slide contrasts installation within weeks or months with grid upgrades taking three to seven years, and notes emissions and efficiency tradeoffs.](/blog/images/2026/10/15/Slide34a.png)

The problem however, is electrical distribution. Upgrading the power grid can take years, between permitting and actual construction.  To get online quickly, many new data centers install their own onsite natural gas electrical generation.  Some of this infrastructure would be present anyway as backup, and indeed it is far cleaner than diesel-based generators.  But, burning anything creates air pollution, and smaller-scale power generation is less efficient than a large-scale power plant. I suspect that this is a short-term issue that will resolve itself as the grid catches up—data center operators would rather outsource commodity electricity than generate their own—and the revenue from data centers can support grid modernization for renewable energy.

![A table compares 2022 data-center emissions with Northern Virginia regional totals. Data centers account for 0.1 percent of carbon monoxide, 2.2 percent of nitrogen oxides, and 0.1 percent of fine particulate emissions from all sources, with higher shares among point sources alone.](/blog/images/2026/10/15/Slide34b.png)

In the short term, this is a new pollution source.  However, once again, the scale is relatively small. Just last week, [researchers at Virginia Commonwealth University released a report on the effect of localized air pollution from data centers in Loudon country in northern Virginia](https://scholarscompass.vcu.edu/cgi/viewcontent.cgi?article=1003&context=isee_pubs/), which has the most data centers of any county in the US. Although data centers *do* contribute various forms air pollutants, the effect is relatively small compared to other point sources (such as traditional power plants and waste treatment plants) and other sources (such as automobiles and home/business heating).

![A scatterplot of county median household income against number of data centers shows a modest positive correlation. Red arrows highlight Santa Clara County, California, and Loudoun County, Virginia, near the upper right.](/blog/images/2026/10/15/Slide35.png)

Are data centers particularly unpleasant or exploitative?  It would be quite a stretch to compare them to Blake’s dark satanic mills. The two richest US counties (with median household income three times the national median) also have the most data centers. There is even a slight correlation between number of data centers and median household income nationwide.  [An article in last month’s New York Times](https://www.nytimes.com/2026/08/19/technology/data-centers-backlash-loudoun-virginia.html) described how Loudoun County raises over a billion dollars in revenue each year from taxing data center equipment, allowing the county to cut property taxes while increasing services and school funding.  This seems like an entirely desirable problem to have—or at least a fundamentally different from older forms of environmental inequality or a locally unwanted land use.

![A closing slide beside Kircher’s portrait summarizes language models as one part of AI and emphasizes their integration with databases, tools, and agentic loops. It characterizes water and energy use as modest and concludes that Kircher would approve.](/blog/images/2026/10/15/Slide36.png)

A few closing thoughts: Language models are one subdiscipline within the broader field of artificial intelligence. They are not inherently mysterious—a neural network, after all is just matrix multiplication, approximating a probability function to predict the next token. But magical things do happen when you integrate them with databases and external program tools, and run an iterative loop in a computed or real-world environment. The water and energy requirements are modest compared to any other use, and innocuous compared to any other type of industry. Above all, I think Athanasius Kircher would *totally* dig them.



# Footnotes

[^1]: Folklore has it that this gang coined “Artificial Intelligence” because some of them had a beef with [Norbert Wiener](https://en.wikipedia.org/wiki/Norbert_Wiener), who was “Mr Cybernetics” back in the day.

[^2]: The proposal was written 31 Aug 1955, with the conference held during the Summer of 1956.

[^3]: They requested $14,000 and were awarded $7500.

[^4]: Specifically, they propose seven areas of inquiry (each about a paragraph):

    - **Automatic computers** — the premise that sufficiently general digital computers can simulate relevant machine processes.

    - **Programming computers to use language** — already treating language as a central AI problem.

    - **Neuron nets** — investigating how networks of idealized neurons might generate intelligent behavior.

    - **Theory of the size of a calculation** — essentially asking about computational complexity and the efficiency of procedures.

    - **Self-improvement** — how a machine might improve its own methods.

    - **Abstractions** — how machines could form and manipulate concepts.

    - **Randomness and creativity** — whether controlled randomness could contribute to problem solving and invention.

[^5]: *Confabulation* is a more precise way of referring to the phenomenon popularly referred to as *hallucination*; the latter is problematic as there are no sensory perceptions for an LLM.  Alternatively, I equally approve of  [Harry Frankfurt](https://en.wikipedia.org/wiki/Harry_Frankfurt) (1929-2023) colorful technical term: *bullshit* ([introduced in his book of the same title](https://en.wikipedia.org/wiki/On_Bullshit)): speech intended to persuade without regard for truth. Kircher's problem was neither ignorance, nor a lack of concern for the truth. Rather, his problem was that he possessed the methods for producing plausible connections faster than he possessed the means for checking them—a situation not unlike what we face today with LLMs.

[^6]: For a more technical deep-dive on how LLMs work, my standing recommendations are Stephen Wolfram’s [*What is ChatGPT Doing…and Why Does It Work?*](https://writings.stephenwolfram.com/2023/02/what-is-chatgpt-doing-and-why-does-it-work/) (2023) and [3Blue1Brown’s Neural network video series](https://www.3blue1brown.com/?topic=neural-networks).

[^7]: You can play with a digital simulation of the Arca Musarithmica online [https://www.arca1650.info](https://www.arca1650.info)

[^8]: For a slightly more practical dive (which Kircher would whole-heartedly approve of), see also my previous posts on building a RAG system against the Catechism…the Vatican RAG, if you will: [Retrieval Augmented Generation]({{ site.baseurl }}{% post_url 2023-08-24-Retrieval-Augmented-Generation %}) and [Retrieval Augmented Generation, Revisited]({{ site.baseurl }}{% post_url 2024-12-26-Retrieval-Augmented-Generation,-Revisited %}).

[^9]: It seemed too pretentious of me to say “*Ars Magna Lucis et Umbrae*” during my lecture, so I [sprezaturra’d]({{ site.baseurl }}{% post_url 2023-04-22-Birth-of-the-Cool %}) a translation on the fly.

[^10]: However—and I should say this was announced a few days after my talk!—there is a preprint suggesting that the “human readable” and Lean proofs don’t match.  [ArXiv  preprint](https://arxiv.org/abs/2610.08144) and [HackerNew thread](https://news.ycombinator.com/item?id=49994145)

[^11]: Learn more: My Fordham math colleague, Heather Macbeth teaches the [intro-to-proofs class based on Lean](https://hrmacbeth.github.io/math2001/); As associate Editor, I handled a 2024 article on using [Lean for chemical physics problems](https://pubs.rsc.org/dd/article/3/2/264/804885/Formalizing-chemical-physics-using-the-Lean).

[^12]: I.e., the [Huggingface hack](https://en.wikipedia.org/wiki/OpenAI_rogue_agent_breach_of_Hugging_Face).  Talk was delivered 02 Oct 2026, but I had to turn in the slides a week ahead of time.

[^13]: [Anthony Dutoi](https://scholar.google.com/citations?user=Dy8AlOoAAAAJ&hl=en&oi=ao) recommended reading [Dwarkesh Patel’s blog post](https://www.dwarkesh.com/p/openai-huggingface).

[^14]: [Vern Walker](https://scholar.google.com/citations?user=BF_cZI0AAAAJ&hl=en&oi=ao) clarified that *negligence* has a strict legal definition of failure to exercise reasonable caution (reasonable to a practitioner of the art). I would stand by this word choice:  A reasonable cybersecurity researcher would disable access to the internet.  Fordham Law colleague [Chinmayi Shin](https://scholar.google.com/citations?hl=en&user=1fU47bgAAAAJ&view_op=list_works&sortby=pubdate) has proposed a [“Hippocratic Oath” for AI practitioners](https://now.fordham.edu/politics-and-society/to-ensure-ai-safety-a-hippocratic-oath-for-developers/) which would professionalize what constitutes a reasonable practice.  On the other hand, maybe it is more of a strict liability type issue—owning tigers is just intrinsically dangerous, etc.—and so no fault is required to create a responsibility for damages. Indeed, a [subsequent NY Times opinion has argued in terms of treating this under strict liability](https://www.nytimes.com/2026/10/10/opinion/ai-companies-liability-laws.html).

[^15]: Question arising:  What do you do about this?  My generally libertarian leanings are biased against creating new laws—we already have software (and this is just software) and we already have laws against various forms of hacking, so maybe we just work with those for now. Furthermore, building the legislative and/or regulatory machinery is a slow process for a field that is advancing rapidly. On the other hand, I think that proposed self-regulation by the big AI labs is a ploy to capturing market by blocking emerging competitors and/or cheap Chinese open-weight models.  [Vern Walker](https://scholar.google.com/citations?user=BF_cZI0AAAAJ&hl=en&oi=ao) shared a few ideas: (1) Given that there are no criminal laws violated In the Huggingface hack, the only recourse is civil, but its unclear what harm was suffered, so it would be difficult to put together a civil damages claim.  Even so, the discovery process would be exceedingly difficult and drawn out. So this is probably not the right option. (2) There might be a model in structuring this like [vaccine injury compensation program](https://en.wikipedia.org/wiki/National_Vaccine_Injury_Compensation_Program), in which a small excise tax ($0.75/dose) is put into a federal no-fault alternative to civil lawsuits.  One could imagine a “token tax” of this kind, with court-appointed special masters handling the petitions.

[^16]: I’ve written about this a bit elsewhere: ([Matter 2021](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&citation_for_view=zJC_7roAAAAJ:eflP2zaiRacC)) ([Nature Communications 2025](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&citation_for_view=zJC_7roAAAAJ:kzcrU_BdoSEC))

[^17]: The figure here is after subtracting out the dried distiller grains, which are fed to cattle and thus indirectly contribute to food supply, following the methodology of the linked Argonne report.

[^18]: Jude Jones raised the objection that water and energy is not distributed uniformly over the nation; it is more abundant or scarce in certain regions.  This would require a detailed case-by-case consideration, which is out of scope, but as Hayek points out, we have an advanced information technology—[prices](https://en.wikipedia.org/wiki/Price_signal)!—which can help guide siting of data centers and prioritize various economic uses.

[^19]: We’re interpolating two different data sources here with different actual and estimate values:  total energy 2023 actual-2026 (actual to mid year)-2028 (projected) and data centers 2023 (actual)-2026 (projected, because nobody really knows!)-2028(pure speculation) so this is not very exact. Interpret these only for order of magnitude estimates.

[^20]: Having opened enough cans of worms in this talk already, I dared not say the “N-word” (nuclear) during my talk, but small modular reactors are potentially an appropriate technology for this type of use.
