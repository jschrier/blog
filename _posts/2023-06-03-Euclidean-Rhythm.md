---
Title: "Euclidean Rhythm"
Date: 2023-06-03
Tags: music synth mathematica supercollider
---

[Euclidean rhythms](https://en.wikipedia.org/wiki/Euclidean_rhythm) are a way to space *n* onset events across *m* positions (essentially, pulses or beats) as evenly possible. Ffor example, 4 onsets across 16 positions, will result in 4 evenly spaced onsets. However, if  the number of onsets is relatively prime with respect to the number of pulses, the resulting pattern is more interesting. This was [discovered somewhat recently by Godfried T. Toussaint](http://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf).  A [nice interactive javascript example is online with 4 samples](https://reprimande.github.io/euclideansequencer/).  Play with it and you'll hear some interesting ideas, especially if you choose relative primes. **But how do you implement it...**
 
 The best popular explanation I have found online (with some visualizations) is a [medium post by Jeff Holtzkener](https://medium.com/code-music-noise/euclidean-rhythms-391d879494df) which introduced me to its implementation in terms of the [Bresenham line algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm) for pixelating lines (plus a floor operation). This can be done simply in Mathematica as:

 ```mathematica
 euclideanRhythm[n_Integer, m_Integer] := 
    Map[Min[#, 1] &] @ Differences @ Prepend[-1] @ Floor @ Most @ Subdivide[n, m]
  ```

(you could also add an `RotateRight[#, offset]` if you wanted to start somewhere other than the beginning)

[Iannis_Zannos implemented it in supercollider](https://scsynth.org/t/bresenham-implementation-of-the-euclidean-rhythm-algorithm-in-supercollider/3127) as follows:

```
~br1 = { | n = 1, m = 4 |
	(n / m * (0..m - 1)).floor.differentiate.asInteger.min(1)[0] = if (n <= 0) { 0 } { 1 };
};
```

