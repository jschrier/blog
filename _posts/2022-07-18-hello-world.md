---
title: "Hello World, Or How I Started The Blog"
date: 2022-07-18
tags: metablogging
---

Some useful tools and tricks learned while trying to make this blog:
* Creating this blog with [Github pages](https://github.com/skills/github-pages)
* Using [M2MD](https://github.com/kubaPod/M2MD/wiki) to facilitate conversion of Mathematica notebooks into Markdown
* (Although tempting to use [Wolfdown](https://github.com/paul-jean/wolfdown), there are a bunch of hardcoded options which were harder to parse)
* How to add tags?  Ordinarily Jekyll requires some add ons, but [this post describes how to do it with default github pages](http://longqian.me/2017/02/09/github-jekyll-tag/).  I didn't have much luck, but one day I'll figure it out.
*  Funny things with double squiggly-braces.  You may get an `Error:  Liquid syntax error (line 35): Variable \{\{-1, 0.9\} was not properly terminated` type error when exporting mathematica lists.  This is because [Jekyll uses double squigglies for commands...even when these are inside verbatim code cells](https://github.com/jekyll/jekyll/issues/5458).  Just add a space and you'll be fine. Alternatively you can wrap these inside {% raw %}…{% endraw %} to avoid this.  It might be a good idea to do this for code cells in general.  I'll consider modifying the `ToJekyll` function to do this
* How to [link between different posts in Jekyll](https://jekyllrb.com/docs/liquid/tags/#linking-to-posts)
