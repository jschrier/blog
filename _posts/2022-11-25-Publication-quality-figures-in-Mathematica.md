---
Title: "Publication quality figures in Mathematica"
Date: 2022-11-25
tags: mathematica figures
---

Some things that I have found useful in generating figures for scientific publications (single column width, inset labelling, etc.)...

```mathematica
(* initialization *)
$PlotTheme = "Scientific"; (*sets defaults for Frame->True, etc.)
singleColumn = 1.38*3.35*72; (*APL single column width, in inches*)

(* usage with manual placement of inset labels *)
Plot[
  (*insert code here*)
   FrameLabel -> {"foo", "bar"},
   ImageSize -> singleColumn, 
   LabelStyle -> {12, Black},
   Epilog -> Inset[Text[Style["(a)", FontSize -> 12]], ImageScaled[{0.9, 0.9}]]

(* automating label placement *)
ResourceFunction["PlotGrid"][
 { { (* figure 1 *)},
  { (* figure 2 *)}},
 Spacings -> 70,
 PlotLabels -> Automatic -> "a)",
 LabelStyle -> {14, Black}
 ]

 ```  