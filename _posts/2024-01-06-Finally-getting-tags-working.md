---
title: "Finally getting tags working"
date: 2024-01-06
tags: metablogging
---

I finally got post tagging working in Jekyll...made more difficult by some non-standard path choices.  **Possible [footguns](https://en.wiktionary.org/wiki/footgun) to consider...**

- Ultimately [Jason Miller's description](http://www.jasonemiller.org/2020/12/23/tagging-posts-in-jekyll-minima.html) of [Long Qian's](http://longqian.me/2017/02/09/github-jekyll-tag/) process was the one I used.  It didn't work at first, so I went through and [upgraded the files](https://github.com/jschrier/blog/pull/171) iteratively to match [Jason Miller's files](https://github.com/jasonemiller/jasonemiller.github.io/tree/main)
- But still errors!  What I learned is that the Jekyll header information (`title`, `date`, `tag`) **must be lowercase** or else they are ignored!  Doh!  It is easy to  fix this using `sed`
    - This also fixes another minor bug that I had been experiencing, where the titles of blog posts displayed using only first letter capitalizations. Now I know that this is because jekyll was getting the name from the file name, and inferring capitalization.  But once we switch this, it fixes the display, which is nice.  No links should be broken by this change.
    - I've updated the Jekyll script accordingly
- I had my site configured so that posts go to `/blog/`.  But Jason's doesn't do this, which causes a bunch of file path issues on links. These can be fixed by modifying the `_layouts` and `_includes` paths acccordingly. If I were going to do this over, I would just clone Jason or Qian's repo, delete all their posts, and just run with it.  But I didn't want to break links I shared with others, so I modified it. So I guess I could do it over again by using a time machine to retrieve my own repo now :-)
- Both guys use a [python script](http://www.jasonemiller.org/2020/12/23/tagging-posts-in-jekyll-minima.html) to create all the little tag files that are needed.  But you can just do this on the command line:

```
cd _posts
grep -h "^tags: " *.md | sed -e 's/tags: //;' | tr ' ' '\n'  | sort | uniq | while read name; do echo "---\nlayout: tagpage\ntitle: \"Tag: $name\"\ntag: $name\nrobots: noindex\n---\n" > "../tag/${name}.txt"; done
```

(the `robots` line keeps them off the lawn of the index pages only)
- You'll need to run this periodically to update new tags that are present.