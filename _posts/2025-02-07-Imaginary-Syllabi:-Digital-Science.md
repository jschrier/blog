---
title: "Imaginary Syllabi: Digital Science"
date: 2025-02-07
tags: science teaching imaginary-syllabi
---

**Premise:** A multi-course undergraduate sequence resulting in a concentration/minor in [digitalized science](https://doi.org/10.1039/D4DD00130C)...

# Backstory

- Fordham core curriculum revision proposal leans us in this direction...

- It's not a totally crazy idea for a topic, as other places have recently created degree programs like this:
    - [University of Liverpool offers a 12-month MSc in Digital Chemistry:](https://www.liverpool.ac.uk/courses/2025/digital-chemistry-msc) AI, Machine Learning, Automation and Robotics which blends computational and electronics/mechatronics
    - [Imperial College London offers a 12 month MSc in Digital Chemistry with AI and Automation ](https://www.imperial.ac.uk/study/courses/postgraduate-taught/digital-chemistry/#Default)...more of a focus on computational skills
    - [University of York](https://www.york.ac.uk/chemistry/research/digital-chemistry/), [Leeds](https://www.york.ac.uk/chemistry/research/digital-chemistry/), and [Southampton](https://www.southampton.ac.uk/courses/digital-chemistry-masters-msc) also offer similar courses. 
    - [University of Gdansk also offers an Digital Chemistry MSc course](https://digital.chem.ug.edu.pl/), more of a focus on computational chemistry

# Requirements

Consider this minor/concentration as comprising seven courses: (yes, a typical minor is 6 courses, but, whatever...)

1. Chem OR phys OR bio OR CS or Math courses outside your major requirements (e.g., a computer science major takes a year of chem, a chem major takes two CS courses or one CS + one advanced math, etc. ). In general, we would expect lab ("natural") scientists to take these in CS/Math, and vice versa. At least one of these should be a programming course.

2.  A second Chem  or bio or CS or Math course outside your major requirements

3. Methods in Computational Science

4. Methods of Laboratory Automation

5. Elective course (see below)

6. Another elective course (see below)

7. Case Studies in Digital Science



# Courses

In general, courses would be envisioned to have flexible pre-requisites to allow a broad variety of students to enroll, not necessarily restricted to students within a given major or registered for the program.  

Notice that these are all framed in a general way, but they lean chemistry-adjacent. 

## Methods of Laboratory Automation

- **Pre-req:** At least one previous college-level lab course (chem/bio/phys)

- **Learning goal:** Acquire basic data handling, ML, and electromechanical skills needed to use/operate automated experiments

- **Possible Reference points:** Model this on the [University of Toronto 4010 & 4132 microcredential courses  "Introduction to AI for Discovery Using Self-Driving Labs" and "Autonomous Systems for Self-Driving Labs" ](https://learn.utoronto.ca/programs-courses/certificates/autonomous-systems-discovery), each of which takes about a month to complete and only has "some familiarity with python programming" as a pre-req 

- **Lab/practicum**:  Adopt a [frugal twin approach](https://doi.org/10.1039/D3DD00223C).  Students build/operate a [chemputer](https://doi.org/10.1038/s41557-022-01016-w), basic liquid handler ([OT-2](https://opentrons.com/products/ot-2-robot) or [something more homebrew](https://doi.org/10.1016/j.slast.2024.100239)), maybe a robot-arm or two.  Learn some microcontroller programming/[internet of science things](https://chem.libretexts.org/Courses/Intercollegiate_Courses/Internet_of_Science_Things/1%3A_IOST_Modules) type skills with Raspberry Pi + various sensors and actuators.
    - Maybe do some color mixing experiments or [pH/buffer relationship discovery](https://link.springer.com/article/10.1557/s43577-022-00430-2) or [electrochemistry](https://pubs.rsc.org/en/content/articlehtml/2024/dd/d4dd00186a) or [synthesize aspirin by chemputer](https://pubs.acs.org/doi/10.1021/acs.jchemed.2c00503)

- **Additional Audience:**  Engineering physics majors

## Methods in Computational Science

- **Pre-req:** At least one previous college-level CS or math course 

- **Topics**
    - Introduction to computational thinking/programming
    - Numerical / scientific computing 
    - Machine Learning & AI for Science

- **Possible Reference points:** Model this on the [University of Toronto 4131 & 4133 microcredential courses  "AI and Materials Databse for Self-Driving Labs" and "Software Development for Self Driving Labs" ](https://learn.utoronto.ca/programs-courses/certificates/autonomous-systems-discovery), each of which takes about a month to complete, and only has "some familiarity with python programming" as a pre-req 

- **Additional Audience**: Broad...computer science/applied math?

## Case Studies in Digital Science

- **Premise**: Get students reading and reproducing the current literature.  Somewhere between a seminar/survey course and a capstone project course where students adapt one or more of the papers they read to solve their own problem or do something novel with one of the datasets.

- Use [Digital Discovery](https://pubs.rsc.org/en/journals/journalissues/dd#!recentarticles&adv) as the resource...lots of variety, and we know that because of the [code/data review ploicy](https://www.rsc.org/journals-books-databases/about-journals/digital-discovery#guidelines-dd) that students should be able to reproduce the results. Open access journal.  [Good editorial board](https://www.rsc.org/journals-books-databases/about-journals/digital-discovery/#team)

- Could fulfil [EP3-style requirements](https://bulletin.fordham.edu/undergraduate/fordham-college-core-curriculum/distributive-requirements/#text) or whatever they are called in the new system

- **Additional Audience:**  Computer science majors?

## Additive manufacturing (aka Digital Materials Science)

- **Learning goals:** An introduction to materials science (polymer / ceramics / metals), with the twist that it is done through 3d-printing as a tool.  Acquire competency in 3d-printing techniques and associated skillsets (e.g., CAD design)

- **Textbook** At the level of [Shakelford's intro textbook]((https://amzn.to/3JNUFbz) ); implies a review of general chemistry concepts associated with bonding and thermo.

- **Lab:** Use the lab do a bunch of AM modalities.  [I have a lot of thoughts on this, see more extensive notes on specific methodologies and structure]({{ site.baseurl }}{% post_url 2024-08-05-Imaginary-Syllabi:-Additive-Manufacturing-Lab %} )  

- **Additional Audience:**  Very low pre-reqs, potentially open to visual art majors, etc. 

## Computational Physics 

- (Already exists: [Phys 3211/4211](https://bulletin.fordham.edu/courses/phys/))...perhaps one of the earlier courses could play the role of Phys 3211, reserving 4211 as the elective 


## Computational Chemistry 

- (Already exists: Chem3621, with pre-req of Physical chemistry)

- Focus on simulation-based methods in quantum mechanics and thermodynamics 

- **Textbook** [Intro to Computational Physical Chemistry](https://uscibooks.aip.org/books/introduction-to-computational-physical-chemistry/) 

## Bioinformatics & Cheminformatics

- **Pre-req:**  some type of biochemistry & chemistry coursework? (but even this might not be necessary, see below)

- **Learning goal**: Working with biological and chemical data (not as physical simulations)

- Bioinformatics (There is already a [Bioinformatics minor](ht tps://www.fordham.edu/academics/departments/computer-and-information-science/academic-programs/undergraduate-programs/bioinformatics-minor/) offered by CIS)
- Cheminformatics 

- **Resources**:
    - Have students work through [Project Rosalind](https://rosalind.info/problems/locations/), perhaps in programming language of choice 
    - [Bioinformatics Algorithms: An Active Learning Approach](https://www.bioinformaticsalgorithms.org/) great book, designed for use with [Project Rosalind](https://rosalind.info/problems/locations/), assumes very little prior biology 
    - [Full spectrum bioinformatics](https://github.com/zaneveld/full_spectrum_bioinformatics) free textbook, seems decent, but I like the previous one better
    - [Cheminformatics libretext](https://chem.libretexts.org/Courses/Intercollegiate_Courses/Cheminformatics )... It would be fun to develop a Project Rosalind-style resource for this too.

- **Additional Audience:**  Bio majors? 

## Drug Design 

- Focus on computational drug design
- Repackage [Chem1102](https://bulletin.fordham.edu/courses/chem/), dropping the EP1 and business/social aspects to focus on the drug design component
- Pre-reqs could be light, if we assume that we'll have to (re)teach some orgo and biochemistry

- **Additional Audience:**  pre-meds and bio majors
