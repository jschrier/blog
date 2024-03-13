---
title: "Automated Bibliometrics with GoogleScholar and OpenAlex"
date: 2024-03-13
tags: mathematica science data
---

[GregH](https://mathematica.stackexchange.com/questions/96923/use-mathematica-to-save-all-citations-from-google-scholar-search) asks: "How can I save all citations from a [Google Scholar ](https://scholar.google.com)search? For instance, in a search for "Radon transformation", there are about 35,500 results. I want to download all citations into a string - is there a simple way to get Mathematica to do that? (And sorry, no, I haven't tried anything yet. Not sure where to start.)". **A demonstration of automating Google Scholar...and a better way using** **[OpenAlex](http://openalex.org)****...**

## Google Scholar (using scholarly)

GoogleScholar is not really intended for programmatic access, and you may also hit usage limits.  That being said, python packages like [scholarly](https://scholarly.readthedocs.io) exist to do this, and if you make only a few requests, you should be fine: 

```mathematica
ResourceFunction["PythonPackageInstall"]["scholarly"]
```

![0kzylopiyte6e](/blog/images/2024/3/13/0kzylopiyte6e.png)

```mathematica
session = StartExternalSession[
    <|"System" -> "Python", 
     "SessionProlog" -> "from scholarly import scholarly"|>] 
 
searchPubs = ExternalFunction[session, 
  "def search(terms):
    query = scholarly.search_pubs(terms)
    results = []
    for i in range(10):
      results.append(next(query))
    return results"]

```

![0xrlxu1fd4gj1](/blog/images/2024/3/13/0xrlxu1fd4gj1.png)

![0p3g3pishvzt4](/blog/images/2024/3/13/0p3g3pishvzt4.png)

```mathematica
example = searchPubs["Radon transform"];
```

```mathematica
Dataset@Query[All, "bib", {"pub_year", "author"}]@example
```

![1qywesa5op2qj](/blog/images/2024/3/13/1qywesa5op2qj.png)

## A better way: The OpenAlex API

Unlike Google Scholar, [OpenAlex](https://openalex.org) is an open project that makes it easy to get data.  The easiest way is get started is to do a text search through the web, and then click the gear button to generate the corresponding API query:

![0kuk0uokpan7u](/blog/images/2024/3/13/0kuk0uokpan7u.png)


It is then straightforward to copy and execute the corresponding API query in Mathematica (you may of course modify the result) to suit your needs:

```mathematica
example2 = URLExecute["https://api.openalex.org/works?page=1&filter=default.search:radon+transform&sort=relevance_score:desc&per_page=10"]; 
 
Dataset@Query["results", All, {"publication_date", "doi"}]@example2
```

![0cbhqoy5kga3v](/blog/images/2024/3/13/0cbhqoy5kga3v.png)

OpenAlex has many other powerful features, including (machine-learned) topic groupings, links to open access versions of documents, etc.  The [documentation is excellent.](https://docs.openalex.org) 

## Advanced Application:  Generating Coauthorship Lists

Bullshit forms are the bane of every working scientist's life.  [COA/COI co-authorship forms ](https://www.energy.gov/management/department-energy-interim-conflict-interest-policy-requirements-financial-assistance)are one such example--this becomes tricky if ([like me](https://scholar.google.com/citations?user=zJC_7roAAAAJ&hl=en)), you write papers with many different people, including large consortia.  

We need to do a bit of work to extract the author information, so we define a few functions for this:

```mathematica
(*display name is a string; reformat to a list of {Last, First M.} *)
  reformatName[name_String] := First@StringCases[first__ ~~ Shortest[Whitespace ~~ last__ ~~ EndOfString] :> {last, first}]@name 
   
  (* extract information for one coauthor *) 
   extractCoauthorItem[authorItem_] := With[
     {author = reformatName@ Query["author", "display_name"]@authorItem, 
      orcid = Query["author", "orcid"]@authorItem, 
      place = Query["institutions", 1, "display_name"]@authorItem}, 
     {author[[1]], author[[2]], orcid /. Null -> "", place /. Missing[_, _] -> "", "Coauthor"} 
    ] 
   
  (* for a given paper, extract information about all coauthors *) 
   extractCoauthorsForPaper[paperItem_] := With[
     {year = Query["publication_year"]@paperItem, 
      coauthors = Map[extractCoauthorItem]@Query["authorships"]@paperItem}, 
     Append[year] /@ coauthors] 
  
```

We can then proceed by retrieving all of the papers for the past four years, extracting the list of coauthor information, and then removing entries which have duplicate {last, first} names.  This will not be perfect, as sometimes the authors have different initials, but it gets you most of the way through the process. (Comment:  A better solution would use the authorID as a unique key and then lookup information from there, but I needed a quick-and-dirty solution to meet a deadline.) Finally, we export it as an excel spreadsheet, to do some manual cleanup before pasting it into the requisite forms.

```mathematica
papers = URLExecute["https://api.openalex.org/works?filter=authorships.author.id:a5073376584,publication_year:2020-2024&per-page=100"];
```

```mathematica
coauthors = Join @@ Map[extractCoauthorsForPaper]@Query["results"]@papers;
result = SortBy[First]@DeleteDuplicatesBy[#[[1 ;; 2]] &]@ReverseSortBy[Last]@coauthors;
Export["~/Downloads/2024.03.12_coauthors_schrier.xlsx", result]
```



```mathematica
ToJekyll["Automated Bibliometrics with GoogleScholar and OpenAlex", "mathematica science data"]
```
