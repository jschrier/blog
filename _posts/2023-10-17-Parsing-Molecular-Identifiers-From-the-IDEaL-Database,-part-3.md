---
Title: "Parsing Molecular Identifiers From the Ideal Database, part 3"
Date: 2023-10-17
Tags: mathematica chemdraw science
---

In [our last episode]({{ site.baseurl }}{% post_url 2023-10-16-Parsing-Molecular-Identifiers-From-the-IDEaL-Database,-part-2  %}), we were left with 25 cases where the inferred molecule did not agree with the reported formula or molar mass, in our quest to to turn the [IDEaL database](https://www.oecd-nea.org/ideal/) into a comprehensive f-element separation database. **Here we fix them by hand and generate the final result...**

## Import the data

```mathematica
SetDirectory@NotebookDirectory[];
missing = Import["2023.10.16_missing_entries_needs_proofing.xlsx", {"Dataset", 1}, "HeaderLines" -> 1]
correct = Dataset[{}];
excluded = Dataset[{}]; 
  
 (*revised from last post*)
outputData[oldRecord_, mol_Molecule] := With[
   {reportedMass = Interpreter[Number]@ oldRecord["reported_mass"], 
    computedMass = QuantityMagnitude[mol["MolarMass"]]}, 
   Dataset@Association[
     "url" -> oldRecord["url"], 
     "abbreviation" -> oldRecord["abbreviation"], 
     "SMILES" -> mol["CanonicalSMILES"], 
     "InChI" -> mol["InChI"]["ExternalID"], 
     "InChIKey" -> mol["InChIKey"]["ExternalID"], 
     "computed_formula" -> mol["MolecularFormulaString"], 
     "reported_formula" -> oldRecord["reported_formula"], 
     "computed_mass" -> computedMass, 
     "reported_mass" -> reportedMass, 
     "formula_matchQ" -> StringMatchQ[mol["MolecularFormulaString"], oldRecord["reported_formula"]], 
     "mass_matchQ" -> (Round[reportedMass] == Round[computedMass]) 
    ]]
```

![0cv2w8fok5rbk](/blog/images/2023/10/17/0cv2w8fok5rbk.png)

## 1

```mathematica
missing[[1]]
```

![0tgp12j6w63y1](/blog/images/2023/10/17/0tgp12j6w63y1.png)

```mathematica
WebImage@missing[[1, "url"]]
```

![1ff7t9f98whks](/blog/images/2023/10/17/1ff7t9f98whks.png)

```mathematica
MoleculePlot@Molecule@missing[[1, "InChI"]]
```

![1sft34z9qhp6t](/blog/images/2023/10/17/1sft34z9qhp6t.png)

Comment: Imported structure is consistent with diagram and consistent with molecular formula. This implies an *error of IDEaL mass.*

```mathematica
AppendTo[correct, missing[[1]]]
```

![1y019lhbzm4b4](/blog/images/2023/10/17/1y019lhbzm4b4.png)

## 2

```mathematica
missing[[2]]
WebImage@%["url"]
MoleculePlot@Molecule@%%["InChI"]
```

![0lrkt37w0crtt](/blog/images/2023/10/17/0lrkt37w0crtt.png)

![16qyt5pplps1r](/blog/images/2023/10/17/16qyt5pplps1r.png)

![0fpn3tdlxmp4a](/blog/images/2023/10/17/0fpn3tdlxmp4a.png)

```mathematica

```

Mass and structures match.  Implies *error on IDEaL chemical formula*

```mathematica
AppendTo[correct, missing[[2]]]
```

![0ga1dxvmv5kl5](/blog/images/2023/10/17/0ga1dxvmv5kl5.png)

## 3

```mathematica
missing[[3]]
WebImage@%["url"]
MoleculePlot@Molecule@%%["InChI"]
```

![15eya67r8moi6](/blog/images/2023/10/17/15eya67r8moi6.png)

![0ak19d6awtsux](/blog/images/2023/10/17/0ak19d6awtsux.png)

![0adbquoh86sjs](/blog/images/2023/10/17/0adbquoh86sjs.png)

Comment:  It seems strange (and unlikely) to me that one of the sidechains is different (missing a carbon compared to the others; all the others are 2-ethylhexl as implied by the name).  I suspect that the formula is correct, but the structure drawn is incorrect.

```mathematica
CopyToClipboard@missing[[3]]["InChI"]
```

```mathematica
AppendTo[
  correct, 
  outputData[missing[[3]], Molecule["CCCCC(CN(CC(N(CC(CCCC)CC)CC(CCCC)CC)=O)CC(N(CC(CCCC)CC)CC(CCCC)CC)=O)CC"]]]
```

![0m3a0egt2poo8](/blog/images/2023/10/17/0m3a0egt2poo8.png)

## 4

```mathematica
missing[[4]]
WebImage@%["url"]
MoleculePlot@Molecule@%%["InChI"]
```

![17wlqncagc14l](/blog/images/2023/10/17/17wlqncagc14l.png)

![1l0vc0atk6j83](/blog/images/2023/10/17/1l0vc0atk6j83.png)

![1lagtq21bjx0i](/blog/images/2023/10/17/1lagtq21bjx0i.png)

![04exfz5i02jjp](/blog/images/2023/10/17/04exfz5i02jjp.png)

```
(*MoleculePlot[Molecule["Missing[\"NotAvailable\"][\"ExternalID\"]"]]*)
```

**Comment:** Looks like the structure is fine (matches molecular weight, etc.) and the only problem is that there are some extra asterisks.  This is actually a six membered ring(!) We have to open this in ChemDraw and manually edit it (copying back the result)

```mathematica
CopyToClipboard@missing[[4]]["SMILES"]
```

Editing fixes the agreement...

```mathematica
outputData[missing[[4]], Molecule["COc1cc(Cc2c(OCC(N(CC)CC)=O)c(Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(C6)cc(OC)c5)cc(OC)c4)cc(OC)c3)cc(OC)c2)c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c6cc(OC)c7)c1"]]
AppendTo[correct, %]
```

![1lp6xfa75vdtf](/blog/images/2023/10/17/1lp6xfa75vdtf.png)

![0dqrvz324ylz4](/blog/images/2023/10/17/0dqrvz324ylz4.png)

**Comment:** It appears we have fixed it!  

## 5

```mathematica
missing[[5]]
```

![10dsguynejj9j](/blog/images/2023/10/17/10dsguynejj9j.png)

Looks like another ring... copy to clipboard and repair

```mathematica
CopyToClipboard@missing[[5]]["SMILES"]
```

```mathematica
outputData[missing[[5]], Molecule["CCCCCCCCOc1cc(Cc2c(OCC(N(CC)CC)=O)c(Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c(Cc8c(OCC(N(CC)CC)=O)c(C9)cc(OCCCCCCCC)c8)cc(OCCCCCCCC)c7)cc(OCCCCCCCC)c6)cc(OCCCCCCCC)c5)cc(OCCCCCCCC)c4)cc(OCCCCCCCC)c3)cc(OCCCCCCCC)c2)c(OCC(N(CC)CC)=O)c9c1"]]
AppendTo[correct, %]
```

![0egtc05hj45p4](/blog/images/2023/10/17/0egtc05hj45p4.png)

![1pq0yxz6qge4b](/blog/images/2023/10/17/1pq0yxz6qge4b.png)

## 6

```mathematica
missing[[6]]
```

![0vsvrtopbzwze](/blog/images/2023/10/17/0vsvrtopbzwze.png)

Comment: This appears to be a batter with all of these CA* extractants... OK

```mathematica
CopyToClipboard@missing[[6, "SMILES"]]
```

```mathematica
outputData[missing[[6]], Molecule["CC(C)(C)c1cc(Cc2c(OCC(N(CC)CC)=O)c(Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(C7)cc(C(C)(C)C)c6)cc(C(C)(C)C)c5)cc(C(C)(C)C)c4)cc(C(C)(C)C)c3)cc(C(C)(C)C)c2)c(OCC(N(CC)CC)=O)c7c1"]]
AppendTo[correct, %];
```

![197mtc1xjow1v](/blog/images/2023/10/17/197mtc1xjow1v.png)

## 7

```mathematica
missing[[7]]
```

![0nchmzd27g2z8](/blog/images/2023/10/17/0nchmzd27g2z8.png)

```mathematica
WebImage[missing[[7, "url"]]]
```

![10t4ouh56mxg7](/blog/images/2023/10/17/10t4ouh56mxg7.png)

**Comment:**  This is not a well-defined compound (it appears to be some mix?) and there are no D-values, so we are going to leave this one out....

```mathematica
AppendTo[excluded, missing[[7]]]
```

![05qol5h4c09ie](/blog/images/2023/10/17/05qol5h4c09ie.png)

## 8

```mathematica
missing[[8]]
```

![0zioincu1p8ki](/blog/images/2023/10/17/0zioincu1p8ki.png)

```mathematica
WebImage@missing[[8, "url"]]
```

![13iu6zipk8sjk](/blog/images/2023/10/17/13iu6zipk8sjk.png)

Comment: Looks like the issue here is that the position of the methyl group on the right is not explicit .  [The cited paper clarifies it to be the 4,4'(5') compound (purchased commercially),](https://doi.org/10.1080/07366299008918017) so I will edit it appropriately, starting from downloading the CDX file

```mathematica
outputData[missing[[8]], Molecule["CC1CC2OCCOCCOC3C(CC(C)CC3)OCCOCCOC2CC1"]]
AppendTo[correct, %];
```

![0s806tbnbur4r](/blog/images/2023/10/17/0s806tbnbur4r.png)

## 9

```mathematica
missing[[9]]
```

![0esbgocanfabg](/blog/images/2023/10/17/0esbgocanfabg.png)

Same thing as #8, but the isobutyl compound (same source paper)

```mathematica
outputData[missing[[9]], Molecule["CC(C)(C)C1CC2OCCOCCOC3C(CC(C(C)(C)C)CC3)OCCOCCOC2CC1"]]
AppendTo[correct, %];
```

![17awluakk2vnf](/blog/images/2023/10/17/17awluakk2vnf.png)

## 10

```mathematica
missing[[10]]
```

![0cu0jtkcot6vn](/blog/images/2023/10/17/0cu0jtkcot6vn.png)

```mathematica
WebImage[missing[[10, "url"]]]
```

![0o05pwwat0wya](/blog/images/2023/10/17/0o05pwwat0wya.png)

This appears to be a clear case where the formula is wrong--there is not oxygen in this molecule (based on the name); mass is correct

```mathematica
AppendTo[correct, missing[[10]]];
```

## 11

```mathematica
missing[[11]]
```

![1e6w8lk20tmjt](/blog/images/2023/10/17/1e6w8lk20tmjt.png)

```mathematica
WebImage@missing[[11, "url"]]
```

![14sm6q8p4iioi](/blog/images/2023/10/17/14sm6q8p4iioi.png)

Another ring...best fixed manually in ChemDraw

```mathematica
CopyToClipboard@missing[[11, "SMILES"]]
```

```mathematica
outputData[missing[[11]], Molecule["O=C(CP(c1ccccc1)(c2ccccc2)=O)Nc3cc(Cc4c(OCCCCCCCCCCCCCC)c(Cc5c(OCCCCCCCCCCCCCC)c(Cc6c(OCCCCCCCCCCCCCC)c(C7)cc(NC(C)=O)c6)cc(NC(CP(c8ccccc8)(c9ccccc9)=O)=O)c5)cc(NC(CP(c%10ccccc%10)(c%11ccccc%11)=O)=O)c4)c(OCCCCCCCCCCCCCC)c7c3"]]
AppendTo[correct, %];
```

![13tgjv9ojss17](/blog/images/2023/10/17/13tgjv9ojss17.png)

## 12

```mathematica
missing[[12]]
```

![08nklkulam90y](/blog/images/2023/10/17/08nklkulam90y.png)

Yet another ring...we know what to do...

```mathematica
CopyToClipboard@missing[[12, "SMILES"]]
```

```mathematica
outputData[missing[[12]], Molecule["COc1cc(Cc2c(OCC(N(CC)CC)=O)c(Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c(C8)cc(OC)c7)cc(OC)c6)cc(OC)c5)cc(OC)c4)cc(OC)c3)cc(OC)c2)c(OCC(N(CC)CC)=O)c(Cc9c(OCC(N(CC)CC)=O)c8cc(OC)c9)c1"]]
AppendTo[correct, %];
```

![0wowch6wqfkti](/blog/images/2023/10/17/0wowch6wqfkti.png)

## 13

```mathematica
missing[[13]]
```

![1gh6zt5b0ahpl](/blog/images/2023/10/17/1gh6zt5b0ahpl.png)

Same story here...

```mathematica
CopyToClipboard@missing[[13, "SMILES"]]
```

```mathematica
outputData[missing[[13]], Molecule["CCCCCOc1cc(Cc2c(OCC(N(CC)CC)=O)c(Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c(C8)cc(OCCCCC)c7)cc(OCCCCC)c6)cc(OCCCCC)c5)cc(OCCCCC)c4)cc(OCCCCC)c3)cc(OCCCCC)c2)c(OCC(N(CC)CC)=O)c(Cc9c(OCC(N(CC)CC)=O)c8cc(OCCCCC)c9)c1"]]
AppendTo[correct, %];
```

![1kzx2hpr9mogb](/blog/images/2023/10/17/1kzx2hpr9mogb.png)

## 14

```mathematica
missing[[14]]
```

![1fz1z6yzhhx7q](/blog/images/2023/10/17/1fz1z6yzhhx7q.png)

Seems to be a common story for all the NEA* ligands...

```mathematica
CopyToClipboard@missing[[14, "SMILES"]]
```

```mathematica
outputData[missing[[14]], Molecule["CC(C)(C)c1cc(Cc2c(OCC(N(CC)CC)=O)c(Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c(C8)cc(C(C)(C)C)c7)cc(C(C)(C)C)c6)cc(C(C)(C)C)c5)cc(C(C)(C)C)c4)cc(C(C)(C)C)c3)cc(C(C)(C)C)c2)c(OCC(N(CC)CC)=O)c(Cc9c(OCC(N(CC)CC)=O)c8cc(C(C)(C)C)c9)c1"]]
AppendTo[correct, %];
```

![0rb9xaslbcx2i](/blog/images/2023/10/17/0rb9xaslbcx2i.png)

## 15

```mathematica
missing[[15]]
```

![0qxmcbnn7u0jp](/blog/images/2023/10/17/0qxmcbnn7u0jp.png)

```mathematica
CopyToClipboard@missing[[15, "SMILES"]]
```

```mathematica
outputData[missing[[15]], Molecule["O=C(N(CC)CC)COc1c2cccc1Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c(Cc8c(OCC(N(CC)CC)=O)c(Cc9c(OCC(N(CC)CC)=O)c(C2)ccc9)ccc8)ccc7)ccc6)ccc5)ccc4)ccc3"]]
AppendTo[correct, %];
```

![0opt78ezuovqz](/blog/images/2023/10/17/0opt78ezuovqz.png)

## 16

```mathematica
missing[[16]]
```

![0549jnovkasy3](/blog/images/2023/10/17/0549jnovkasy3.png)

```mathematica
CopyToClipboard@missing[[16, "SMILES"]]
```

```mathematica
outputData[missing[[16]], Molecule["O=C(N(CC)CC)COc1c2cc(OCc3ccccc3)cc1Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c(Cc8c(OCC(N(CC)CC)=O)c(C2)cc(OCc9ccccc9)c8)cc(OCc%10ccccc%10)c7)cc(OCc%11ccccc%11)c6)cc(OCc%12ccccc%12)c5)cc(OCc%13ccccc%13)c4"]]
AppendTo[correct, %];
```

![1ekp711cdqkfj](/blog/images/2023/10/17/1ekp711cdqkfj.png)

## 17

```mathematica
missing[[17]]
```

![1ebs00qlomnse](/blog/images/2023/10/17/1ebs00qlomnse.png)

```mathematica
CopyToClipboard@missing[[17, "SMILES"]]
```

```mathematica
outputData[missing[[17]], Molecule["CCCCCCCCOc1cc(Cc2c(OCC(N(CC)CC)=O)c(Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(C6)cc(OCCCCCCCC)c5)cc(OCCCCCCCC)c4)cc(OCCCCCCCC)c3)cc(OCCCCCCCC)c2)c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c6cc(OCCCCCCCC)c7)c1"]]
AppendTo[correct, %];
```

![0fvhh7yrbbxzk](/blog/images/2023/10/17/0fvhh7yrbbxzk.png)

## 18

```mathematica
missing[[18]]
```

![12q5ex39xye7z](/blog/images/2023/10/17/12q5ex39xye7z.png)

```mathematica
CopyToClipboard@missing[[18, "SMILES"]]
```

```mathematica
outputData[missing[[18]], Molecule["O=C(N(CC)CC)COc1c2cccc1Cc3c(OCC(N(CC)CC)=O)c(Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c(C2)ccc7)ccc6)ccc5)ccc4)ccc3"]]
AppendTo[correct, %];
```

![1n3lqom6zcwhu](/blog/images/2023/10/17/1n3lqom6zcwhu.png)

## 19

```mathematica
missing[[19]]
```

![0r84pjp85xwuf](/blog/images/2023/10/17/0r84pjp85xwuf.png)

```mathematica
CopyToClipboard@missing[[19, "SMILES"]]
```

```mathematica
outputData[missing[[19]], Molecule["O=C(N(CC)CC)COc1c2cc(OCc3ccccc3)cc1Cc4c(OCC(N(CC)CC)=O)c(Cc5c(OCC(N(CC)CC)=O)c(Cc6c(OCC(N(CC)CC)=O)c(Cc7c(OCC(N(CC)CC)=O)c(Cc8c(OCC(N(CC)CC)=O)c(Cc9c(OCC(N(CC)CC)=O)c(Cc%10c(OCC(N(CC)CC)=O)c(C2)cc(OCc%11ccccc%11)c%10)cc(OCc%12ccccc%12)c9)cc(OCc%13ccccc%13)c8)cc(OCc%14ccccc%14)c7)cc(OCc%15ccccc%15)c6)cc(OCc%16ccccc%16)c5)cc(OCc%17ccccc%17)c4"]]
AppendTo[correct, %];
```

![0cdl4d7kbuah4](/blog/images/2023/10/17/0cdl4d7kbuah4.png)

## 20

```mathematica
missing[[20]]
```

![0120y491zzlu6](/blog/images/2023/10/17/0120y491zzlu6.png)

```mathematica
URL[missing[[20, "url"]]]
```

![18038cos67115](/blog/images/2023/10/17/18038cos67115.png)

Comment:  Computed and reported formulas are the same and seem consistent with the name.  The mass seems low by 3 AMU (?)--maybe just a typo.  In any case, it does not matter much, as there are no distribution coefficients reported.

```mathematica
AppendTo[correct, missing[[20]]];
```

## 21

```mathematica
missing[[21]]
```

![1fogj62juug95](/blog/images/2023/10/17/1fogj62juug95.png)

```mathematica
WebImage[missing[[21, "url"]]]
URL@missing[[21, "url"]]
```

![0o6zd5jy91ukp](/blog/images/2023/10/17/0o6zd5jy91ukp.png)

![11mzjoxptqljd](/blog/images/2023/10/17/11mzjoxptqljd.png)

This is an interesting case as there are few problems: (i). The listed formula appears to be wrong (too many hydrogens); (ii) The LLM-scraped formula is wrong (apparently OpenAI did not like the dot, or at least determined that as an end...a reasonable mistake); (iii) The InChI representation correctly capture the idea that this is a salt, whereas the SMILES does not (?) 

```mathematica
Map[MoleculePlot@Molecule[#] &]@{ missing[[21, "InChI"]], missing[[21, "SMILES"]]} // GraphicsRow
```

![05undtzrakd0w](/blog/images/2023/10/17/05undtzrakd0w.png)

We can fix the SMILES by round tripping it from an initial InChI 

```mathematica
MoleculePlot@Molecule@#["CanonicalSMILES"] &@Molecule@missing[[21, "InChI"]]
```

![1kw8i71zjqbx9](/blog/images/2023/10/17/1kw8i71zjqbx9.png)

```mathematica
outputData[missing[[21]], Molecule@missing[[21, "InChI"]]]
AppendTo[correct, %];
```

![0xqxm4kgflmk8](/blog/images/2023/10/17/0xqxm4kgflmk8.png)

## 22

```mathematica
missing[[22]]
URL[%["url"]]
WebImage[%]

```

![0p7ddiibri4oo](/blog/images/2023/10/17/0p7ddiibri4oo.png)

![0b4v4f2wbghtj](/blog/images/2023/10/17/0b4v4f2wbghtj.png)

![03nuprhdyzmj3](/blog/images/2023/10/17/03nuprhdyzmj3.png)

Comment:  Hmmm....no tests performed. Mol weight seems fine, which suggests the formula is goofy.  But in the end it will not matter much

```mathematica
AppendTo[correct, missing[[22]]];
```

## 23

```mathematica
missing[[23]]
URL[%["url"]]
WebImage[%]

```

![1mld8ti6akju8](/blog/images/2023/10/17/1mld8ti6akju8.png)

![0vvi8a3yb5su2](/blog/images/2023/10/17/0vvi8a3yb5su2.png)

![0b0upqq3169ii](/blog/images/2023/10/17/0b0upqq3169ii.png)

Not much to go on here.  The structure backbone indeed looks like an [ornithine](https://en.wikipedia.org/wiki/Ornithine) (note that this is likely a racemate given the name) and the other parts seem to match. There should totally be 5 nitrogens in this (3 from the aza-phenanthroline plus two from the ornithine), so this looks like a *bad formula* and *bad mass* on IDEaL.  Not that it matters much, because there is no data reported...

```mathematica
Molecule["ornithine"]
Molecule["3-aza-5,6-dihydro-1,10-phenanthroline"]
```

![0bo19d0hsojkz](/blog/images/2023/10/17/0bo19d0hsojkz.png)

![062nxfpmydgzf](/blog/images/2023/10/17/062nxfpmydgzf.png)

```mathematica
AppendTo[correct, missing[[23]]];
```

## 24

```mathematica
missing[[24]]
URL[%["url"]]
WebImage[%]
```

![00c4dbtlf99me](/blog/images/2023/10/17/00c4dbtlf99me.png)

![0pprsfrwml2ej](/blog/images/2023/10/17/0pprsfrwml2ej.png)

![1q90fm39471py](/blog/images/2023/10/17/1q90fm39471py.png)

There is not much to go on here; apparently we rejected it initially because the name is not unambiguous (placement of the sulfates on the phenyl):

```mathematica
mol = Molecule["6,6'-bis(5,6-di(sulfophenyl)-1,2,4-triazin-3-yl)-2,2'-bipyridine"]
MoleculePlot[%]
MoleculeValue[%%, {"MolecularFormulaString", "MolarMass"}]
```

![06ntsvu3li71p](/blog/images/2023/10/17/06ntsvu3li71p.png)

![02w6mlig0war6](/blog/images/2023/10/17/02w6mlig0war6.png)

![1vnboskzaahcu](/blog/images/2023/10/17/1vnboskzaahcu.png)

![0ul0hlfz3a7mo](/blog/images/2023/10/17/0ul0hlfz3a7mo.png)

This is totally not the same molecular formula and mass given on the IDEaL website.  However, this structure looks consistent with the stated name--I do not see how you would get the bis  di sulfulophenyl with fewer atoms.  And there is no other data, so my decision is to run with this.

```mathematica
outputData[missing[[24]], Molecule[mol]]
AppendTo[correct, %];
```

![0jk9amhkq90se](/blog/images/2023/10/17/0jk9amhkq90se.png)

## 25

```mathematica
missing[[25]]
URL[%["url"]]
WebImage[%]
```

![17mqyp3vjbrhe](/blog/images/2023/10/17/17mqyp3vjbrhe.png)

![018hnwiocqq5n](/blog/images/2023/10/17/018hnwiocqq5n.png)

![07oc2ucziq7mv](/blog/images/2023/10/17/07oc2ucziq7mv.png)

Once again, not much to go on here.  I [found a paper](https://link.springer.com/content/pdf/10.1007/s10967-007-7253-5.pdf) which uses this for a separation with ratios of HDBP:Zr of 9, but that makes the mass too high; the closest I can get to the stated mass is 7:1 and even then it is not a perfect match:

```mathematica
Molecule["dibutyl phosphoric acid"]
%["MolarMass"]*7 + ElementData["Zr", "MolarMass"]
```

![1partbw9jxbdf](/blog/images/2023/10/17/1partbw9jxbdf.png)

![0by3fp0mqjdlr](/blog/images/2023/10/17/0by3fp0mqjdlr.png)

Modest proposal:  It does not matter much, because there are no references.  So I will just put in a 1:1 stoichiometry and call it a day

```mathematica
mol = Molecule@StringJoin[
    "[Zr].", 
    Molecule["dibutyl phosphoric acid"]["CanonicalSMILES"]]
MoleculePlot[%]
```

![0g9mh64bqc86e](/blog/images/2023/10/17/0g9mh64bqc86e.png)

![1223wyrsd7e5y](/blog/images/2023/10/17/1223wyrsd7e5y.png)

```mathematica
outputData[missing[[25]], mol]
AppendTo[correct, %];
```

![1sfwo94u3tr5i](/blog/images/2023/10/17/1sfwo94u3tr5i.png)

## Conclusion

Did we get them all?

```mathematica
(Length[excluded] + Length[correct] ) == Length[missing]

(*True*)
```

Remember, we **excluded** one case:

```mathematica
excluded[[1]]
```

![1x9pyrcvcdqts](/blog/images/2023/10/17/1x9pyrcvcdqts.png)

Merge these new results with the correct values found in the last episode; the [resulting file can be downloaded here](/blog/images/2023/10/18/2023.10.17_all_correct_entries.xlsx).

```mathematica
With[
   {previous =  Import["2023.10.16_all_correct_entries.xlsx", {"Dataset", 1}, "HeaderLines" -> 1]}, 
   Join[previous, correct]];
Export["2023.10.17_all_correct_entries.xlsx", %];
Length[%%] (*count how many we have*)


(*438*)
```

```mathematica
ToJekyll["Parsing Molecular Identifiers From the Ideal Database, part 3", "mathematica chemdraw science"]
```
