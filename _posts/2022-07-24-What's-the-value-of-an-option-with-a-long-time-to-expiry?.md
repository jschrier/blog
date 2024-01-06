---
Title: "What's the value of an option with a long time to expiry?"
Date: 2022-07-24
tags: finance
---

[Chris Görög](https://www.linkedin.com/in/chrisgorog/) asks: *"I knew there was a bug in the options pricing code I downloaded. I can't quite figure out exactly where they f--ed it up but they swapped the spot and strike prices. At infinite time or volatility the call option should be the same as the current stock price NOT the strike price. It just didn't make sense to get an option value greater than the current price since you should just buy the stock in that case. Feel good that I at least understand the limits of options. Also interesting that really options strategies should focus on buying options for stocks that will have an expected increase in volatility and marketing making for stocks that have high volatility. Real volatility tends to be lower than implied volatility to allow for risk to the market maker BUT the point is to identify the outliers on each side and trade as such."*  **All of this makes intuitive sense, but let's crunch the numbers together...**

```mathematica
value[time_, volatility_, strike_ : 100, spot_ : 100, dividend_ : 0] :=FinancialDerivative[
   {"European", "Call"}, {"StrikePrice" -> strike, "Expiration" -> time}, 
   {"InterestRate" -> 0.1, "Volatility" -> volatility, "CurrentPrice" -> spot, "Dividend" -> dividend}]
```

Indeed, the option value converges to the spot (current) price as time to expiration increases, in the absence of dividend.:

```mathematica
Plot[{value[t, 0.1, 10, 20], value[t, 0.1, 20, 10], value[t, 0.1, 20, 20]}, {t, 0, 50}, 
  AxesLabel -> {"time", "value"}, PlotRange -> All, 
  PlotLabel -> "Assume 10% volatility, 10% interest rate, 0% dividend", 
  PlotLegends -> {"strike 10, spot 20", "strike 20, spot 10", "strike 20, spot 20"}]
```

![0jqt9d6lgy13w](/blog/images/2022/7/24/0jqt9d6lgy13w.png)

However, once you introduce dividends, the value of options with long time to expiry goes to zero:

```mathematica
Plot[{value[t, 0.1, 10, 20, 0.0], value[t, 0.1, 10, 20, 0.05], 
   value[t, 0.1, 20, 10, 0.0], value[t, 0.1, 20, 10, 0.05]}, {t, 0, 50}, 
  AxesLabel -> {"time", "value"}, PlotRange -> All, 
  PlotLabel -> "Assume 10% volatility, 10% interest rate, strike 10, spot 20", 
  PlotLegends -> {"strike 10, spot 20, dividend 0", "strike 10, spot 20, dividend 0.05", 
    "strike 20, spot 10, dividend 0", "strike 20, spot 10, dividend 0.05"}]
```

![051fic1t9uddv](/blog/images/2022/7/24/051fic1t9uddv.png)

```mathematica
ToJekyll["What's the value of an option with a long time to expiry?", "finance"]
```
