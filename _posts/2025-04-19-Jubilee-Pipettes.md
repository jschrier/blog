---
title: "Jubilee Pipettes"
date: 2025-04-19
tags: diy science jubilee
---

[Moving liquids around is at the core of many automation workflows](https://www.theautomatedlab.com/article.html?content=category-liquid-handling).  **What are our options for doing this on the Jubilee?...**

# OT-2 pipette tool

[building/use documentation](https://science-jubilee.readthedocs.io/en/latest/building/pipette_tool.html)

**Pros:**
- Semi-commercial product with some known characteristics
- Build and use instructions for Jubilee exist

**Cons:**
- Expensive ($2500!)

# Syringe tool

[build/use documentation](https://science-jubilee.readthedocs.io/en/latest/building/syringe_tool.html)

**Pros:**
- We were gifted one...so nothing to build (but even if you had to build, this is relatively low cost)

**Cons:**
- No ejectable tips; if worried about contamination, need to wash the end of the syringe

# Open Lab Automation Pipette   

[build/use documentation](https://docs.openlabautomata.xyz/Mini-Docs/Tools/Micropipetas/)

**Pros:**
- All open-source solution, relatively low cost
- Tip ejection (by pulling against a fork structure)
- Claims 2-1000 uL range, when used with appropriate tips

**Cons:**
- Looks a bit top-heavy, and construction has some complications

# Clip tip

[build/use documentation](https://www.slas-technology.org/article/S2472-6303(24)00121-3/fulltext)

**Pros:**
- Relatively simple construction:  Main mechanism is a Thermo ClipTip replacement assembly ($150) and a linear stepper ($100) with minimal 3d-printed parts and limit switch to attach
- Tip ejection achieved by pulling against a fork structure 
- Clip tip assemblies are availabile in different ranges

**Cons:**
- Needs mechanical & configuration adaptation for Jubilee
- Needs appropriate calibration