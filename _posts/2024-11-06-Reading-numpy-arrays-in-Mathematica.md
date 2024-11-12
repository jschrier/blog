---
title: "Reading numpy arrays in Mathematica"
date: 2024-11-06
tags: mathematica python
---

One can read relatively simple numpy arrays that contain only numeric datatypes (NPY version 1.0) in Mathematica using a function written by [Luca Robbiano](https://github.com/lr94/NumPyArray):

```
<< "https://raw.githubusercontent.com/lr94/NumPyArray/refs/heads/master/NumPyArray.wl"
ReadNumPyArray[ file ]
```
