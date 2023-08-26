---
Title: "Imaginary Cinema: In the Mood for Love, but with Chiguiros"
Date: 2023-08-25
Tags: imaginary-cinema chiguiro art
---

**Premise:**  Remake [In the Mood for Love](https://en.wikipedia.org/wiki/In_the_Mood_for_Love), but with all the characters played by [chiguiros](https://en.wikipedia.org/wiki/Capybara)...

That's all. Think about it.

```mathematica
mfl = WebImageSearch["In the Mood for love movie scene", 50];
two = WebImageSearch["two capybaras", 20];
c = WebImageSearch["capybara", 20];
```

```mathematica
ImageCollage[{mfl[[35]], c[[3]]}]
```

![02cbu4pf8sup5](/blog/images/2023/8/25/02cbu4pf8sup5.png)

```mathematica
With[
  {sub = ImageCrop[c[[1]], {250, Full}, Left]}, 
  ImageCollage[{mfl[[-6]], sub}]]
```

![1l6tv7lped7n8](/blog/images/2023/8/25/1l6tv7lped7n8.png)

```mathematica
ImageCollage[{mfl[[7]], two[[4]]}]
```

![18a54k2zqg776](/blog/images/2023/8/25/18a54k2zqg776.png)

```mathematica
ImageCollage[{mfl[[8]], two[[2]]}]
```

![0ecx6kbauean5](/blog/images/2023/8/25/0ecx6kbauean5.png)

```mathematica
ImageCollage[{mfl[[3]], two[[10]]}]
```

![14kx3vtfovifw](/blog/images/2023/8/25/14kx3vtfovifw.png)

```mathematica
ImageCollage[{mfl[[23]], two[[14]]}]
```

![06qh6gs4cr0qi](/blog/images/2023/8/25/06qh6gs4cr0qi.png)

```mathematica
ImageCollage[{mfl[[32]], two[[1]]}]
```

![1cs8xaun05z5o](/blog/images/2023/8/25/1cs8xaun05z5o.png)

```mathematica
ImageCollage[{mfl[[19]], two[[-1]]}]
```

![1qpno5fsigq7z](/blog/images/2023/8/25/1qpno5fsigq7z.png)

```mathematica
With[
  {chop = ImageCrop[two[[5]], {250, Full}]}, 
  ImageCollage[{mfl[[27]], chop}]]
```

![19q5dz1atgqwe](/blog/images/2023/8/25/19q5dz1atgqwe.png)

```mathematica
ImageCollage[{mfl[[34]], two[[-1]]}]
```

![0i7bfoasxmlws](/blog/images/2023/8/25/0i7bfoasxmlws.png)

```mathematica
ImageCollage[{mfl[[22]], ImageReflect[two[[19]], Left -> Right]}]
```

![1bsud25hjfdes](/blog/images/2023/8/25/1bsud25hjfdes.png)

```mathematica
ImageCollage[{mfl[[16]], two[[8]]}]
```

![024nbpfnpghyg](/blog/images/2023/8/25/024nbpfnpghyg.png)

```mathematica
ImageCollage[{mfl[[2]], two[[6]]}]
```

![03g6d0f5jd2sc](/blog/images/2023/8/25/03g6d0f5jd2sc.png)

```mathematica
ImageCollage[{mfl[[24]], c[[11]]}]
```

![1omf7asazem7q](/blog/images/2023/8/25/1omf7asazem7q.png)

```mathematica
ImageCollage[{mfl[[30]], c[[7]]}]
```

![183b1o38oo095](/blog/images/2023/8/25/183b1o38oo095.png)

```mathematica
ImageCollage[{mfl[[-4]], ImageReflect[c[[9]], Left -> Right]}]
```

![1g8xjj6zkxtnt](/blog/images/2023/8/25/1g8xjj6zkxtnt.png)

```mathematica
ImageCollage[{mfl[[18]], two[[11]]}]
```

![1a2gqilyudu0z](/blog/images/2023/8/25/1a2gqilyudu0z.png)

```mathematica
ToJekyll["Imaginary Cinema: In the Mood for Love, but with Chiguiros", "imaginary-cinema chiguiro art"]
```
