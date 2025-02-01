---
title: "How far away is another Catholic Church in NYC?"
date: 2025-01-31
tags: nyc mathematica llm
---

Alexei Gannon '25 asks: *... a slightly different question... and instead I ask* **what is the distribution of nearest-neighbor parish distances in the** [Archdiocese of New York](https://archny.org)**?...** 

Conveniently, [Cardinal Dolan](https://archny.org/about/cardinal-dolan/) made a list for us:

```mathematica
newYork = Import["https://archny.org/our-parishes/", "Plaintext"];
```

Begin by processing the text. It is rather long, and we want to focus on the city of New York, so we will retain only lines that contain *Bronx*, *New York* (i.e., Manhattan), or *Staten Island*.  (Recall that [Queens and Brooklyn are in their own diocese](https://en.wikipedia.org/wiki/List_of_churches_in_the_Roman_Catholic_Diocese_of_Brooklyn).)  We include some spaces after Bronx to kick out Bronxville (which is in Yonkers):

```mathematica
lines = StringRiffle[#, "\n"] &@
    Select[
     StringSplit[newYork, "\n"], 
     StringContainsQ[{"Bronx ", "Bronx,", "New York", "Staten Island"}]];
```

Then feed the result into the LLM to clean it up:

```mathematica
result = StringSplit[#, "\n"] &@
    LLMSynthesize["Extract only the addresses from the following text. Put each address on its own line. Write the address in the form: 123 Main Street, Anytown,  NY 12345. Do not include any other information, such as markdown.  Here is the text:\n" <> lines];
```

Run it through an [interpreter](http://reference.wolfram.com/language/ref/interpreter/StreetAddress.html) to extract the points as [GeoPosition](http://reference.wolfram.com/language/ref/GeoPosition.html) items: 

```mathematica
locations = Interpreter["StreetAddress"] /@ result;
```

The following results could not be parsed as addresses, although *prima facie* they seem to be reasonable addresses (spot checking a few of them on Google Maps shows a location). This is probably a failure of the [OpenStreetMap database](http://reference.wolfram.com/language/ref/interpreter/StreetAddress.html) that is used behind the scenes:

```mathematica
TableForm@ Pick[result, FailureQ /@ locations]
```

![174i8aambadst](/blog/images/2025/1/31/174i8aambadst.png)

We will just proceed without them.  Where are these churches?

```mathematica
churches = DeleteCases[locations, Failure[__]];
GeoListPlot[churches]
```

![15bwk0rmdf7oq](/blog/images/2025/1/31/15bwk0rmdf7oq.png)

Uh oh! Remove the outliers and replot: 

```mathematica
churches = DeleteAnomalies[churches];
GeoListPlot[churches]
```

![00ol0unpjdwls](/blog/images/2025/1/31/00ol0unpjdwls.png)

That looks better. Now compute the distance to the nearest (non-self) church. (By default, 2 gives us self and other, so we retain only the last part):

```mathematica
distances = Last /@ Nearest[churches -> "Distance", churches, 2]; 
 
Histogram[distances, 
   Frame -> True, 
   FrameLabel -> {"Nearest Neighbor Parish (Miles)", "Count"}] 
 
Median[distance]
```

![1a9fmtghpf9m8](/blog/images/2025/1/31/1a9fmtghpf9m8.png)

![0o469bt4s8c9w](/blog/images/2025/1/31/0o469bt4s8c9w.png)

OK, maybe you prefer this in some other units:

```mathematica
UnitConvert[%, "Miles"]
```

![04voiavfhxder](/blog/images/2025/1/31/04voiavfhxder.png)

```mathematica
UnitConvert[%, "Kilometers"]
```

![1k46h00c2b084](/blog/images/2025/1/31/1k46h00c2b084.png)

```mathematica
Mean[distance]
```

![00ntfovi8q6wk](/blog/images/2025/1/31/00ntfovi8q6wk.png)

This is surprisingly closer than I would have expected.

## Also in our discussion:

- [Dimes Square Catholicism](https://www.nytimes.com/2022/08/09/opinion/nyc-catholicism-dimes-square-religion.html) as a continuation of 20th century aesthetic counter culture Catholicism: 

    - [Yelp reviews for Catholic masses](https://www.yelp.com/search?find_desc=Catholic+Mass&find_loc=New+York%2C+NY) as a symptom of consumerist culture

        - [Canon Law and mass-shopping]( https://canonlawmadeeasy.com/2008/04/11/parish-registration/ )

    - [Punk rock Franciscans in NYC](https://www.nytimes.com/2007/04/22/nyregion/thecity/22monk.html)  = [Catholic Underground](https://www.catholicunderground.net)

    - Dorothy Day, [The Long Loneliness](https://amzn.to/4hEcetc)

    - Thomas Merton, [The Seven Storey Mountain](https://amzn.to/3Ej3QkJ)

    - Orthodox flavor: [Death to the World](https://deathtotheworld.com/)  

    - [Charles de Foucauld](https://en.wikipedia.org/wiki/Charles_de_Foucauld) and the [little brothers formerly in NYC](https://www.nytimes.com/2008/07/03/nyregion/03order.html)

- [Latest Vatican take on AI](https://www.vatican.va/roman_curia/congregations/cfaith/documents/rc_ddf_doc_20250128_antiqua-et-nova_en.html)

    - [Pope Paul VI knew what was up about social media](https://www.vatican.va/archive/hist_councils/ii_vatican_council/documents/vat-ii_decree_19631204_inter-mirifica_en.html) 

    - The Vatican had a website contemporaneous with Internet Explorer 1.0 (1995)

```mathematica
ToJekyll["How far away is another Catholic Church in NYC?", "nyc mathematica llm"]
```
