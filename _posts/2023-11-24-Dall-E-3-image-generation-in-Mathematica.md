---
Title: "Dall-E-3 image generation in Mathematica"
Date: 2023-11-24
Tags: mathematica openai chiguiro art dall-e-3
---

By default (as of 24 Nov 2023, Mathematica 13.3), it appears that [ImageSynthesize](http://reference.wolfram.com/language/ref/ImageSynthesize.html) uses [Dall-E-2](https://openai.com/dall-e-2/) for image generation, as the results are kind of trash---**but with some tricks you can get it to use [Dall-E-3](https://openai.com/dall-e-3) instead...**:

Here's an example using the default settings:

```mathematica
ImageSynthesize["A cartoon of a a capybara riding a motorcycle and wearing a bowtie"]
```

![0bu6fke9jpskj](/blog/images/2023/11/24/0bu6fke9jpskj.png)

[ImageSynthesize](http://reference.wolfram.com/language/ref/ImageSynthesize.html) does not appear to accept [LLMEvaluator](http://reference.wolfram.com/language/ref/LLMEvaluator.html) option (like [LLMSynthesize](http://reference.wolfram.com/language/ref/LLMSynthesize.html), etc. does):

```mathematica
ImageSynthesize["A cartoon of a a capybara riding a motorcycle and wearing a bowtie", 
  LLMEvaluator -> LLMConfiguration[<|"Model" -> "dall-e-3"|>]]
```

![1wvh6enx5ivpa](/blog/images/2023/11/24/1wvh6enx5ivpa.png)

![05y5yr6y3tfja](/blog/images/2023/11/24/05y5yr6y3tfja.png)

It looks like by default the [OpenAI Service](http://reference.wolfram.com/language/ref/service/OpenAI.html) also uses Dall-E-2 (although I am not sure why it throws this error):

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> "A cartoon of a a capybara riding a motorcycle and wearing a bowtie"}]
```

![0qvmulc8a4jqe](/blog/images/2023/11/24/0qvmulc8a4jqe.png)

![1g05ccmwb4xxe](/blog/images/2023/11/24/1g05ccmwb4xxe.png)

However, there is an (undocumented) model specification ability to specify models.  Notice how [Dall-E-3](https://openai.com/dall-e-3) better captures the characteristic nose shape: 

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> "A cartoon of a a capybara riding a motorcycle and wearing a bowtie", "Model" -> "dall-e-3"}]
```

![1dkm6vjxhczkn](/blog/images/2023/11/24/1dkm6vjxhczkn.png)

![1upgbef4f59zl](/blog/images/2023/11/24/1upgbef4f59zl.png)

Confirm that the default versions use Dall-E-2:

```mathematica
ServiceExecute["OpenAI", "ImageCreate", {"Prompt" -> "A cartoon of a a capybara riding a motorcycle and wearing a bowtie", "Model" -> "dall-e-2"}]
```

![1oevi42a17rcq](/blog/images/2023/11/24/1oevi42a17rcq.png)

![1n8wz7zu2myvb](/blog/images/2023/11/24/1n8wz7zu2myvb.png)

```mathematica
ToJekyll["Dall-E-3 image generation in Mathematica", "mathematica openai chiguiro art"]
```
# Parerga and Paralipomena 

Came across some recent Wolfram Community posts that provide relevant functionality:
- [LLMVisionSynthesize](https://community.wolfram.com/groups/-/m/t/3072318)...and `LLMVisionFunction` for using GPT-4v.  Also shows a nice trick of using the `LLMPrompt["NothingElse"]["JSON"]` and `LLMPrompt["CodeWriter"]`.
  - Available at `Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/Misc/LLMVision.m"] `
- [callDALLE](https://community.wolfram.com/groups/-/m/t/3073374) .. and other functions that support thee Text-to-Speech API and GPT-vision (`callTTS`, `callGPTVision`)
- [Prompting strategies for Dall-E-3, and advanced use of random seed settings, forbidden topics, etc.]((https://simonwillison.net/2023/Oct/26/add-a-walrus/?utm_source=tldrai#peeking-under-the-hood))