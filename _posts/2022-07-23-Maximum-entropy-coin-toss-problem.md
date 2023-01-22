---
Title: "Maximum entropy coin toss problem"
Date: 2022-07-23
Tags: probability optimization
---

Inspired by a [tweet from John Carlos Baez](https://twitter.com/johncarlosbaez/status/1550527728272543744):  Suppose that you roll a die many times and learn that the average value is 5. What is the most likely (i.e., maximum entropy) distribution of the probabilities? **This can be expressed as a simple constrained optimization...**

```mathematica
NMaximize[{-p . Log[2, p], (*maximize the entropy = -\sum_i p_i log(p_i) *)
   Total[p] == 1 && p . Range[6] == 5}, (*subject to contraints*)
  p \[Element] Cuboid[{0, 0, 0, 0, 0, 0}, {1, 1, 1, 1, 1, 1}]] (*in this domain*)

```

![15v77tzcs1uhj](/blog/images/2022/7/23/15v77tzcs1uhj.png)

```
(*{1.8294, {p -> {0.0131595, 0.00045625, 0.0556762, 0.275116, 0.215116, 0.440475}}}*)
```

(as usual, looks much cooler when `\[Element]` gets rendered into a nice symbol when pasted into a notebook.)

The warning [is a consequence of the way numerical maximization is performed; it can be addressed by restricting the function to optimize over to real values](https://mathematica.stackexchange.com/questions/59706/maximize-violating-constraints). It is informative in that it is warning us that a better solution might be found.   Incorporating the idea that we only want the function that we are maximizing to consider real values improves the result.  

```mathematica
NMaximize[{Re[-p . Log[2, p]],(*maximize the entropy*)
   Total[p] == 1 && p . Range[6] == 5},(*subject to contraints*)
  p \[Element] Cuboid[{0, 0, 0, 0, 0, 0}, {1, 1, 1, 1, 1, 1}]](*in this domain*)


(*{1.97283, {p -> {0.0205324, 0.0385354, 0.0723234, 0.135737, 0.254752, 0.47812}}}*)
```

There are other ways to define the feasible space.  One strategy is to define it in terms of a simplex of unit vectors.  This is better by default than searching in a hypercube, but still does not given the optimal result...

```mathematica
NMaximize[{-p . Log[2, p], 
   Total[p] == 1, p . Range[6] == 5}, 
  p \[Element] Simplex[IdentityMatrix[6]]](*express domain as simplex*)

```

![1ba9tapp81cbw](/blog/images/2022/7/23/1ba9tapp81cbw.png)

```
(*{1.93311, {p -> {0.012451, 0.017983, 0.0840047, 0.137274, 0.339251, 0.409036}}}*)
```

...unless you add the real constraint:

```mathematica
NMaximize[{-Re[p . Log[2, p]],(*restrict to reals*)
   Total[p] == 1, p . Range[6] == 5}, 
  p \[Element] Simplex[IdentityMatrix[6]]]


(*{1.97283, {p -> {0.0205324, 0.0385354, 0.0723234, 0.135737, 0.254752, 0.47812}}}*)
```

But searching in the simplex is unnecessary.  You can just specify that p is a 6-dimensional positive vecotr and use the `Total` constraint to find the optimal solution.

```mathematica
NMaximize[{Re[-p . Log[2, p]], 
   Total[p] == 1, p . Range[6] == 5}, 
  p \[Element] Vectors[6, PositiveReals]] (*express domain in this form*)


(*{1.97283, {p -> {0.0205324, 0.0385354, 0.0723234, 0.135737, 0.254752, 0.47812}}}*)
```

```mathematica
NotebookFileName@EvaluationNotebook[]
ResourceFunction["ToJekyll"]["Maximum entropy coin toss problem", "probability optimization"];

(*"/Users/jschrier/Documents/GitHub/mcq/mathematica/2022.07.23_maximum_entropy.nb"*)
```
