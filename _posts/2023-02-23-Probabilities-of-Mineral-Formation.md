---
Title: "Probabilities of Mineral Formation"
Date: 2023-02-23
Tags: science data probability 
---
I saw a fascinating talk by [Daniel Hummer](https://scholar.google.com/citations?hl=en&user=Lc2j6-YAAAAJ&view_op=list_works&sortby=pubdate) on "Data Mining the Past: Using Large Mineral Datasets to Trace Earth's Geochemical History"  **A few gleanings below...**

# Some online datasets

* [IMA Mineral Database](https://rruff.info/ima)
* [Mindat](https://www.mindat.org)

# Mineral Ecology (2015)

**minerals** are solid, naturally occuring cyrstalline substances with well-defined chemical and atomic structure

**mineral ecology** is the large scale pattern of distribution in space and time

Premise:  treat this as a [large number of rare events (LNRE)](https://en.wikipedia.org/wiki/Large_number_of_rare_events), e.g., using a Zipf distribution to estimate the rarity of mineral species.  Estimate how many minerals are yet to be discovered by making this assumption.  It's on the order of a few thousand, with maybe a 2x difference if you take a Bayesian perspective. 

# Carbon mineral challenge (mineral challenge.net) (2015-2019)

# Mineral Network Analysis (2017)

Treat this as a graph problem, nodes are minerals edges are coexistence at a site
ref: Morrison et al. 2017 Am. Min

Try to use unsupervised network clustering to find geospatial cooccurence patterns.  What types of minerals can form in the same local, and how is this dependent on the types of elements or geological conditions that are present? 


# Analyzing element associations (2022)

How often does a pair of elements form a mineral species?  Is this greater than a chance pairing of the elements? 

Compare to the [Goldschidt classification](https://en.wikipedia.org/wiki/Goldschmidt_classification) into lithophiles (silicate), siderophiles (metals), chalcophiles (sulfides), and atmophiles (ocean & atmosphere), based on pairwise interactions

What about triples?  You can do that too.  Esentially some elements prefer to go into hydrates and others don't.  Open question about whether this is true about individual samples or whether it is just a statement about minerals as a whole.

# Mineral evolution

We can also think about time-dependence.  What's the difference between minerals produced in the Hadean era versus minerals  produced today? Could we use that as a biosignature?

