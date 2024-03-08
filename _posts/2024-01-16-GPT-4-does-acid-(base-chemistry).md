---
title: "GPT-4 does acid (base chemistry exam questions)"
date: 2024-01-16
tags: science teaching gpt4 llm mathematica
---

A recent paper (Clark et al. "Comparing the Performance of College Chemistry Students with ChatGPT for Calculations Involving Acids and Bases", [J.Chem. Educ. 2023, 100, 3934-3944](https://doi.org/10.1021/acs.jchemed.3c00500) ) evaluated 10 acid base equilibrium questions on students and using ChatGPT 3.5, performing both qualitative assessments of the methodology and quantitative assessment of whether the correct answer was reached.  ChatGPT questions were evaluated 20 times to see the distribution of answers.  Simple questions about strong acids had high success rates, but some questions, like those about salts, did poorly.  For example, the question "Calculate the pH of 0.25 M NH4Cl. Kb for NH3 = 1.8 *10^-5." returned the correct answer only 10% of the time.  Another challenging question involved titrations. This raises two natural questions: **(i) Would they get better results by using GPT-4?  (ii) What about using modern prompting strategies (COT, ReAct) and tools?**

## Sample Problem: pH of a salt solution.

Here is a sample problem, for which they only get 10% correct:

**Q3 (acid):**  *Calculate the pH of 0.25 M NH4Cl. Kb for NH3 = 1.8 *10^-5.*

**ANSWER:**  Set up an ICE table, etc. See [OpenStax](https://openstax.org/books/chemistry-2e/pages/14-4-hydrolysis-of-salts) if you are rusty on acid/base equilibrium calculations.

Direct calculation (without approximating that the starting [H3O+] = 0) yields:

```mathematica
Clear[x]
With[ (*solve for the change*) 
   {Kb = 1.8*10^-5, 
    Kw = 10^-14}, 
   NSolveValues[Kw/Kb == (10^-7 + x)*x/(0.25 - x), x, PositiveReals]] 
 
-Log[10, % + 10^-7] (* evaluate pH *)

(*{0.0000117349}*)

(*{4.92683}*)
```

Making the common assumption that [H3O+] = 0 yields:

```mathematica
With[ (*solve for the change*) 
   {Kb = 1.8*10^-5, 
    Kw = 10^-14}, 
   NSolveValues[Kw/Kb == ( x)*x/(0.25 - x), x, PositiveReals]] 
 
-Log[10, %] (*evaluate pH*)


(*{0.0000117848}*)

(*{4.92868}*)
```

So the approximation is a good one.  If you are a hardass on significant figures, then you will only report this as 4.93 (in either case), as we only have two sig figs in Kb and the initial concentration. 

### Evaluation with default GPT-4

We are going to do this programmatically, because I do not like the tedium of grading.  We define a base configuration using `gpt-4-1106-preview` and return the result in a formatted way.  By default, [LLMSynthesize](http://reference.wolfram.com/language/ref/LLMSynthesize.html) uses T = 1, but we will set that explicitly for reproducibility:

```mathematica
baseConfig = LLMConfiguration[
    <|"Prompts" -> 
      "Your goal is to answer a QUESTION. When you are complete, report the final numerical answer in the form \"ANSWER: number\"\n", 
     "Model" -> "gpt-4-1106-preview", 
     "Temperature" -> 1|>]; (*defaut temperature for LLM Synthesize*)

```

We also want to read out the results in an automatic way (we will defer scoring them automatically, just to see what the types of errors are):

```mathematica
parseAnswer[text_String] := Interpreter[Number]@Last@
    StringCases[text, StartOfLine ~~ "ANSWER: " ~~ x___ ~~ EndOfString :> x]
```

How well does it do?

```mathematica
result = LLMSynthesize[
   "QUESTION: Calculate the pH of 0.25 M NH4Cl. Kb for NH3 = 1.8 *10^-5.", 
   LLMEvaluator -> baseConfig]
```
```
To calculate the pH of a 0.25 M solution of NH4Cl, we need to find the concentration of H+ ions in the solution. NH4Cl is a salt that dissociates completely in water to form NH4+ and Cl- ions. The NH4+ ion is the conjugate acid of the weak base NH3, and it can react with water to donate a proton (H+ ion), increasing the acidity of the solution.

The reaction of NH4+ with water is as follows:

NH4+ + H2O \[Equilibrium] NH3 + H3O+

The equilibrium constant expression for the reaction of NH4+ with water (Kw/Kb) can be written in terms of the Kb for NH3 since NH4+ is the conjugate acid of NH3:

Kw = Kb * Ka

Where:
- Kw is the ion-product constant for water at 25°C (1.0 * 10^-14).
- Kb is the base ionization constant for NH3 (1.8 * 10^-5).
- Ka is the acid ionization constant for NH4+.

To find Ka, we use:

Ka = Kw / Kb

Ka = (1.0 * 10^-14) / (1.8 * 10^-5)
Ka = 5.56 * 10^-10

Now, we use the acid dissociation constant, Ka, to find the concentration of H+ from the dissociation of NH4+. For the dissociation of NH4+:

NH4+ \[Equilibrium] NH3 + H+

At equilibrium, we have:

[NH4+] = 0.25 - x (where x is small compared to 0.25, so we can approximate [NH4+] \[TildeTilde] 0.25 M because Ka is small)
[NH3] = x
[H+] = x

The expression for Ka is:

Ka = ([NH3][H+]) / [NH4+]

Substituting the equilibrium concentrations, we get:

5.56 * 10^-10 = (x * x) / 0.25
5.56 * 10^-10 = x^2 / 0.25
x^2 = 5.56 * 10^-10 * 0.25
x^2 = 1.39 * 10^-10
x = \[Sqrt](1.39 * 10^-10)
x = 1.18 * 10^-5

The concentration of H+ ions (x) in the solution is approximately 1.18 * 10^-5 M. The pH is calculated using the formula:

pH = -log[H+]

Substituting the value of [H+] we found:

pH = -log(1.18 * 10^-5)
pH \[TildeTilde] 5 - log(1.18)

We can estimate log(1.18) as roughly 0.07 (since log(1.2) is about 0.08). Therefore:

pH \[TildeTilde] 5 - 0.07
pH \[TildeTilde] 4.93

The pH of the 0.25 M NH4Cl solution is approximately 4.93.

ANSWER: 4.93
```

Our function just pulls out the result:

```mathematica
parseAnswer[result]

(*4.93*)
```

### GPT-4 does much better than the GPT-3.5 results reported

Reasoning looks fine and the answer is correct!  Now run 20 independent copies (in parallel) to see how the results vary:

```mathematica
results = ParallelTable[
    LLMSynthesize[
     "QUESTION: Calculate the pH of 0.25 M NH4Cl. Kb for NH3 = 1.8 *10^-5.", 
     LLMEvaluator -> baseConfig], 
    {20}];
```

```mathematica
answers = parseAnswer /@ results

(*{4.929, 5.43, 4.93, 4.93, 5.43, 4.93, 5.43, 5.071, 4.929, 4.929, 4.9281, 5.43, 4.93, 5.43, 4.93, 4.93, 4.93, 5.43, 5.43, 4.929}*)
```

Amazing!  We get it right 12/20 = 60% (as compared to only 10% reported in Clark et al.) Maybe [GPT-4's dreams of attending medical school](https://doctortanc.substack.com/p/ai-llm-outperforms-physicians-in#:~:text=Key%20Findings,(59.1%25%20vs%2033.6%25).) have not been crushed by the gen chem exam.... Perhaps also worth noting, is that in their paper, only 32% of Gen Chem students and 38% of Analytical Chemistry students got this correct, even after instruction....so GPT-4 out of the box is doing better than the typical large Midwestern university student. 

Take a closer look at one of the results that GPT-4 got wrong:

```mathematica
results[[2]]
```

```
To calculate the pH of a solution of 0.25 M NH4Cl, we need to consider the hydrolysis of the NH4+ ion in water. NH4Cl is the salt of a weak base (NH3) and a strong acid (HCl). When NH4Cl dissolves in water, it dissociates completely to give NH4+ and Cl- ions. The chloride ion is a conjugate of the strong acid HCl and does not react with water. However, NH4+ can react with water in a hydrolysis reaction, producing acidic solutions.

The reaction for the hydrolysis of ammonium ion (NH4+) is as follows:

NH4+ (aq) + H2O (l) \[Equilibrium] NH3 (aq) + H3O+ (aq)

The equilibrium expression (Ka) for this reaction can be linked to the Kb of NH3 through the relation:

Ka * Kb = Kw

Where Kw is the ion-product constant of water (1.0 * 10^-14 at 25°C).

Given that the Kb of NH3 is 1.8 * 10^-5, we can calculate the Ka of NH4+:

Ka = Kw / Kb
Ka = (1.0 * 10^-14) / (1.8 * 10^-5)
Ka = 5.56 * 10^-10

Now, we use the Ka to establish the equilibrium concentration of the ions involved in the hydrolysis reaction. For the reaction NH4+ \[Equilibrium] NH3 + H3O+, the expression for the Ka is:

Ka = [NH3][H3O+] / [NH4+]

Assuming that x is the concentration of H3O+ formed (which is also the concentration of NH3 at equilibrium), we have:

Ka = x^2 / (0.25 - x)

Since Ka is much smaller than the initial concentration of NH4+, we can make the approximation that (0.25 - x) \[TildeTilde] 0.25. Therefore, the equation simplifies to:

Ka \[TildeTilde] x^2 / 0.25
5.56 * 10^-10 = x^2 / 0.25
x^2 \[TildeTilde] 5.56 * 10^-10 * 0.25
x^2 \[TildeTilde] 1.39 * 10^-10

Taking the square root of both sides:

x = \[Sqrt](1.39 * 10^-10)
x \[TildeTilde] 3.73 * 10^-6 M

The concentration of H3O+ ions is equivalent to the hydronium ion concentration in the solution, which we can use to calculate the pH:

pH = -log[H3O+]
pH = -log(3.73 * 10^-6)
pH \[TildeTilde] 5.43

The pH of the 0.25 M NH4Cl solution is approximately 5.43.

ANSWER: 5.43
```

The strategy looks OK, but it looks like some of the arithmetic went awry.  But...we wouldn't have a student do these calculations without a calculator (or at least a slide rule...) and neither should we expect a large *language* model to perform precise numerical calculations.  Fortunately, [in a previous post we showed how to give LLMs a calculator]({{ site.baseurl }}{% post_url 2024-01-09-Accurate-and-safe-LLM-numerical-calculations-using-Interpreter-and-LLMTools %}).  (As an aside, it would be functionally easier to just let the LLM use the [Wolfram Alpha tool](https://resources.wolframcloud.com/LLMToolRepository/resources/WolframAlpha/), but we don't want to be accused of cheating by having this side tool that is stronger than a calculator.  However, in a practical sense, the ChatGPT web app easily lets you [include Wolfram Alpha as a plugin](https://www.wolfram.com/wolfram-plugin-chatgpt/).)

### If you give an LLM a calculator...

Just copy and paste the calculator code from the [previous post](({{ site.baseurl }}{% post_url 2024-01-09-Accurate-and-safe-LLM-numerical-calculations-using-Interpreter-and-LLMTools %})).  

```mathematica
calculate = LLMTool[
    {"calculate", (*name*)
     "e.g. calculate: 1+1\ne.g. calculate: 1+Sin[3.2 Pi]\nRuns a calculation and returns a number - uses Wolfram language as determined by  Interpreter[\"ComputedNumber\"]\n"}, (*description*)
    "expression" -> "ComputedNumber", (*interpreter applied directly to input*)
    ToString[#expression] &]; (*convert back to string to return to LLM*)

```

Modify the configuration to use the tool.  

```mathematica
calculatorConfig = LLMConfiguration[
    <|"Prompts" -> 
      "Your goal is to answer a QUESTION. Whenever you need to perform a numerical calculation use the provided tool.  Remember that  the correct expression for calculating the pH from c = the H3O+ concentration is \"-Log[10, c]\", because pH is calculated as Log-base-10, whereas the default Wolfram command is a natural logarithm.\nWhen you are complete, report the final numerical answer in the form \"ANSWER: number\"\n", 
     "Model" -> "gpt-4-1106-preview", 
     "Tools" -> calculate, 
     "Temperature" -> 1|>]; (*default temperature for LLM Synthesize*)

```

Now just pose the question again:

```mathematica
resultsQ3aCalc = ParallelTable[
     LLMSynthesize[
      "QUESTION: Calculate the pH of 0.25 M NH4Cl. Kb for NH3 = 1.8 *10^-5.", 
      LLMEvaluator -> calculatorConfig], 
     {20}]; 
 
parseAnswer /@ %

```

![14p7ctuxlw0k6](/blog/images/2024/1/16/14p7ctuxlw0k6.png)

**Comment:**  Results are just about the same (12/20 right answers), and we are getting a few cases where we do not get a numerical result returned.  Let's start by looking at the first error:

```mathematica
resultsQ3aCalc[[2]]
```

```
The pH of a solution of NH4Cl can be determined by first calculating the hydroxide ion (OH\[Minus]) concentration from the dissociation of NH3 in water, which is a base. NH4Cl is the salt of a weak base (NH3) and a strong acid (HCl), and in water it will dissociate to form NH4+ and Cl\[Minus] ions. The NH4+ ions will react with water to produce H3O+ (hydronium) ions and NH3 (ammonia). The balance for ammonia can be described by its Kb (base dissociation constant).

The reaction is as follows:
NH4+ + H2O \[Equilibrium] NH3 + H3O+

We do not have a direct Kb for NH4+, but we can find the Ka (acid dissociation constant) for NH4+ by using the relation Kw = Ka * Kb, where Kw is the ion-product constant of water (1.0 x 10^-14 at 25°C).

First, let's find the Ka for NH4+.

\[ Ka = \frac{Kw}{Kb} \]

\[ Ka = \frac{1.0 \times 10^{-14}}{1.8 \times 10^{-5}} \]

Let's calculate that:

The calculation has returned the value \(5.55556 \times 10^{-10}\) for the Ka of NH4+. Now that we have Ka, we can use it to calculate the concentration of H3O+ ions.

For the NH4+ dissociation, the reaction is:

\[ \text{NH4+} \rightarrow \text{NH3} + \text{H3O+} \]

Given that the initial concentration of NH4+ is 0.25 M, we can set up an ICE table (Initial, Change, Equilibrium) for concentrations:

Initial:
\[ \text{[NH4+]} = 0.25 \, M \]
\[ \text{[NH3]} = 0 \, M \]
\[ \text{[H3O+]} = 0 \, M \]

Change:
\[ \text{[NH4+]} = -x \]
\[ \text{[NH3]} = +x \]
\[ \text{[H3O+]} = +x \]

Equilibrium:
\[ \text{[NH4+]} = 0.25 - x \]
\[ \text{[NH3]} = x \]
\[ \text{[H3O+]} = x \]

The Ka expression is:

\[ Ka = \frac{\text{[NH3]} \times \text{[H3O+]}}{\text{[NH4+]}} \]

Assuming \( x \ll 0.25 \), which is reasonable since we're dealing with a weak acid, the expression simplifies to:

\[ 5.55556 \times 10^{-10} = \frac{x \times x}{0.25} \]

\[ 5.55556 \times 10^{-10} = \frac{x^2}{0.25} \]

\[ x^2 = (5.55556 \times 10^{-10}) \times 0.25 \]

Let's calculate \( x \) (the concentration of H3O+):

The concentration \( x \) (the concentration of H3O+) is \(1.38889 \times 10^{-10}\) M. Now, to find the pH, we use the formula:

\[ \text{pH} = -\log_{10}[\text{H3O+}] \]

Substituting the H3O+ concentration into this formula gives:

\[ \text{pH} = -\log_{10}(1.38889 \times 10^{-10}) \]

Let's perform this calculation:

The pH of the 0.25 M NH4Cl solution is 9.85733.

ANSWER: 9.85733
```

**Comment:**  The Failure results appear to be because the evaluation terminated (*vide infra*)--it looks like the response stopped midstream (perhaps it timed out on waiting for a tool response?) We could improve this by checking to see if a valid ANSWER is reported, and if not, either repeating or restarting the calculation:

```mathematica
resultsQ3aCalc[[8]]
```

```
To calculate the pH of a solution of \( NH_4Cl \), we first need to determine the concentration of hydroxide ions (\( OH^- \)) that result from the reaction of ammonium (\( NH_4^+ \)) with water to produce ammonia (\( NH_3 \)) and hydrogen ions (\( H^+ \)).

The dissociation of \( NH_4^+ \) in water is as follows:
\[ NH_4^+ + H_2O \rightleftharpoons NH_3 + H^+ \]

Since we're given the \( K_b \) for \( NH_3 \), we can write the reaction for the ionization of \( NH_3 \) in water and use it to find the \( K_a \) for \( NH_4^+ \). The reactions are the reverse of each other.

\[ NH_3 + H_2O \rightleftharpoons NH_4^+ + OH^- \]
\[ K_b = 1.8 \times 10^{-5} \]

The ionization constant of water (\( K_w \)) is \( 1 \times 10^{-14} \) at 25°C. The \( K_a \) of \( NH_4^+ \) is the dissociation constant for the reaction of \( NH_4^+ \) with water to form \( H^+ \) and \( NH_3 \). We can find \( K_a \) using the relation:

\[ K_w = K_a \times K_b \]

Let's calculate the value of \( K_a \) of \( NH_4^+ \):

\[ K_a = \frac{K_w}{K_b} \]
```

### Reflect on your result

Chain of Thought and Self-Reflection are powerful strategies for creating LLM agents (see [previous post on LLM agents](({{ site.baseurl }}{% post_url 2024-01-13-Implementing-the-ReAct-LLM-Agent-pattern-the-hard-way-and-the-easy-way %}))). This is how we teach students too: When you calculate an answer, see if it is plausible--we wouldn't expect the salt of a strong base should be a weak acid, so we would expect a weakly acidic pH as the answer.  This would correct some of the errors we saw .  Here we try an experiment where we do NOT provide a calculator, but DO ask for self reflection:

```mathematica
reflect = LLMConfiguration[
    <|"Prompts" -> 
      "Your goal is to answer a QUESTION. Before you return the final answer, evaluate whether it is a reasonable answer.  If it is not a reasonable answer, repeat the calculation. When you are complete, report the final numerical answer in the form \"ANSWER: number\"\n", 
     "Model" -> "gpt-4-1106-preview", 
     "Temperature" -> 1|>]; 

```

```mathematica
resultsQ3aReflect = ParallelTable[
     LLMSynthesize[
      "QUESTION: Calculate the pH of 0.25 M NH4Cl. Kb for NH3 = 1.8 * 10^-5.", 
      LLMEvaluator -> reflect], 
     {20}]; 
 
parseAnswer /@ %


(*{4.93, 4.93, 5.43, 4.928, 4.93, 4.93, 4.93, 4.93, 4.929, 4.928, 5.43, 4.95, 5.428, 4.952, 4.93, 4.93, 4.93, 4.929, 4.929, 4.93}*)
```

This result (17/20) is only marginally better than our first attempt where we did not ask for reflection.

### Reflect and calculate

Now give the bot a calculator along with asking it to reflect on its answer:

```mathematica
reflectAndCalculate = LLMConfiguration[
     <|"Prompts" -> 
       "Your goal is to answer a QUESTION. Think step by step and use the available tool to perform any numerical calculations. Whenever you need to perform a numerical calculation use the provided tool.  Remember that  the correct expression for calculating the pH from c = the H3O+ concentration is \"-Log[10, c]\", because pH is calculated as Log-base-10, whereas the default Wolfram command is a natural logarithm.\n Before you return the final answer, evaluate whether it is a reasonable answer.  If it is not a reasonable answer, repeat the calculation. When you are complete, report the final numerical answer in the form \"ANSWER: number\"\n", 
      "Model" -> "gpt-4-1106-preview", 
      "Tools" -> {calculate}, 
      "Temperature" -> 1|>]; 
 
resultsQ3aReflectAndCalculate = ParallelTable[
     LLMSynthesize[
      "QUESTION: Calculate the pH of 0.25 M NH4Cl. Kb for NH3 = 1.8 * 10^-5.", 
      LLMEvaluator -> reflectAndCalculate], 
     {20}]; 
 
parseAnswer /@ %

(*{4.93, 4.92867, 4.93, 4.93, 4.93, 4.93, 4.93, 4.93, 4.93, 4.93, 4.93, 4.93, 4.92867, 4.93, 4.92867, 4.92867, 4.92867, 4.93, 4.93, 4.93}*)
```

**Comment:**  100%. GPT-4 is now at the head of the class! 

## Another sample problem: Titration of a weak base by a strong acid

The Clark et al. study reports GPT-3.5 (and analytical chemistry undergraduate students) had a *complete* failure rate on the following problem:

**Q5a** *If 25.0 mL of 0.25 M HNO3 is combined with 15.0 mL of 0.25 M CH3NH2, what is the pH? Kb for CH3NH2 = 4.38 * 10^-4*

***Answer:**  There is a stoichiometric excess of 2.5 mmol of the strong acid titrant, so one can ignore the base ([see OpenStax](https://openstax.org/books/chemistry-2e/pages/14-7-acid-base-titrations))  The total volume of analyte and titrant is 40.0 mL, so just form the ratio to determine [H3O+] and calculate the pH:

```mathematica
-Log[10, 2.5/40.0]

(*1.20412*)
```

We have 2 sig figs (molarity of the solutions), so at best we have two sig figs in the result 1.20, but I will grade the LLM leniently for this.

### How well does  GPT-4 perform (without calculators or reflection)?

```mathematica
resultQ5a = LLMSynthesize[
   "QUESTION: If 25.0 mL of 0.25 M HNO3 is combined with 15.0 mL of 0.25 M CH3NH2, what is the pH? Kb for CH3NH2 = 4.38 * 10^-4", 
   LLMEvaluator -> baseConfig]
```

```
To calculate the pH of the solution when HNO3 is combined with CH3NH2, we need to consider the acid-base neutralization reaction that will take place. The reaction can be represented as:

HNO3 (strong acid) + CH3NH2 (weak base) \[RightArrow] CH3NH3+ (conjugate acid) + NO3\[Minus] (conjugate base)

Because HNO3 is a strong acid and CH3NH2 is a weak base, the reaction will proceed to completion, consuming the limiting reactant and forming the conjugate acid of the weak base, CH3NH3+.

Now we need to find out which reactant is limiting. This can be done by calculating the moles of both reactants.

Moles of HNO3 = Molarity * Volume = 0.25 mol/L * 0.025 L = 0.00625 mol
Moles of CH3NH2 = Molarity * Volume = 0.25 mol/L * 0.015 L = 0.00375 mol

The moles of HNO3 are greater than the moles of CH3NH2, thus CH3NH2 is the limiting reactant.

All of the CH3NH2 will react with the HNO3 to form CH3NH3+. Since there are more moles of HNO3 initially, there will be an excess of HNO3 after the reaction. We can calculate the remaining moles of HNO3:

Remaining moles of HNO3 = Initial moles of HNO3 - Initial moles of CH3NH2
Remaining moles of HNO3 = 0.00625 mol - 0.00375 mol = 0.0025 mol

Now, we can calculate the concentration of the remaining HNO3. The total volume of the solution after mixing is the sum of the volumes of the reactants:

Total volume = 25.0 mL + 15.0 mL = 40.0 mL = 0.040 L

Concentration of remaining HNO3 = Remaining moles of HNO3 / Total volume
Concentration of remaining HNO3 = 0.0025 mol / 0.040 L = 0.0625 M

Since HNO3 is a strong acid that dissociates completely, the concentration of HNO3 will be equal to the concentration of H+ ions in the solution.

pH is related to the concentration of H+ by the following equation:

pH = -log10[H+]

Since [H+] = [HNO3] after the reaction with the weak base CH3NH2, we have:

pH = -log10[0.0625]

Let's calculate the pH:

pH = -log10(0.0625) 
pH \[TildeTilde] -(log10(1/16))
pH \[TildeTilde] -(log10(1) - log10(16))
pH \[TildeTilde] -(0 - log10(2^4))
pH \[TildeTilde] -(0 - 4 * log10(2))
pH \[TildeTilde] -(-4 * 0.3010) (since log10(2) \[TildeTilde] 0.3010)
pH \[TildeTilde] 4 * 0.3010
pH \[TildeTilde] 1.204

So the pH of the solution is 1.204.

ANSWER: 1.204
```

This is correct (ignoring  significant figures). Go ahead and calculate 20 of these:

```mathematica
resultsQ5a = ParallelTable[
     LLMSynthesize[
      "QUESTION: If 25.0 mL of 0.25 M HNO3 is combined with 15.0 mL of 0.25 M CH3NH2, what is the pH? Kb for CH3NH2 = 4.38 * 10^-4", 
      LLMEvaluator -> baseConfig], 
     {20}]; 
 
parseAnswer /@ %
```

![0lu451ca6cmey](/blog/images/2024/1/16/0lu451ca6cmey.png)

We get 15/20 = 75% correct just using GPT-4 out of the box.  (The gateway error is a technical problem, probably because OpenAI doesn't like us banging on their door or the WiFi is dodgy at my house.) Remember for comparison, Clark *et al.* reported that only 18% of Gen Chem students and 0% of Analytical Chem students at the large Midwestern university answered this correctly, even after instruction, and GPT-3.5 was also 0%.  So again we get a big jump just by using a more recent version of GPT-4....but can we do better?  

### How well does GPT-4 perform (*with* calculators and reflection)?

This strategy worked well before...will it work well here too?

```mathematica
resultQ5aReflectAndCalculate = ParallelTable[
     LLMSynthesize[
      "QUESTION: If 25.0 mL of 0.25 M HNO3 is combined with 15.0 mL of 0.25 M CH3NH2, what is the pH? Kb for CH3NH2 = 4.38 * 10^-4", 
      LLMEvaluator -> reflectAndCalculate], 
     {20}]; 
 
parseAnswer /@ %
```

![0xe20bgn6b661](/blog/images/2024/1/16/0xe20bgn6b661.png)

**Comment:**  18/20 ran without a hitch!  Let's take a look at the two failures:

```mathematica
resultQ5aReflectAndCalculate[[{1, 6}]]
```

```
To calculate the pH of the solution when HNO3 is combined with CH3NH2, we need to consider the acid-base neutralization reaction that will take place. The reaction can be represented as:

HNO3 (strong acid) + CH3NH2 (weak base) \[RightArrow] CH3NH3+ (conjugate acid) + NO3\[Minus] (conjugate base)

Because HNO3 is a strong acid and CH3NH2 is a weak base, the reaction will proceed to completion, consuming the limiting reactant and forming the conjugate acid of the weak base, CH3NH3+.

Now we need to find out which reactant is limiting. This can be done by calculating the moles of both reactants.

Moles of HNO3 = Molarity * Volume = 0.25 mol/L * 0.025 L = 0.00625 mol
Moles of CH3NH2 = Molarity * Volume = 0.25 mol/L * 0.015 L = 0.00375 mol

The moles of HNO3 are greater than the moles of CH3NH2, thus CH3NH2 is the limiting reactant.

All of the CH3NH2 will react with the HNO3 to form CH3NH3+. Since there are more moles of HNO3 initially, there will be an excess of HNO3 after the reaction. We can calculate the remaining moles of HNO3:

Remaining moles of HNO3 = Initial moles of HNO3 - Initial moles of CH3NH2
Remaining moles of HNO3 = 0.00625 mol - 0.00375 mol = 0.0025 mol

Now, we can calculate the concentration of the remaining HNO3. The total volume of the solution after mixing is the sum of the volumes of the reactants:

Total volume = 25.0 mL + 15.0 mL = 40.0 mL = 0.040 L

Concentration of remaining HNO3 = Remaining moles of HNO3 / Total volume
Concentration of remaining HNO3 = 0.0025 mol / 0.040 L = 0.0625 M

Since HNO3 is a strong acid that dissociates completely, the concentration of HNO3 will be equal to the concentration of H+ ions in the solution.

pH is related to the concentration of H+ by the following equation:

pH = -log10[H+]

Since [H+] = [HNO3] after the reaction with the weak base CH3NH2, we have:

pH = -log10[0.0625]

Let's calculate the pH:

pH = -log10(0.0625) 
pH \[TildeTilde] -(log10(1/16))
pH \[TildeTilde] -(log10(1) - log10(16))
pH \[TildeTilde] -(0 - log10(2^4))
pH \[TildeTilde] -(0 - 4 * log10(2))
pH \[TildeTilde] -(-4 * 0.3010) (since log10(2) \[TildeTilde] 0.3010)
pH \[TildeTilde] 4 * 0.3010
pH \[TildeTilde] 1.204

So the pH of the solution is 1.204.

ANSWER: 1.204
```

**Comment:**  They look like they are on the right track, but like the completion terminated itself early, so it never reported an ANSWER.  In a production setting, we would check that no ANSWER was returned and rerun these. It does not seem fair to penalize GPT-4 for this...it was just looking at the pretty android in the next aisle and got temporarily distracted.

 Instead of writing a bunch of code to check restart status etc. (which would introduce complications that would obscure the main technical point of this article), we will just try these two calculations again. After all, in practice, a student using ChatGPT with a calculator tool would just hit restart after seeing that no ANSWER was returned.  So we will do it manually:

```mathematica
parseAnswer /@ ParallelTable[
   LLMSynthesize[
    "QUESTION: If 25.0 mL of 0.25 M HNO3 is combined with 15.0 mL of 0.25 M CH3NH2, what is the pH? Kb for CH3NH2 = 4.38 * 10^-4", 
    LLMEvaluator -> reflectAndCalculate], 
   {2}]

(*{1.20412, 1.20412}*)
```

These next 2 results are also perfect answers.  So once again we have a perfect (20/20=100%) response (compared to only 0% for GPT-3.5 and Analytical Chem students, and 18% of Gen Chem students at the large Midwestern University studied by Clark et al.) Again, GPT-4 is at the head of its class.

```mathematica
ToJekyll["GPT-4 does acid (base chemistry)", "science teaching gpt4 llm mathematica"]
```

# Parerga and Paralipomena

- Reina et al (2024), [PLATA: Design of an Online Platform for Chemistry Undergraduate Fully Automated Assignments](https://doi.org/10.1021/acs.jchemed.3c00962) generates open-ended chemistry questions throughout the Gen Chem II curriculum.  
     - 13 assignments, each containing 10 questions.  
     - This could be a fun way to automate training/testing LLMs on gen-chem capability...from their [webpage](https://proyectoplata.com) it seems they also have Gen Chem I and analytical chemistry materials too.
     - [Corresponding author Antonio Reina](mailto:antonio.reina.0711@quimica.unam.mx) and [Miguel Reina](mailto: mreina.2404@quimica.unam.mx)

- A more "professional" and polished version of this blog post will appear in the *Journal of Chemical Education* 
     - [Supporting Information (notebookarchive.org)](https://notebookarchive.org/2024-03-0jlwh6u)  This also contains the outputs generated from all of the variations. 