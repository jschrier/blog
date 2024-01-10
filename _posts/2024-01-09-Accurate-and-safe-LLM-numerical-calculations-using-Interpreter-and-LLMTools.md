---
title: "Accurate and safe LLM numerical calculations using Interpreter and LLMTool"
date: 2024-01-09
tags: llm gpt4 mathematica
---

In a [previous post, we discussed]({{ site.baseurl }}{% post_url 2023-11-27-LLMTools-demonstration %}) the use of [LLMTool](http://reference.wolfram.com/language/ref/LLMTool.html), to provide a way for remote LLMs to execute code on your local Wolfram kernel.  A natural place to use this is in performing numerical calculations--[mathematical calculations are a well-known weakness of LLMs](https://community.openai.com/t/chatgpt-simple-math-calculation-mistake/62780/2). We can solve this by having the LLM write   the proposed calculation as a string, and then call a tool that [Evaluate](http://reference.wolfram.com/language/ref/Evaluate.html)-s it on the local kernel.  But [Evaluate](http://reference.wolfram.com/language/ref/Evaluate.html)-ing any *arbitrary* string provided is a recipe for trouble--a malicious actor would be able to use this to perform arbitrary calculations, such as deleting files, etc.  (This is not unique to Mathematica: we all know python [eval is dangerous](https://nedbatchelder.com/blog/201206/eval_really_is_dangerous.html), and the modern best practice is to sandbox an entire python install.)  **[Interpreter](http://reference.wolfram.com/language/ref/Interpreter.html)** **provides a safe and easy way to provide LLMs with the ability to perform only numerical calculations with Mathematica...**

Use Interpreter to perform safe calculations

(a riff off a [recent stackexchange post](https://mathematica.stackexchange.com/a/296153/63709)) [Interpreter](http://reference.wolfram.com/language/ref/Interpreter.html) lets you parse input strings into wide range of object types. For our goal of allowing arbitrary numerical calculations, [ComputedNumber](http://reference.wolfram.com/language/ref/interpreter/ComputedNumber.html) **seems like the right choice, but other possibilities include [MathExpression](http://reference.wolfram.com/language/ref/interpreter/MathExpression.html) (to perform equation solving) or [ComputedQuantity](http://reference.wolfram.com/language/ref/interpreter/ComputedQuantity.html) (to perform unit calculations).  

Simple arithmetic expressions work fine: 

```mathematica
Interpreter["ComputedNumber"]["1+1"]

(*2*)
```

But we return a Failure if the input is non-numerical:

```mathematica
Interpreter["ComputedNumber"]["1+Quit[]"]
```

![199f6u5lju4dy](/blog/images/2024/1/9/199f6u5lju4dy.png)

However, we are still allowed to use any built-in function that performs a numerical computation:

```mathematica
Interpreter["ComputedNumber"]["1+Sin[3.2 Pi]"]

(*0.412215*)
```

ComputedNumber has access to expressions outside of the input scope, so long as they compute a number:

```mathematica
a = {1, 2, 3};
Interpreter["ComputedNumber"]["1+a[[2]]+a[[3]]"]

(*6*)
```

The interpreter is smart enough to distinguish between indefinite integrals which return a symbolic result:

```mathematica
Interpreter["ComputedNumber"]["Integrate[x, {x}]"]
```

![0dxszrbqe9zaz](/blog/images/2024/1/9/0dxszrbqe9zaz.png)

As opposed to definite integrals which return a numerical result:

```mathematica
Interpreter["ComputedNumber"]["Integrate[x, {x,0,1}]"]
```

![1mt5g4rpp664w](/blog/images/2024/1/9/1mt5g4rpp664w.png)

**In conclusion:** This is exactly what we want.

**However:** A possible limitation is that a malicious code could still, in principle, crash our kernel by requesting some difficult calculation (e.g., trying to do root solving on a high order polynomial.)  Howeer, this can be limited by wrapping the evaluation in a [TimeConstrained](http://reference.wolfram.com/language/ref/TimeConstrained.html) and/or [MemoryConstrained](http://reference.wolfram.com/language/ref/MemoryConstrained.html) functions to impose a hard limit on the computational resources for the task.

## Implement the LLMTool

In [a previous post, we showed]({{ site.baseurl }}{% post_url 2023-11-27-LLMTools-demonstration %}) how to define an [LLMTool](http://reference.wolfram.com/language/ref/LLMTool.html).  Let's do it again, but this time evaluate arbitrary numerical expressions with our safe interpretation.  Conveniently, we can impose the Interpreter type on the input variables by providing a rule in the second argument:

```mathematica
calculate = LLMTool[
    {"calculate", (*name*)
     "e.g. calculate: 1+1\ne.g. calculate: 1+Sin[3.2 Pi]\nRuns a calculation and returns a number - uses Wolfram language as determined by  Interpreter[\"ComputedNumber\"]."}, (*description*)
    "expression" -> "ComputedNumber", (*interpretation is performed directly on input*)
    ToString[#expression] &]; (*convert back to string to return to LLM*)

```

Without the tool, the results are poor (using gpt-4-1106-preview by default):

```mathematica
LLMSynthesize["What is 1+ Sin[7.8/Pi]?"]

(*"1 + sin[7.8/Pi] is approximately equal to 1.01228."*)
```

With the tool, the result is correct (of course, because it uses the tool)

```mathematica
LLMSynthesize["What is 1+ Sin[7.8/Pi]?", 
  LLMEvaluator -> <|"Tools" -> calculate|>]

(*"The result of the expression 1+Sin[7.8/Pi] is approximately 1.61215."*)
```

```mathematica
ToJekyll["Accurate and safe LLM numerical calculations using Interpreter and LLMTool", 
  "llm gpt4 mathematica"]
```

# Parerga and paralipomena

- (10 Jan 2024) The new [Mathematica 14.0](https://writings.stephenwolfram.com/2024/01/the-story-continues-announcing-version-14-of-wolfram-language-and-mathematica/) includes an experimental [LLMTool repository](https://resources.wolframcloud.com/LLMToolRepository). It includes a [Wolfram Language Evaluator](https://resources.wolframcloud.com/LLMToolRepository/resources/WolframLanguageEvaluator/) tool, but unclear if this is sandboxed at all for safety.
