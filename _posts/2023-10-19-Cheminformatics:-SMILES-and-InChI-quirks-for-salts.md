---
Title: "Cheminformatics: SMILES and InChI quirks for salts"
Date: 2023-10-19
Tags: science cheminformatics mathematica chemdraw chemistry
---

Olivia Vanden Assem '25 asks:  *Why am I getting inconsistent* *[SMILES](https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system)**,* *[InChI](https://jcheminf.biomedcentral.com/articles/10.1186/s13321-015-0068-4)**, and InChI Key results for the salt and neutral acid-base* *[representations](https://chem.libretexts.org/Courses/Intercollegiate_Courses/Cheminformatics/02%3A_Representing_Small_Molecules_on_Computers)* *of ammonium nitrate?*  **There are some quirks about interconversion between SMILES and InChI in standard implementations that can result in neutral and salt forms of a pair of molecules being different...** **

Suppose we have [ammonium nitrate](https://en.wikipedia.org/wiki/Ammonium_nitrate).  We can represent this as two neutral molecules using the following InChI identifier:

```mathematica
neutralInChI = "InChI=1S/NO3.H3N/c2-1(3)4;/h;1H3/q-1;/p+1";
MoleculePlot[%]
```

![089g95au85luf](/blog/images/2023/10/19/089g95au85luf.png)

If we convert this into SMILES, we also get two neutral molecules:

```mathematica
neutralSMILES = Molecule[neutralInChI]["SMILES"]
MoleculePlot[%]

(*"[N+]([O-])(=O)O.N"*)
```

![1frgwkkqdzv2l](/blog/images/2023/10/19/1frgwkkqdzv2l.png)

But what if we start with the salt form of the compound?  In fact, this might be what we expect this to be a more faithful representation of the compound, as we have reacted the acid (nitric acid) with the base (ammonium) to form the ammonium nitrate salt: 

```mathematica
chargedSMILES = "[N+](=O)([O-])[O-].[NH4+]";
MoleculePlot[%]
```

![17csqsown2jg3](/blog/images/2023/10/19/17csqsown2jg3.png)

However, the problem is when we try to convert the charged salt specification to InChI, it gets converted to the neutral form!  

```mathematica
Molecule[chargedSMILES]["InChI"]
%["ExternalID"] == neutralInChI
MoleculePlot[%%]
```

![1rkadrh0hum6s](/blog/images/2023/10/19/1rkadrh0hum6s.png)

```
(*True*)
```

![1pes6llgov785](/blog/images/2023/10/19/1pes6llgov785.png)

However, the resulting InChI keys for the charged specification (by SMILES) and the neutral specification (either by InChI or SMILES) are different !

```mathematica
Molecule[chargedSMILES]["InChIKey"]
{Molecule[neutralInChI]["InChIKey"], Molecule[neutralSMILES]["InChIKey"]}
```

![0zvi5f8l2s4o0](/blog/images/2023/10/19/0zvi5f8l2s4o0.png)

![18wlf613cncoj](/blog/images/2023/10/19/18wlf613cncoj.png)

Note that this is **not** a Mathematica-specific bug; this type of conversion problem also occurs in ChemDraw 22.2, which leads me to think that this is cooked into the underlying InChI specification (or at least the standard library that everyone uses) 

![01wtw8fnp363l](/blog/images/2023/10/19/01wtw8fnp363l.png)



**Recommendation:** This is a problem, as it means that trying to do a database search on InChIKey may not find a match if one party uses the charged SMILES to generate an InChI key and the other party converts it to InChI first before generating the InChI key.  My recommendation is to represent salts as the neutral form (when specifying them by SMILES or InChI) to avoid this problem.  If that is not feasible, convert input strings to InChI first (this will convert the salt back to the neutral acid and base) and then generate a new molecular representation with the resulting InChI to use for generating InChI keys.

```mathematica
ToJekyll["Cheminformatics: SMILES and InChI quirks for salts", "science cheminformatics mathematica chemdraw"]
```
