rm ../tag/*.md

grep -h "^tags: " *.md | sed -e 's/tags: //;' | tr ' ' '\n'  | sort | uniq | while read name; do echo "---\nlayout: tagpage\ntitle: \"Tag: $name\"\ntag: $name\nrobots: noindex\n---\n" > "../tag/${name}.md"; done
