---
Title: "Imaginary Cinema: Doctor Zhivago, but with Chiguiros"
Date: 2023-02-24
Tags: imaginary-cinema art chiguiro
---

**Premise:** Remake [Doctor Zhivago](https://en.wikipedia.org/wiki/Doctor_Zhivago_(film)), but with all of the characters played by [chiguiros](https://en.wikipedia.org/wiki/Capybara)....


That's all. Think about it.

```mathematica
z = WebImageSearch["Dr. Zhivago"];
c = WebImageSearch["chiguiro"];
c2 = WebImageSearch["capybara kissing"];
c3 = WebImageSearch["three capybaras"];
c4 = WebImageSearch["capybaras in the snow"];
```

```mathematica
ImageCollage[{z[[1]], c3[[2]]}]
```

![0yhbgpi0gm5yw](/blog/images/2023/2/24/0yhbgpi0gm5yw.png)

```mathematica
ImageCollage[{z[[2]], ImageReflect[c4[[2]], Left -> Right]}]
```

![04850x7vo6ub8](/blog/images/2023/2/24/04850x7vo6ub8.png)

```mathematica
ImageCollage[{z[[4]], ImageReflect[c[[4]], Left -> Right]}]
```

![10ywew3mgy7fj](/blog/images/2023/2/24/10ywew3mgy7fj.png)

```mathematica
ImageCollage@{z[[-1]], c3[[7]]}
```

![1d172zzonde9s](/blog/images/2023/2/24/1d172zzonde9s.png)

```mathematica
ImageCollage@{z[[-2]], c3[[4]]}
```

![0fb45mbeewgnq](/blog/images/2023/2/24/0fb45mbeewgnq.png)

```mathematica
ImageCollage[{z[[3]], ImageReflect[c2[[2]], Left -> Right]}]
```

![0vywpq5045h5b](/blog/images/2023/2/24/0vywpq5045h5b.png)

```mathematica
ToJekyll["Imaginary Cinema: Doctor Zhivago but with Chiguiros", "imaginary-cinema, art"]
```
