---
title: "Properties of Random Peptides"
date: 2023-02-10
tags: science statistics biology
---

A seminar talk by [David Eliezer](https://vivo.weill.cornell.edu/display/cwid-dae2005) got me thinking about the properties of random peptides.  Do they fold? If so, into what?  Are they instrinsically disordered?  **As it turns out, there is some literature on this...**

# What do you mean by random?

If we want to generate a random peptide, what are the probabilities of picking different amino acids?
1. You could sample all 20 normal amino acids equally.
2. You could sample amino acids weighted by their prevalence (in a particular organism).  Closely related:  You could take some database of native proteins and shuffle the residues.  
3. You could restrict yourself to the 10 amino acids (ASDGLIPTEV) that are plausibly made by prebiotic chemistry, if you care about origins of life
4. You could further try to make the compoisiton of amino acids [change as a function of evolutionary time](https://doi.org/10.1002/cbic.201800668)
5 . You could string together random DNA and then see what proteins it makes.  This has the the problem of what to do with [stop codons](https://www.genome.gov/genetics-glossary/Stop-Codon) which terminate the sequence.
6. DNA does not have an equal distribution of all bases, but has a (species specific) bias to GC pairs. same problem of needing to define the probabilities of the individual bases (higher GC content for sure, varies by species).  [Long et al. (2018)](https://doi.org/10.1038/s41559-017-0425-y) proposed that selection acts directly on GC content, perhaps due to the three hydrogen bonds of G–C pairs. But its also the case that amino acids encoded by Gs and Cs tend to promote higher intrinsic structural disorder [(Angyan et al. 2012)](https://doi.org/10.1016/j.febslet.2012.06.007), so maybe the selection for high GC content is just a consequence of a selection against harmful amino acids sequences.

So let's just stick with 1 an 3...

# What do we know about random peptides?

[Klara Hlouchova](http://khlab.org) at Charles University, Prague, Czech Republic seems to be a real leader in this!

**Tretyachenko, V., Vymětal, J., Bednárová, L. et al. Random protein sequences can form defined secondary structures and are well-tolerated in vivo . Sci Rep 7, 15449 (2017). [https://doi.org/10.1038/s41598-017-15635-8]** 
*  Discusses some prior Rosetta calculation studies in the introduction
* LIbraries of 100AA peptides.  Did some computational studies, characterized 5 different properties, then did experiments 
* Compared 4 different types of "randomness":  "(A) random sequences in which the ratios of individual amino acids reflect those found in natural proteins, (B) fragments of natural proteins from the TOP8000 database of non-redundant structurally characterized proteins extracted from the PDB database, (C) a selection of fragments of natural proteins from the UniProt database, and (D) fragments of natural intrinsically disordered proteins (IDPs) from the DisProt database"

**Sequence Versus Composition: What Prescribes IDP Biophysical Properties?
Entropy 2019, 21(7), 654; [https://doi.org/10.3390/e21070654]**
* IDPs sampled from DisPort database
* Use computational methods to predict the properties
* Predictions are largely a function of the composition, not the particular sequence 


**Tretyachenko Vyacheslav, Vymětal Jiří,  Neuwirthová Tereza, Vondrášek Jiří,  Fujishima Kosuke and Hlouchová Klára (2022) "Modern and prebiotic amino acids support distinct structural profiles in proteins" Open Biol.12 220040. [https://doi.org/10.1098/rsob.220040]**
*  105-amino-acid-long proteins with 84-amino-acid-long variable parts, FLAG/HIS tag sequences on N′/C′ ends, and a thrombin cleavage site in the middle of the protein construct 
* Look at variations between sampling 20F (20 modern AAs by propensity) and 10E (the prebiotic ASDGLIPTEV) 
* amino acid ratios for both libraries corresponded to natural amino acid distribution from the UniProt database 
* [consensus protein secondary structure prediction, e.g.,](https://doi.org/10.1016/j.bpj.2021.08.039) predicts that of the 200,000 sequences for each fo the two libraries have comparable alpha-helix and beta-sheet forming tendencies (fig. 2a)
* prediction of aggregation propensity of the same set of sequences indicated a significantly higher aggregation tendency of 10E library 
* higher predicted solubility of 10E proteins
* Experiments: 20F benefits from chaperones, 10E doesn't need it 
* Experiment: 10E library is intrinsically more soluble than 20F (approx. 60% versus 30% of the libraries remain soluble after heat shock, respectively) while the DnaK chaperone system induces higher post-heat shock solubility in both libraries.
* Experiment: Double  proteolysis experiment revealed that approximately 30–35% of library 20F proteins are protease resistant. Upon the addition of chaperones (which solubilizes the library as described above), the ratio of protease resistant species rose only mildly to approximately 40–50%. 
* Despite the similar secondary structure propensities of the full and early alphabets, the 10E library proteins are significantly more soluble (approx. 90%) upon expression. They retain similar solubilities in chaperoned/unchaperoned conditions unlike the 20F library proteins. This observation supports the previously stated hypothesis of chaperone coevolution with the incorporation of the first positively charged amino acids into the early amino acid alphabet
*  10E library indeed displays a significant protease-resistant behaviour. In the absence of chaperones, the ratio of the protease-resistant fraction is 40–50% in both the co- and post-translational digestion assay (i.e. similar to the 20F protease-resistant fraction when supplemented with chaperones).
* Early alphabet proteins are inherently more temperature resistant in a cell-like milieu --- he quantity of soluble proteins in reactions without chaperones were approximately two times greater in the early alphabet library (approx. 30% versus approximately 60% for 20F and 10E libraries, respectively) which might indicate a natural tendency to withstand elevated temperature.

**Early selection of the amino acid alphabet was adaptively shaped by biophysical constraints of foldability
Mikhail Makarov, Alma C. Sanchez Rocha, Robin Krystufek, Ivan Cherepashuk, Volha Dzmitruk, Tatsiana Charnavets, Anneliese M. Faustino, Michal Lebl, Kosuke Fujishima, Stephen D. Fried, Klara Hlouchova
bioRxiv 2022.06.14.495995; doi: [https://doi.org/10.1101/2022.06.14.495995]**
* experimentally evaluated the solubility and secondary structure propensities of several prebiotically relevant amino acids in the context of synthetic combinatorial 25-mer peptide libraries. 
* foldability was a critical factor in the selection of the canonical alphabet. Unbranched aliphatic and short-chain basic amino acids were purged from the proteinogenic alphabet despite their high prebiotic abundance because they generate polypeptides that are over-solubilized and have low packing efficiency.
* To model the sequence space available to different subsets of the amino acid alphabets, the libraries included the entire canonical alphabet without Cys (19F; F = full), its prebiotically available subset of 10 (10E; E = early), an alternative of 10E where the branched aliphatic amino acids were substituted with their unbranched prebiotically-abundant alternatives (10U; U = unbranched), the 10E library supplemented with: Arg as a representative of a modern cationic cAA (11R; R = Arg); or DAB as a representative of a potentially early cationic AA (11D; D = 2,4-diaminobutyric acid); or Tyr as a representative of an aromatic AA (11Y; Y = Tyr) (Figure 1).
* Experiments: solubility (as measured by spectrophotometery) and structure (by circular dichroism)

**"Experimental characterisation of de novo proteins and their unevolved random-sequence counterparts"
Brennen Heames, Filip Buchel, Margaux Aubel, Vyacheslav Tretyachenko, Andreas Lange, Erich Bornberg-Bauer, Klara Hlouchova
bioRxiv 2022.01.14.476368; doi: [https://doi.org/10.1101/2022.01.14.476368]**
* experimentally characterise sets of i) 1800 putative de novo proteins identified in human and fly genomes and ii) 1800 synthetically-generated random sequences.  Libraries were synthesised as an oligonucleotide pool, limiting pro- teins to 66 residues or less. A lower bound of 44 residues was chosen given the diminishing likelihood of domain-like structures for very short proteins.
* de novo proteins appear broadly similar to random sequences when length and amino acid frequencies are held constant. Consistent with computational prediction, the set of 1800 putative de novo proteins had similar overall protease resistance to the set of synthetic random sequences. This indicates that, at least given the amino acid composition of the de novo sequences chosen, random sequences have similar structural potential. However, de novo proteins are (moderately) more soluble at this composition and structure level. (evidence of selective pressure)

# Other gleanings

* In a classic study, Davidson and Sauer reported that proteins with native-like properties occur frequently in random libraries composed of mainly glutamine (Q), leucine (L), and arginine (R).9 Unlike natural proteins, the QLR-derived proteins were highly insoluble and hyperstable.  -- A. R. Davidson, R. T. Sauer, Proc. Natl. Acad. Sci. USA 1994, 91, 2146–2150.

# Random peptides and de novo genes

It used to be that people thought that the creation of a protein was highly improbable---limited to the earliest origins of life----and that modern novelty in proteins came from cutting up and recombining existing proteins.  

However, in recent years it has been appreciated that so-called "de novo genes" are not uncommon and appears to be ubiquitious in eukaryotes [see review by McLysaght & Guerzoni (2015)](https://doi.org/10.1098/rstb.2014.0332).  There is of course a long path to make this a stable, heritable element .

Of course, it would be really bad if a random peptide made by such a gene just ended up producing amyloids.

A [June 2022 computational study by Kosnski et al.](https://doi.org/10.1093/gbe/evac085) 




# Here, take my money!

Apparently you can buy these oligopools commercially.
* [Example](https://lcsciences.com/services/other-services/oligomix/oligomix-landing/) Oliomix , 0.8c/base , Customers can specify each oligonucleotide sequence (lengths up to 150-mers), delibery in 1-2 weeks 
* Example described in the materials of [https://doi.org/10.1101/2022.01.14.476368] ...tehre is some need to optimize codons, etc. 
