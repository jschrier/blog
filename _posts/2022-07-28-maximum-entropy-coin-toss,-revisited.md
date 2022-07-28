---
Title: "maximum entropy coin toss, revisited"
Date: 2022-07-28
Tags: probability optimization thermodynamics
---

Suppose that you roll a die many times and learn that the average value is 5--what is the most likely (maximum entropy) distribution of the probabilities?  [Last week we solved this by brute force]({% post_url 2022-07-23-Maximum-entropy-coin-toss-problem %})...today we'll solve it by considering the [Gibbs Distribution](https://twitter.com/johncarlosbaez/status/1551949111032569857) (aka Boltzmann's Law):
![twitter](https://pbs.twimg.com/media/FYmfYAjVsAAlnU_?format=jpg&name=medium)

```mathematica
probabilities = Table[ Exp[-beta *i ], {i, 6}]/Sum[Exp[-beta*j], {j, 6}];
expectationValue = Range[6] . probabilities;
Plot[expectationValue, {beta, -2, 2}, AxesLabel -> {"beta", "<A>"}]
```

![1a2manbl1msg0](/blog/images/2022/7/28/1a2manbl1msg0.png)

Now solve the expression for beta, and use the result to determine the probabilities:

```mathematica
soln = Solve[expectationValue == 5, beta, Reals]
probabilities /. soln // N
```

![0a3kz6rfxhu4m](/blog/images/2022/7/28/0a3kz6rfxhu4m.png)

```
(*{{0.0205324, 0.0385354, 0.0723234, 0.135737, 0.254752, 0.47812}}*)
```

Which agrees with [our previous brute force optimization]({% post_url 2022-07-23-Maximum-entropy-coin-toss-problem %}).  The advantage is that we are only optimizing over a single variable, rather than 6 dimensions as before.

If you're old-school, you can do this by hand by replacing  *lambda* = Exp[-beta], and express each of the probabilities as lambda^i.  Substitute these probabilities into the expectation value and then solve this polynomial equation for lambda. 

**Pro-tip:**  You can get a higher paying job if you say *[softmax](https://en.wikipedia.org/wiki/Softmax_function)* instead of Gibbs Distribution :-) 

```mathematica
ResourceFunction["ToJekyll"]["maximum entropy coin toss, revisited", "probability optimization thermodynamics"]
```
