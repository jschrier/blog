---
Title: "Protein Language Models"
Date: 2023-10-04
Tags: machinelearning ml science proteins llm
---

A chat with [Rudi Gunawan](https://scholar.google.com/citations?user=fx039lUAAAAJ&hl=en&oi=ao) turned me on to the idea of using language models for peptide problems, which came up again in a chat with [Yujia Xu](https://hunter.cuny.edu/people/yujia-xu/) about designer collagen.  **Some notes on protein language models...**

# Model types

Proteins seem like a language problem:  We have an alphabet of amino acids and we have a natural sequence.  So it makes sense to apply the same type of [transformer]({{ site.baseurl }}{% post_url 2023-03-07-A-Few-Of-My-Favorite-Transformer-Tutorials}) type models that are becoming popular for natural language processing (NLP).  If you'd like a more scholarly justification see the brief review by [Ofer et al, "The language of proteins: NLP, machine learning & protein sequences"](https://doi.org/10.1016/j.csbj.2021.03.022) (2021).  This review also goes into other (non-transformer) NLP-style approaches to the problem.

So let's quickly [review some transformer models for natural language processing](https://huggingface.co/docs/transformers/model_summary#natural-language-processing). 

* **BERT** is an encoder-only transformer trained by masking tokens in the input; it's magic power is that it is bidirectional (it tries to predict the missing information from [c-terminus](https://en.wikipedia.org/wiki/C-terminus) to [n-terminus](https://en.wikipedia.org/wiki/N-terminus) **and then** from n-terminus to c-terminus). At the end of this we are left with an embedding that we can use as input to a neural network or whatever to make a prediction.  This makes it natural for infilling tasks (fill in the missing blank), but not well suited for de novo generation tasks

* **GPT-x** (where x>=2 ) is a decoder-only transformer that predicts the next word moving from left-to right. That is to say it has a "causal" autoregressive training objective. Its strength is that this makes it easy to generate next tokens (hence allowing ChatGPT to exist). A weakness is that it lacks the bidirectional context of BERT

* **BART** is a text-infilling model where some text spans are replaced by a single mask token and the decoder predicts uncorrupted tokens.  This might be really interesting for peptides, but I haven't come across it yet.

* [Convolutional neural networks](https://en.wikipedia.org/wiki/Convolutional_neural_network) are old-school (they're not transformers), but can also be used for proteins, but you might try them for pro teins as well... more below..

* [XLNet](https://arxiv.org/abs/1906.08237) (and friends):  an autoregressive language model, but with a training objective which obtains full bidirectional attention by maximizing the likelihood over all permutations of a factorization order.  Authors claim that it performs better than BERT at BERT-like bidirectional tasks.

# Pre-trained protein/peptide language models

In general, the idea of a foundational model is that we pre-train it on a large corpus and then we should be able to apply to new problems---either directly or with a small amount of fine-tuning.  The dominant usage style in many of these science problems is to expose the embeddings (either at the local amino-acid level or at the global whole-sequence level) and then train some model that relates those embeddings to a property of interest.

* [ProteinBERT (2022)](https://doi.org/10.1093/bioinformatics/btac020) is a BERT-style model that is pretrained on 106M proteins (essentially all known...) on two simultaneous tasks: (i) bidirectional language modeling of sequences; and (ii) gene ontology annotations.  Unlike classic Transformers, ProteinBERT outputs local and global representations allowing for both types of tasks.  In the paper they test this on 9 other tasks including secondary structure, disorder, remote homology, post-translational modficiations, fluoresecne, and stability. [Code and model weights can be found online.](https://github.com/nadavbra/protein_bert/blob/master/ProteinBERT%20demo.ipynb). Something that is neat is that the same model weights can be used for any sequence length, so you can in principle support 10^4 AA long sequences 

* [ProtGPT2 (2022)](https://doi.org/10.1038/s41467-022-32007-7) is pretty much what the name implies.  Trained on 50M non-annotated sequences.  Because it is a GPT-flavor model it can generate new protein seuqneces efficiently, and the resulting distributions are consistent with the observed frequences of globular proteins, , amino acid and disorder propensities, etc. even though they are "evolutionarily distant" in an amino-acid change sense.  Model and dataset are on [Huggingface](https://huggingface.co/nferruz/ProtGPT2).

* [ Convolutional autoencoding representations of proteins (2023)](https://www.biorxiv.org/content/10.1101/2022.05.19.492714v4) There are good reasons to eschew transformers---they scale quadratically with sequence length in run-time and memory.  So these folks from Microsoft used an efficient CNN which scales linearly with seuqence length.  The results are competitive to (sometimes superior) to transformers . [Code and pretrained weights online](https://github.com/microsoft/protein-sequence-models)

- [Regresssion Transformer (2023)](https://doi.org/10.1038/s42256-023-00639-z):  This is an XLNet-style transformer.  The core idea is that you concatenate the SMILES string and properties (expressed numerically with a special tokenization scheme).  Then you can fill in `[MASK]` tokens regardless of whether they are structural or property driven.  Applications to drug-likeness, molecular properties, protein sequence modeling, protein fluoresnce/stability (results of the latter are comparable to ProteinBERT mentioned above), and organic reaction yield prediction 

# Stromateis

- [ChemBERTa](https://notebook.community/deepchem/deepchem/examples/tutorials/22_Transfer_Learning_With_HuggingFace_tox21) is a RoBERTa-style transformer model trained on SMILES strings representations of molecules
    - You can get decent performance just by [gzipping the SMILES strings](https://doi.org/10.26434/chemrxiv-2023-v1s2s-v2).  Not quite as good as the most recent ChemBERTa based models, but cheap. 

- [Mass2SMILES](https://doi.org/10.1101/2023.07.06.547963) is a transformer based model that takes MS/MS spectra as inputs and returns SMILES strings and functional group presence/absence
    - Mentions as an aside ways to compare spectra which may be useful for Maurer. Namely [Spec2Vec (Huber et al., 2021)](https://github.com/iomega/spec2vec), [MS2deepscore (Huber et al., 2021)](https://doi.org/10.1186/s13321-021-00558-4), [SIMILE (Treen 2022)](https://www.nature.com/articles/s41467-022-30118-9) 

