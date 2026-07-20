---
title: "Imaginary Syllabi: BBQ Science"
date: 2026-07-20
tags: imaginary-syllabi science gpt5
---

**Premise:  A semester-long course on the science and history of barbecue...**

# Learning Goals

By the end of the course, students will be able to:

- Relate muscle structure and composition—including collagen, myoglobin, fat, and water—to the expected cooking behavior and eating quality of specific meat cuts.
- Explain and quantify the combustion and pyrolysis processes that produce heat and smoke, including the relationship between fuel, oxygen availability, smoke composition, and PAH exposure.
- Analyze the chemical and physical transformations occurring during barbecue cooking, including protein denaturation, collagen solubilization, fat rendering, evaporation, smoke deposition, and Maillard browning.
- Construct and evaluate a heat- and mass-transfer model for a barbecue cook, using temperature and mass data to account for conduction, convection, radiation, evaporation, geometry, and the stall.
- Collect, calibrate, and interpret experimental data from meat, fuel, smoke, and temperature-control experiments; communicate uncertainty and apply appropriate food and laboratory safety practices.
- Situate American barbecue within its historical and cultural contexts.

# Pre-reqs

- Gen Chem II, Calc II.

# Reading List

- Goldwyn & Blonder, [Meathead: The Science of Great Barbecue and Grilling](https://amzn.to/4pyro8K) (2016) -- primary resource
- McGee, [On Food and Cooking: The Science and Lore of the Kitchen](https://amzn.to/4hlHsIK) --- classic text on science and cooking; relevance here is Chpt 3 on meat.
- Moss, [Barbecue: The History of an American Institution](https://amzn.to/4fpndqW) (2nd ed, 2025) --A carefully researched history tracing barbecue from Indigenous pit cooking through colonial America into modern regional traditions.
- *(reference material on reserve)* Myhrvold et al [Modernist Cuisine](https://amzn.to/3T0V2Yd) (2011). -- far too exp(a/e)nsive as a required purchase text, but lots of detail on heat transport, meat science, etc. 
- *(reference)* [Lawrie's Meat Science, 9th ed](https://amzn.to/4fh4aPy) ---  classic reference for meat professionals 
- *(reference)* [Meat Evaluation Handbook](https://meatscience.org/publications-resources/printed-publications/meat-evaluation-handbook)

# Labs

**Safety considerations**: Food safety (raw-meat handling), combustion gases, and carcinogenic smoke compounds.

- Meat quality determination (visual inspection, microscopy)
    - [Cryosectioning & imaging of raw and cooked meats](https://pubs.acs.org/doi/10.1021/acsfoodscitech.4c00542)
- Bomb calorimetry of hardwoods & comparison calculations to propane.
- Smoke analysis via [HPLC determination of polyaromatic hydrocarbons ](https://pubs.acs.org/doi/10.1021/ed075p1599) or [GC-MS](https://pubs.acs.org/doi/10.1021/acs.jchemed.0c00179) or [FTIR](https://pubs.acs.org/doi/10.1021/ed078p1665), [or analytical pyrolysis](https://pubs.acs.org/doi/10.1021/ed100108f)
- Properties of ionic solutions:  osmotic pressure, diffusion, ionic strength (for relevance to brining)
- [Differential scanning calorimetry](https://en.wikipedia.org/wiki/Differential_scanning_calorimetry) of collagen denaturation and gelatin gelation
- [Maillard reactions of amino acids and sugars](https://pubs.acs.org/doi/10.1021/acs.jchemed.4c00715)
- [PID controllers](https://en.wikipedia.org/wiki/PID_controller) --- thermocouple calibration, sensor placement, logging uncertainty, and controller tuning. 
- Instrumented slow-cooker/smoker with feedback control
- [Heat transfer modeling](https://reference.wolfram.com/language/PDEModels/tutorial/HeatTransfer/HeatTransfer.html) -- computational lab 

# Example Capstone Projects

- **Predicting the stall:** Develop a heat- and mass-transfer model for pork shoulder or brisket; compare predictions against logged smoker data and explain discrepancies.
- **Fuel, smoke, and flavor:** Compare two hardwoods or charcoal versus hardwood under controlled conditions. Measure temperature profiles, mass loss, and smoke/PAH proxy data; recommend a fuel strategy with safety tradeoffs.
- **Designing a stable smoker:** Build or prototype a PID-controlled slow-cooker/smoker system. Calibrate sensors, tune the controller, quantify temperature stability, and document uncertainty.
- **The science of a regional barbecue:** Select a regional tradition and connect its preferred animal, cut, fuel, cooking method, and sauce to meat science, heat transfer, and its cultural history.
- **Brining as transport science:** Test salt concentration, time, and cut thickness; model diffusion and evaluate effects on mass change, water retention, texture, and sensory results.
- **Collagen, temperature, and tenderness:** Compare low-and-slow cooking schedules for a collagen-rich cut. Use temperature logging and texture/structure observations to identify an evidence-based endpoint.
- **Smoke deposition and surface chemistry:** Investigate how humidity, surface dryness, temperature, or smoke exposure affects bark formation and smoke deposition, while explicitly addressing PAH risk and experimental limitations.
- **A reproducible barbecue protocol:** Create a scientifically justified, reproducible cook protocol for a chosen cut, including ingredient and fuel specifications, sensor placement, control strategy, predicted outcomes, safety plan, and historical context.

# Other resources

- [American Meat Science Association](https://meatscience.org/home)

# Fordham implementation notes

Place in the [new core curriculum](https://www.fordham.edu/about/leadership-and-administration/administrative-offices/office-of-the-provost/about-us/our-work/academic-initiatives/university-core-revision/revised-core-curriculum/):  *Scientific Inquiry*, *Quantitative Inquiry* (esp. if we build up the modeling aspects), *Senior Capstone*. 

Fordham has [history courses](https://bulletin.fordham.edu/undergraduate/history/major/) including *Food and Drink in Modern Society*, *Food Politics*, and *Seminar: Food and Drink in Modern History* on the books.  Possible co-conspirators (perhaps enabling a *History Inquiry* designation?): 

| Name | Focus snapshot |
| --- | --- |
| [Thomas Hertweck](https://www.fordham.edu/academics/departments/english/faculty/thomas-hertweck/) | English / American Studies; food studies, vegan studies, ecocriticism, food packaging, film, and American literature and culture. |
| [Julie Chun Kim](https://www.fordham.edu/academics/departments/english/faculty/julie-chun-kim/) | English; food studies, Afro-Caribbean medicine and food, Indigenous land rights, colonialism, empire, and science. |
| [Thierry Rigogne](https://www.fordham.edu/academics/departments/history/faculty/thierry-rigogne/) | History; early modern food history and the history of cafés; teaches “The Social Life of Coffee” and “Food and Drink in Modern Society.” |

# GenAI use

- `gpt-5.6-terra-medium` used in codex to generate learning goals and possible capstone projects from draft notes and research current course offerings in history and possible collaborators 
