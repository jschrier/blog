---
title: "Imaginary Cinema: Titanic, but with Chiguiros"
date: 2023-03-04
tags: imaginary-cinema art chiguiro
---

**Premise:** Remake [Titanic](https://en.wikipedia.org/wiki/Titanic_(1997_film)), but with all of the characters played by [chiguiros](https://en.wikipedia.org/wiki/Capybara)....


That's all. Think about it.

```mathematica
t = WebImageSearch["titanic movie scenes", 50];
c = WebImageSearch["chiguiro"];
kiss = WebImageSearch["capybara kissing"];
swim = WebImageSearch["capybaras swimming"];
two = WebImageSearch["two capybaras"];

```

```mathematica
ImageCollage[{t[[14]], two[[4]]}]
```

![150gs9r15104r](/blog/images/2023/3/4/150gs9r15104r.png)

```mathematica
With[
  {h = (0.6)*First@ImageDimensions@c[[1]] // IntegerPart}, 
  ImageCollage[{t[[-2]], ImageTake[c[[1]], h]}]]
```

![1ddhb20vto078](/blog/images/2023/3/4/1ddhb20vto078.png)

```mathematica
ImageCollage@{t[[43]], ImageReflect[c[[6]], Left -> Right]}
```

![1rfbs7ia2clhw](/blog/images/2023/3/4/1rfbs7ia2clhw.png)

```mathematica
ImageCollage@{t[[2]], two[[-1]]}
```

![1d5qzo2zvb772](/blog/images/2023/3/4/1d5qzo2zvb772.png)

```mathematica
ImageCollage@{t[[18]], kiss[[6]]}
```

![1iyxzdjaxtv2n](/blog/images/2023/3/4/1iyxzdjaxtv2n.png)

```mathematica
ImageCollage@{t[[24]], kiss[[2]]}
```

![01n987cz6xe86](/blog/images/2023/3/4/01n987cz6xe86.png)

```mathematica
ImageCollage@{t[[5]], two[[7]]}
```

![0kk65vwddiebt](/blog/images/2023/3/4/0kk65vwddiebt.png)

```mathematica
ImageCollage@{t[[11]], kiss[[4]]}
```

![0kimt0d5xu6h3](/blog/images/2023/3/4/0kimt0d5xu6h3.png)

```mathematica
ImageCollage@{t[[5]], two[[5]]}
```

![0leimaabs5uah](/blog/images/2023/3/4/0leimaabs5uah.png)

```mathematica
ImageCollage@{t[[20]], ImageReflect[c[[2]], Left -> Right]}
```

![0c6l88tsn1epm](/blog/images/2023/3/4/0c6l88tsn1epm.png)

```mathematica
ImageCollage[{t[[39]], two[[3]]}]
```

![10gr5ev07bviv](/blog/images/2023/3/4/10gr5ev07bviv.png)

```mathematica
ImageCollage@{t[[19]], swim[[1]]}
```

![129tf683yl681](/blog/images/2023/3/4/129tf683yl681.png)

```mathematica
ImageCollage[{t[[9]], swim[[3]]}]
```

![0jb27xkjd2ras](/blog/images/2023/3/4/0jb27xkjd2ras.png)

```mathematica
ToJekyll["Imaginary Cinema: Titanic but with Chiguiros", "imaginary-cinema, art, chiguiro"]
```
