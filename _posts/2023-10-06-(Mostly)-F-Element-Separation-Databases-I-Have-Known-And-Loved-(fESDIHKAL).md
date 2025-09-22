---
title: "(Mostly) f-Element Separation Databases I Have Known And Loved (fESDIHKAL)"
date: 2023-10-06
tags: machinelearning ml science 
---

(with apologies to [the Shulgins](https://amzn.to/48JmuNh)) **A collection of references to (mostly) f-element hydrometallurgy / solvent extraction / [liquid-liquid extraction](https://en.wikipedia.org/wiki/Liquid–liquid_extraction) databases (lanthanides, actinides, plus Sc and Y so we can do** [rare earth separation]({{ site.baseurl }}{% post_url 2023-02-25-Predicting-Rare-Earth-Element-Separation-Chemistry %} ))...

# Terminology 

You'll see a few different metrics reported, so let's clarify the differences:

- [Distribution ratio](https://en.wikipedia.org/wiki/Liquid–liquid_extraction#Distribution_ratio) aka distribution coefficient, often denoted by the symbol K_d or D, is the concentration of a solute (e.g., metal of interest) in the organic phase divided by its concentration in the aqueous phase.  This is often also expressed as a logarithm (for the usual reasons: orders of magnitude variation and relationship to the Gibbs energy)

- [partition coefficient (P)](https://en.wikipedia.org/wiki/Partition_coefficient) is often used synonymously with distribution ratio, but differs if the solutes are in more than one form in any particular phase.  

- [separation factor](https://en.wikipedia.org/wiki/Liquid–liquid_extraction#Separation_factors) is the ratio the distribution ratios (or distribution coefficient) of two elements in an otherwise similar experiment; as such it gives a sense of the relative selectivity.  To a first approximation, it is just the ratio of Ds at low metal concentrations, but in principle there is competition between the metals for the ligands which can become more pronounced at higher metal concentrations.

- **stability constant** describes the equilibrium constant for metal-ligand binding within a single solvent, i.e., the equilibrium of the reaction M + L <--> ML.  It is sort of correlated to the distribution ratio (in both cases you need to bind that metal in the aqueous phase), but omits information about the solubility of the metal-ligand complex in the organic phase which is also important in a practical separation.  

**Why do we care?** Distribution ratios are the most directly related to our desire to predict experimental outcomes.  That said, there is lots of stability constant data available.  [Pick your poison, but don't mix them up.](https://condenaststore.com/featured/that-nice-romeo-boy-pia-guerra-and-ian-boothby.html) 

# Mostly lanthanides

- [Chaube et al (2020)](https://dx.doi.org/10.1038/s41598-020-71255-9) pull **stability constants** for 15 lanthanide cations in 8 solvent media, with 698 unique ligands for a total of 6538 entries from the IUPAC Stability Constants Database (*vide infra*)

- [Mitrofanov et al. (2021)](https://dx.doi.org/10.3390/molecules26113237) collected data on lanthanide (III) complexes.  They're a bit hazy on the total counts, by claim 82-324 **stability constants** for each complex which they use for some neural network bulding. Claims the dataset is in Supplementary Materials, but there is no such file(?)  

- [Liu et al (2022)](https://doi.org/10.1021/jacsau.2c00122) report 1202 **distribution coefficients** for lanthanide experiments, with 109 different ligands (as an XLSX file in their supporting information). They also made 4 novel ligands and performed 14 Ln(III) extractions for each (so a total of 56 bonus data points).  Annoyingly, they only reported their featurization of each ligand and not its SMILES/InChI string, so some of [my](https://scholar.google.com/citations?user=zJC_7roAAAAJ&hl=en) students laboriously found this over Summer 2023 (ughh...).  You can [download the file with the added SMILES strings in the last column here](/blog/images/2023/10/6/ORNL_FP.xlsx)

# Mostly actinides...

- [International Database for Extractant Ligands (IDEaL) (2023)](https://www.oecd-nea.org/ideal/):  439 extractants; tabular data of separation factors and **distribution coefficients** with references; no search.  Data includes:  metal, ligand, D, concentration, acid, organic diluent temperature and time;  no publication associated with this; hosted by the OECD Nuclear Energy Agency.  *Ripe for screen scraping...*


# General purpose

- *vanished?* [SEPSYS (1983) (McDowell and Moyer)](https://scholar.google.com/scholar_lookup?hl=en&publication_year=1983&pages=1-4&journal=%0ASolvent+Extr.+Ion+Exchange%0A&author=W.+J.+McDowell&author=D.+C.+Michelson&author=B.+A.+Moyer&author=C.+F.+Coleman&title=A+Source+of+Solvent+Extraction+Information) : 4500 records, development stopped, vanished without a trace.  a [user manual](https://www.osti.gov/servlets/purl/6742665) can be found on OSTI.gov

- *vanished?* [Solvent Extraction Data (SEDATA) (1984)](http://dx.doi.org/10.2116/bunsekikagaku.33.6_T52); ([english abstract via research gate](https://www.researchgate.net/publication/311932511_Construction_of_a_database_for_solvent_extraction)) ;  created by Tohoku University, Japan; only cited four times?   
    - There's a [reference to the grant funding in 1995 to SEDATA II](https://kaken.nii.ac.jp/en/grant/KAKENHI-PROJECT-07554041/) which refers to a [website](http://www.tut3c.tut.ac.jp/sedata), but it 404s as of 2023 and there is [no record on the Internet Archive](https://web.archive.org/web/20230000000000*/http://www.tut3c.tut.ac.jp/sedata).  
    - A [subsequent paper in  Solvent Extraction Research and Development Japan (2000)](https://www.researchgate.net/publication/292416232_Construction_of_an_Internet_compatible_database_for_solvent_extraction_of_metal_ions) describes  as containing "17,000 numerical data concerning extraction equilibria for 82 metal ions as well as the related information about the experimental conditions and reference description" and references a [new website hosted by Osaka Univ.](http://sedatant.chem.sci.osaka-u.ac.jp/) (which is also missing as of 2023)...but [internet archive has a few snapshots, the last of which mentions an update in 2008](https://web.archive.org/web/20100714055846/http://sedatant.chem.sci.osaka-u.ac.jp/) and refers to Satoshi TSUKAHARA at Hiroshima University ;  the ISSX paper (*vide infra*) states that SEDATA does not contain 2D or 3D structures and only allows search using metal, reagent, title of paper, author fields.  

- *defunct?* [Information System for Solvent eXtraction (ISSX) (2001)](https://doi.org/10.1081/SEI-100107025)  (Varnek et al.): Borland windwos database; designed around doing QSAR. Mentions that "A demonstration version of SXD with 166 records is available by request at varnek@chimie.u-strasbg.fr ".  [Varnek appears to still be alive and active (and still affiliated with Strasbourg)](https://scholar.google.fr/citations?hl=en&user=hcMM9qYAAAAJ&view_op=list_works&sortby=pubdate), even if there doesn't seem to be any subsequent work on the database.  Of the 39 citations (as of 06 Oct 2023), they appears to be applications or reviews, no subsequent database work.
    - Subsequent work in Varnek's group ([Solov'ev et al 2019](https://doi.org/10.1002/minf.201900002)) cites this paper, but doesn't appear to use the data, instead drawing from the [IUPAC Stability Constants database](https://old.iupac.org/publications/scdb/index.html) (*vide infra*), restricting to 298K and ionic stregnth of 0.1 M (in a few cases they correct the actual values of logK under different conditions using the van'tHoff equation to correct for temperature and Davies equation to correct for ionic strength ).  (Mentions in passing that IUPAC has 400k records, NIST has 48k records, and the existence of the [Joint Expert Speciation System (JESS)](https://pubs.acs.org/doi/abs/10.1021/bk-2005-0910.ch003) with 188k records.) their cleaned dataset of 2501 logK values for 12 metal ions and 1027 polydentate ligands is in an SDF file (which doesn't actually appear to be part of the SI! uggh...) and their external test sets of 121 logK values (17 metal ions and 47 ligands) is printed in the tables in the SI (uggh...)   

- *discontinued* [IUPAC Stability Constants Database](https://old.iupac.org/publications/scdb/index.html) ; a standalone windows database of **stability constants** for 9200 ligands, 108,000 records, drawn from 22500 literature references for *stability constants*. Last [reference paper was 2006](https://doi.org/10.1515/ci.2006.28.5.14), but it contains data entries as late as 2013.  [Michael Taylor](https://scholar.google.com/citations?user=lw_MEZgAAAAJ&hl=en&oi=ao) has managed (with permission from Leslie Pettit[^1]) to reverse engineer the database file and extract data, adding SMILES (the original has CAS and ligand names).  

- *discontinued* [NIST Critically Selected Stability Constants of Metal Complexes: v8 (2004)](https://www.nist.gov/srd/nist46) since discontinued.  Contains 6166 ligands, 112559 total data items, runs on Windows XP.   NIST website lists this as officially "discontinued".

- [Kanahashi et al. (2022)](https://doi.org/10.1038/s41598-022-15300-9) describe a dataset of 57 cations and 2706 ligands (for 19,810 data points) of **stability constant** values (including multi-order data for a small subset); heavily biased to Cu2+, Ni2+, Zn2+, Co2+, Cd2+, Ag+, and Ca2+ (which account for 50% of the total data.); they featurize this and do [GPR](https://scikit-learn.org/stable/modules/gaussian_process.html).  Their methods section describes this as coming primarily from the [NIST Critically Selected Stability Constants of Metal Complexes Database](https://www.nist.gov/srd/nist46), (*vide supra*) supplemented by data from 30 papers.  "[D]ata for several heavy metals (i.e., Am, Cm, Cf, Bk, Es, Fm, and Md) or whose ligands contain elements such as Te, Se, As, Mn, Co, Fe, W, Mo, Cr, and Re were excluded due to the difficulties in making descriptors".  Annoyingly "Additional information regarding this study is available from the corresponding authors [Kenji Yamaguchi](mailto:kyam@mmc.co.jp) upon reasonable request." (uggh...)


*Thanks to contributors/proof-readers:*  [Michael Taylor](https://scholar.google.com/citations?user=lw_MEZgAAAAJ&hl=en&oi=ao)

Got more?  [Tell me](mailto:jschrier@fordham.edu?subject=databases)


[^1]: Who said: "Thank you for your enquiry about the database.  We stopped collecting new data about 2005 and formally handed the data to IUPAC who have made no use of the database.  We have completely retired (we are now 86) and disbanded Academic Software so I am surprised the email link you used still works. Regrettably our age means we are now out of touch with the subject. However you can download a copy of the final version of the database from: ..."


# Update (September 2025)

We have compiled these (and more!) data, along with a correcting typographical errors at the [SAFE database](http://safe.lanl.gov).  Please use that resource going forward and contribute your data to make this collection a comprehensive data source.

You can read about the goals and structure of the SAFE database project in the [letter we wrote to SX&IX](https://dx.doi.org/10.1080/07366299.2025.2564381)

