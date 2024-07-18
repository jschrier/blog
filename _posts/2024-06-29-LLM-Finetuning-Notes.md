---
title: "LLM Finetuning Notes"
date: 2024-06-29
layout: post
tags: llm finetuning llama3 gpt3.5 ml mistral
---

I've been [doing some fine-tuning experiments lately](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=zJC_7roAAAAJ&sortby=pubdate&citation_for_view=zJC_7roAAAAJ:hkOj_22Ku90C), and while
fine-tuning commercial LLMs like GPT-3.5 is pretty easy and cheap, but there are restrictions on model sharing, control of the algorithm, and cost are a bit annoying. An alternative is to fine-tune open-weight models like Llama-3-8B, etc.  It is relatively easy and cheap to do it on the cloud.  **Some notes on the ecosystem for fine-tuning your own LLMs...with an emphasis on doing this remotely for the GPU poor...**



# What do I care about?

- **Ease of use:**  I'm interested in doing science, rather than screwing around with a lot of fiddly VM configurations.  Fine-tuning as a service is great! Chose my hyperparameters for me!  Make it easy for me to evaluate on test items! 
- **Clarity/Reproducibility:**  We want to report things in scholarly work, so a clear indication of chosen hyperparameters, etc. is important so others can follow us without having to rely on a particular commercial service (which might disappear...).  Also valuable is some way of sharing trained models with others (e.g., by downloading weights). 


(presented in no particular order)

# OpenPipe

- **Ease of Use**: *High*. I tried this for an example problem... it was pretty easy to use with the web-interface, and the use of an OpenAI-compatible data format and REST API made it easy to compare a few different models (incl. OpenAI, LLama-3 variants, Mistral-7b) in a consistent way.  
- **Reproducibility**: *Medium*.  No ability to control (or see) what hyperparameters were used or other specific details.  But easy to download final trained model weights. 


[OpenPipe](https://docs.openpipe.ai/features/fine-tuning) is another service that is designed around being a pass-through that you can use to collect training data from GPT-4 and then use that stored data to fine-tune your own models in production. So there's a way in which we are mis-using this service.

However is easy to upload your own data files; they use the OpenAI JSONL format for training data, but [add a key `split` which lets you specify train/test split (otherwise it will randomly select 10%)](https://docs.openpipe.ai/features/uploading-data#additional-fields).  But, (as of late-June 2024)there is no way to download these test results.  They want you to do LLM-based reranking and evaluation as a comparison, but don't support a simple data download. So you have to re-call the model to do inferences if you want this data (which is slightly wasteful, but so it is). Those [evaluation capabilities](https://docs.openpipe.ai/features/evaluations), are mostly based on GPT-4 rescoring rather than the types of supervised checking that we use.

 [Current base models support a few different things, including Llama-3 variants  and a pass-through to GPT-3.5](https://docs.openpipe.ai/base-models).  

One nice feature is an an "export weights" option on the model information page that lets you download  them (assuming you are not using GPT-3.5). Great for reproducibility! 

What is frustrating is that you can't see what the automatically-chosen hyperparameters were. You're really in the dark here. (The exception is for fine-tuning the OpenAI models, in which case you can go to platform.openai.com and find all the goodies there.)

You've got to use the web-interface; as of late-June 2024, the API for fine-tuning is still in beta.


# Predibase

[Predibase](https://predibase.com) is a business exclusively oriented around open-source model fine-tuning using [Lorax](https://loraexchange.ai).  A quick look at the docs suggests that they are very flexible about input data formats and they support a wide variety of models.  Unclear to me how you can export/share your models, but give it a shot. 

Under the hood, it uses [Ludwig](https://Ludwig.ai) to configure fine-tuning and [Lorax](https://loraexchange.ai/) to serve the adapters efficiently. You can run these locally.

They also maintain a [useful leaderboard](https://predibase.com/fine-tuning-index) *(and check link there for their ArXiV paper)* comparing fine-tuning performance on a variety of tasks. As of late-June 2024, llama-3-8b is pretty much the best choice, fwiw.

# Huggingface / autotrain

[Autotrain](hf.co/autotrain) is a general purpose open-source software package for no-code training/fine-tuning models (LLMS, image generation, tabular data). It is created/maintained by [Huggingface](https://huggingface.co) (gotta support our [NYC homies](https://maps.app.goo.gl/3UpDMTG8ArDG8SRK6)).  

You can run it locally, or hosted with compute provide by HF, run in a google collab, or inside a VM hosted on [JarvisLab](https://jarvislabs.ai/templates/autotrain) (for example); in that way it is quite flexible.  The GUI has a basic and advanced mode, but you can export (or modify) the inputs in a JSON/YAML config file.  Under the hood it is powered by the `accelerate` package (also maintained by HF), which handles distributing load over multiple GPUs, data packing, etc.

The integration with HF is quite convenient: You can pull data hosted on HF and pull it in, pull a base model from HF, and then push the resulting model to HF.  It handles most of the common data formats (e.g., ChatML), and fine-tuning modes (e.g. qLORA, etc); not necessarily the most cutting edge package or the finest granularity of control over data, but covers most of the common options.  


# Axolotl / JarvisLabs

[Axolotl](https://github.com/OpenAccess-AI-Collective/axolotl/) is a python package that provides an abstraction layer for fine-tuning.  Essentially everything gets driven by a long YAML file. You can run Axolotl anywhere you want, but it is convenient to have all the dependencies preconfigured.

[JarvisLabs](https://jarvislabs.ai) is a cloud compute service (GPU by the hour).  Their prices seem OK; main advantage seems to be a variety of pre-built packages for common AI workflows.  They provide a [pre-built container for Axolotl fine-tuning](
https://jarvislabs.ai/templates/axolotl) which makes it pretty easy and the video they provide is a good starting point.  A suggestion is to use `tiny-llama/qlora.yaml` as hello-world example instead, as it is faster than the example they provide.


# Replicate

[Replicate](https://replicate.com) is a service that hosts open-weight models, lets you post them (by using [Cog](https://github.com/replicate/cog)), and then serves them to public users, including a lightweight web-UI.  

Additionally (in beta) it supports [model fine-tuning](https://replicate.com/docs/guides/fine-tune-a-language-model), however as of 12 June 2024 their [Current list of trainable language models](https://replicate.com/docs/guides/fine-tune-a-language-model) only includes Llama-2-class models.   The developer says it is best to use the `chat` versions; for now this [does not include the models that support structured grammars](https://replicate.com/collections/language-models-with-grammar)


# Axolotl / Modal  

Modal provides way to do remote procedure calling in python made easy...especially focused on data-intensive applications where you want the data to live remotely near the compute.  There's a lot of slickness that extends beyond LLMs, but...

Their [tutorial documentation has a demonstration for fine-tuning with Axolotl](https://modal.com/docs/examples/llm-finetuning)

This is a way to stay closer to the metal (you are doing Axolotl after all), but without all of the complexity of configuring an entire virtual machine instance.  It's also useful for doing numerical compute type things, but that's a topic for another blog post.


# Mistral

[Mistral](https://mistral.ai) provides [fine-tuning](https://docs.mistral.ai/guides/finetuning) as a service through *LaPlateforme* but also has a [python package to facilitate fine-tuning their models your own (VM) hardware](https://github.com/mistralai/mistral-finetune/tree/main). 

**Cloud**: Minimum fee of $4 and monthly storage fee of $2 for each model.  Models are apparently only usable within a billing organization (like OpenAI), which is a downside for sharing.  As of late-June 2024, they only support fine tuning `open-mistral-7b` and `mistral-small`.  There's a limit of 512 MB training data and 1MB validation data. It's pretty bare-bones 

**Local/VM**:  There's a [video on the internet walking through the process](https://www.youtube.com/watch?v=bO-b5Soxzxk)...doesn't look too hard.  You can do it on collab or a A100 instance. It's pretty bare bones.  The advantage of doing it this way is that it provides the ability to do batch inferences more efficiently (by just driving it directly in Python rather than having to make http requests.)

# Mac stuff

I've been looking for an excuse to buy a maxed out [Mac Studio with 192GB of RAM](https://www.apple.com/mac-studio/specs/)...

There's a [HF community for MLX users](https://huggingface.co/docs/hub/en/mlx) that provides basic examples of converting/running/fine-tuning LLMs.

Folks have also done [fine-tuning of Mistral and Llama on M2Ultras](https://github.com/ml-explore/mlx-examples/tree/main/lora) and [also](https://github.com/ml-explore/mlx-examples/blob/main/llms/mlx_lm/LORA.md) at 475 tokens/sec; given that our past work was about 1M tokens of fine-tuning, we could crank it out in 35 minutes which ain't bad.  

# Unsloth

Unsloth is a library for performance tunning LLMs and they have a worked example of [fine tuning Llama-3 with UnSloth and Export to Ollama on a Collab instance](https://docs.unsloth.ai/tutorials/how-to-finetune-llama-3-and-export-to-ollama) 



# Miscellaneous tips

- [Prompting Llama](https://replicate.com/blog/how-to-prompt-llama): Key take-aways...keep the system prompt short, format chat prompts with `[INST] [/INST]`, and be aware of 4096 token window.  Otherwise the usual guidance applies
- In their use of [Llama-2 fine tuning to generate crystal structures, Ulissi & co](https://arxiv.org/pdf/2402.04379) used LoRA rank 8 and alpha 32 

# Other things seen on the internet

- Alex Strick van Linschoten has been following the same LLM fine-tuning course as me, and has written blog posts about his experiences doing a [local (4-bit quantized) fine-tune using Axolotl](https://mlops.systems/posts/2024-06-15-isafpr-first-finetune.html) and comparing [one-click fine-tuning on Predibase, OpenPipe, and OpenAI](https://mlops.systems/posts/2024-06-17-one-click-finetuning.html) and [head to head comparisons and evals of his fine-tuned models against GPT-4](https://mlops.systems/posts/2024-07-01-full-finetuned-model-evaluation.html)
- [Distributed fine tuning Gemma 2 - 27B with Keras](https://developers.googleblog.com/zh-hans/fine-tuning-gemma-2-with-keras-hugging-face-update/) guide from Goog

