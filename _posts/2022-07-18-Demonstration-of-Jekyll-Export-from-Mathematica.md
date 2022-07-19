---
Title: "Demonstration of Jekyll Export from Mathematica"
Date: 2022-07-18
Tags: metablogging
---

Our goal here is to demonstrate how to Export Mathematica notebooks to Jekyll markdown using MDExport.

This requires a bit of custom code, demonstrated below.

But first, a simple illustration of plotting [Maxwell-Boltzmann](https://en.wikipedia.org/wiki/Maxwell-Boltzmann_distribution) distribution

```mathematica
mb[kT_, m_, u_] := 4 Pi ( m/(2 kT Pi ))^{3/2} u^2 Exp[-m u^2/(2 kT)] 
 
Plot[
  {mb[1, 1, u], mb[2, 1, u], mb[1, 2, u]}, {u, 0, 8}, 
  PlotStyle -> {Black, Red, Red}, 
  Frame -> True, FrameTicks -> None, 
  PlotLegends -> Placed[{"\[UpArrow]m", "\[UpArrow]T"}, {Right, Top}],FrameLabel -> {"Velocity", "Probability Density"}, 
  ImageSize -> Small]

```

![0w426cskyjnx8](/blog/images/2022/7/18/0w426cskyjnx8.png)

```mathematica
Clear[ToJekyll]
ToJekyll[title_, tags_ : "", blogLocation_ : "~/Documents/GitHub/blog"] := With[
    {blogFile = StringJoin[
       DateString["ISODate"], "-", StringReplace[title, " " -> "-"], ".md"], 
     imageLocation = FileNameJoin[{"/images"}~Join~Map[ToString, DateList[][[;; 3]]]] 
    }, 
    CreateDirectory[imageLocation] // Quiet; 
    With[
     {mdFile = 
       M2MD[
        EvaluationNotebook[], 
        "ImagesExportURL" -> FileNameJoin[{blogLocation, imageLocation}], 
        "ImagesFetchURL" -> URL[FileNameJoin[{"/blog", imageLocation}]]], 
      titleStr = StringJoin["---\nTitle: \"", title, "\""], 
      dateStr = StringJoin["Date: ", DateString["ISODate"]], 
      tagStr = StringJoin["Tags: ", tags, "\n---\n"], 
      outputFile = OpenWrite[FileNameJoin[{blogLocation, "_posts", blogFile}]]}, 
     
     WriteLine[outputFile, titleStr]; 
     WriteLine[outputFile, dateStr]; 
     WriteLine[outputFile, tagStr]; 
     WriteLine[outputFile, mdFile]; 
     Close[outputFile]; 
     
    ]] 
 
DefineResourceFunction[ToJekyll] (*define for later use*) 
 
ToJekyll["Demonstration of Jekyll Export from Mathematica", "metablogging"]
```

![05mgzt56wpbb3](/blog/images/2022/7/18/05mgzt56wpbb3.png)
