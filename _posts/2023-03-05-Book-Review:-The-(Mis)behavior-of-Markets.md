---
title: "Book Review: The (Mis)behavior of Markets"
date: 2023-03-05
tags: books finance math
---

Some notes on Benoit Mandelbrot & Richard Hudson, [The (Mis)behavior of Markets: A Fractal View of Financial Turbulence](https://amzn.to/3JeTSRr) (2004).  **Premise:** The (geometric) Brownian motion model of asset prices, and the house built upon its Gaussian foundation (i.e., [Bachelier](https://en.wikipedia.org/wiki/Louis_Bachelier), [Markowitz efficient portfolios](https://en.wikipedia.org/wiki/Harry_Markowitz), Sharpe's [Capital Asset Pricing Model](https://en.wikipedia.org/wiki/Capital_asset_pricing_model), [Black-Scholes](https://en.wikipedia.org/wiki/Black–Scholes_model)) fails to capture the extreme variations present in real-data.  [Power law distributions](https://en.wikipedia.org/wiki/Power_law), [fractional Brownian motion](https://en.wikipedia.org/wiki/Fractional_Brownian_motion) (which has postive or negative time-correlations) and [multi-fractal](https://en.wikipedia.org/wiki/Multifractal_system) regime changes better capture observed variations...

## Notes

- pp. 20+ Five rules
    1. Markets are risky
    2. Trouble runs in streaks
    3. Markets have a personality
    4. Markest mislead
    5. Market time is relative
- p. 184: corrolograms of tree-ring data
- p. 191: estimate H for different asset types (Taqqui)
- p. 208: Two types of variability:  **Noah** (big changes can happen, governed by power law, with parameter \alpha) & **Joseph** (persistent motion/time correlations: described by fractional brownian motion with parameter H)
- p. 208: multifractal model
- pp. 227+ Ten Heresies of Finance
    1. Markets are turbulent
    2. Markets are very, very risky---more risky than the standard theories imagine 
    3. Market timing matters greatly. Big gains and losses concentrate into small packages of time.
    4. Prices often leap, not glide. That adds to risk
    5. In markets, time is flexible
    6. Markets in all places and ages work alike
    7. Markets are inherently uncertain, and bubbles are inevitable
    8. Markets are deceptive
    9. Forecasting prices may be perilous, but you can estimate the odds of future volatility
    10. In financial markets, the idea of 'Value' has limited value
- p. 253: [Richard Olsen](https://scholar.google.com/citations?user=yrbITW8AAAAJ&hl=en&oi=ao)  and [Oanda.com](http://oanda.com)
- p. 259 [Jean-Phillipe Bouchaud](https://scholar.google.com/citations?user=58amEmwAAAAJ&hl=en&oi=ao): multifractal/mean reversion + tail chiseeling by incorporating long tail hypothesis to avoid catastrophic risk
- p. 263 fractal fingerprint


## Some Mathematica fiddlings 

**Pull stock prices and plot daily differences and see how it differs from the Browninan walk model but looks like a long tail distribution:** 

```mathematica
daily = FinancialData["NASDAQ:GOOG", {2022, 01, 01}]
With[
   {diff = Differences@daily["Values"]}, 
   {ListPlot[diff, Filling -> Axis], Histogram[diff]}] // GraphicsRow
```

![13p2iv1p9mbra](/blog/images/2023/3/5/13p2iv1p9mbra.png)

![19e9vbvr155i1](/blog/images/2023/3/5/19e9vbvr155i1.png)

```mathematica
proc = EstimatedProcess[daily["Values"], GeometricBrownianMotionProcess[\[Mu], \[Sigma], S]]
path = RandomFunction[proc, {1, 293, 1}]
With[
   {diff = Differences@path["Values"]}, 
   {ListPlot[diff, Filling -> Axis], Histogram[diff]}] // GraphicsRow

(*GeometricBrownianMotionProcess[-0.00117877, 0.0247642, 145.074]*)
```

![0wjgbilenpdqy](/blog/images/2023/3/5/0wjgbilenpdqy.png)

![1ugxlmw43tzpd](/blog/images/2023/3/5/1ugxlmw43tzpd.png)

I don't know...looks like the Geometric Brownian motion is a pretty good description over this time period...

**Reproduce figure with fraction brownian walk. H = 0.1, H=0.5, H=0.9**

```mathematica
{low, med, high} = FractionalBrownianMotionProcess[0, 1, #] & /@ {0.1, 0.5, 0.9};
GraphicsRow@Map[ListLinePlot@RandomFunction[#, {1, 252, 1}, 3] &]@{low, med, high}
```

![1czzvgagdh697](/blog/images/2023/3/5/1czzvgagdh697.png)



## Further reading and resources / bibliographic extracts

- [Mandelbrot's website](https://users.math.yale.edu/mandelbrot/)
    - Fractals and Scaling in Finance (1997)
    - Gaussian Self-Affinity and Fractals (2002)
- Bouchaud, [A First Course in Random Matrix Theory](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=58amEmwAAAAJ&cstart=20&pagesize=80&sortby=pubdate&citation_for_view=58amEmwAAAAJ:EMrlLOzmm-AC) (2020)
- Bouchaud [Theory of Financial Risk](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=58amEmwAAAAJ&citation_for_view=58amEmwAAAAJ:WC4w5-ZrDNIC) (2003)
- Bouchaud [An Introduction to Statistical Finance](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=58amEmwAAAAJ&cstart=20&pagesize=80&citation_for_view=58amEmwAAAAJ:e5wmG9Sq2KIC) *Physica A* (2002)
- Would love to get some notes from Fischer Black's ["50 questions in finance"](https://pages.stern.nyu.edu/~sfiglews/documents/FISCHER4.pdf) course.  
- [https://www.oanda.com](https://www.oanda.com) forex exchange
- Knauf [Making Money from FX Volatility](https://iopscience.iop.org/article/10.1088/1469-7688/3/3/606/meta) *Quant Finance* (2003)
- Mandelbrot's student, Calvet, has published a book on [Multifractal Volatility: Theory, Forecasting and Pricing](https://amzn.to/3EY5QMP) (2008) which seems pretty interesting






