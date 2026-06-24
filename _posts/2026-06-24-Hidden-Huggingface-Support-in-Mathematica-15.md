---
title: "Hidden HuggingFace Support in Mathematica 15?"
date: 2026-06-24
tags: mathematica ml gpt5
---

Some random spelunking in Mathematica 14.3 revealed to me what appeared to be a hidden [HuggingFace](https://huggingface.co/) service connection. Seeing that the [new Mathematica 15](https://writings.stephenwolfram.com/2026/06/launching-version-15-of-wolfram-language-mathematica-built-in-useful-ai-lots-of-new-core-functionality/) does not declare this publicly, I asked codex (`gpt-5.5-medium`) to take a closer look and generate a few examples... 


## But first, a word from our human

**t;dr: There's an non-public Paclet that implements some of the API features, but coverage is inconsistent for remote inference calls.  My recommendation for now is to roll your own with [CreateServiceConnectionPacklet](https://resources.wolframcloud.com/FunctionRepository/resources/CreateServiceConnectionPaclet)**

[After configuring the local MCP service](https://www.wolfram.com/artificial-intelligence/mcp/local/wolfram-mcp-local/), ask for a research phase in a new codex session: 

```
I have a suspicion that Mathematica 15 supports interactions with Huggingface. 
Do some spelunking into possible unexposed ServiceConnections
```

When it seemed to have worked, generated the below report:
```
OK. I want you to write up a blog post as a Jekyll markdown file that describes these results.  
First describe the evidence about this "hidden" Huggingface support in Mathematica 
(include code examples in markdown code blocks and relevant output so that a reader can verify
for himself).  Then show one or two simple examples (e.g., listing some models, running an 
interference) that are supported by this. Include any setup that is necessary. For now, you can
include the API key in the output; I will be sure to remove it before publication.
``` 

It wasn't so challenging; I essentially let this cook while finishing some paperwork:

```
Token usage: total=204,028 input=185,165 (+ 1,745,536 cached) output=18,863 (reasoning 3,235)
To continue this session, run codex resume 019ef666-0d0e-7112-a05a-8432e91c2c56
```

Indeed, I went through and saved a (read-only) Hugging face API key in a secure place for later use: 

```wl
SystemCredential["huggingface_read"] = "YOUR-API-KEY-HERE"
```

(and replaced the key with the relevant lookup.) as well as removing some unnecessary key lookups. 

So let's take a look at what the clanker said... Below text is lightly edited output...




## First glance

Mathematica 15 appears to ship with a partially wired Hugging Face service connection. It is not listed in `$Services`, and `ServiceConnect["HuggingFace"]` fails, but the implementation files are present and the lower-level key-service path can be made to work.

This post documents the evidence, then gives a few reproducible examples. 

## Environment

The tests below were run in Wolfram Language 15.0 on macOS:

```wl
{$Version, $VersionNumber}
```

Output:

```wl
{"15.0.0 for Mac OS X x86 (64-bit) (May 19, 2026)", 15.}
```

## It is not exposed through `$Services`

The public service list does not include Hugging Face:

```wl
{
  MemberQ[$Services, "HuggingFace"],
  Select[$Services, StringContainsQ[#, "Hugging" | "Face", IgnoreCase -> True] &],
  Length[$Services],
  $Services
}
```

Output:

```wl
{
  False,
  {},
  39,
  {
    "AI21", "AlphaFoldDatabase", "Anthropic", "ArXiv", "AWS",
    "AzureOpenAI", "BingSearch", "CATHDatabase", "ChemSpider",
    "Cohere", "CrossRef", "DeepSeek", "Dropbox", "ElevenLabs",
    "EncyclopediaOfDomains", "ESMAtlas", "FederalReserveEconomicData",
    "GoogleCustomSearch", "GoogleGemini", "GoogleSpeech",
    "GoogleTranslate", "Groq", "MicrosoftTranslator", "MistralAI",
    "Ollama", "OneDrive", "OpenAI", "OpenLibrary", "OpenRouter",
    "PubChem", "PubMed", "Pushbullet", "RCSBProteinDataBank",
    "Reddit", "TogetherAI", "Twilio", "UniProt", "xAI", "Yelp"
  }
}
```

Consequently, the usual front door fails:

```wl
ServiceConnect["HuggingFace"]
```

Output:

```wl
$Failed
```

## But the paclet is present

Searching installed paclets reveals a `ServiceConnection_HuggingFace` paclet:

```wl
PacletFind[All] //
  Select[StringContainsQ[ToString[#], "HuggingFace", IgnoreCase -> True] &]
```

Output:

```wl
{
  PacletObject[
    <|
      "Name" -> "ServiceConnection_HuggingFace",
      "Version" -> "1.0.0",
      "MathematicaVersion" -> "13.3+",
      "Extensions" -> {
        {
          "Kernel",
          "Root" -> "Kernel",
          "Context" -> {"HuggingFace`", "HuggingFaceLoad`"}
        }
      },
      "Location" -> "/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace"
    |>
  ]
}
```

The interesting detail is that this paclet declares only a `"Kernel"` extension. It does not declare a `"ServiceConnection"` extension. That explains why the service is not discovered by `$Services`.

The manifest is at:

```text
/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace/PacletInfo.m
```

Relevant contents:

```wl
Paclet[
  Name -> "ServiceConnection_HuggingFace",
  Version -> "1.0.0",
  MathematicaVersion -> "13.3+",
  Extensions ->
    {
      {
        "Kernel",
        Root -> "Kernel",
        Context -> {"HuggingFace`", "HuggingFaceLoad`"}
      }
    }
]
```

## The implementation is real

The loader registers a key service:

```wl
Get["/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace/Kernel/HuggingFaceLoad.m"]
```

Relevant contents:

```wl
BeginPackage["HuggingFaceLoad`"]

Begin["`Private`"]

If[!ListQ[System`$Services], Get["OAuth`"]]

Block[{dir=DirectoryName[System`Private`$InputFileName]},
  KeyClient`addKeyservice["HuggingFace", dir]
]

End[]

EndPackage[]
```

The main implementation defines a service named `"HuggingFace"`:

```wl
Get["/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace/Kernel/HuggingFace.m"]
```

Relevant contents:

```wl
params = <||>;

params["ServiceName"] = "HuggingFace";

params["AuthFunction"] =
  Function[key, <|"Headers" -> {"authorization" -> "Bearer " <> key}|>];

params["AsynchronousParameter"] = "stream";

params["ClientInfo"] :=
  OAuthDialogDump`Private`MultipleKeyDialog[
    "HuggingFace",
    {"API Key" -> "APIKey"},
    "https://huggingface.co/login/",
    "https://huggingface.co/terms-of-service/"
  ];

params["Information"] = "Use HuggingFace models within the Wolfram Language";
```

It also defines raw Hugging Face Hub API calls:

```wl
params["RawRequests", "RawModels"] = {
  "URL"               -> "https://huggingface.co/api/models",
  "HTTPSMethod"       -> "GET",
  "Headers"           -> {
    "accept" -> "application/json",
    "content-type" -> "application/json"
  },
  "Parameters"        -> {
    "search", "author", "filter", "sort", "direction",
    "limit", "full", "config"
  },
  "ResultsFunction"   -> ServiceConnectionUtilities`ImportResponse
};
```

and an older Inference API endpoint:

```wl
params["RawRequests", "RawTextGeneration"] = {
  "URL" -> Function[
    StringTemplate["https://api-inference.huggingface.co/models/`1`"][##]
  ],
  "HTTPSMethod" -> "POST",
  "Headers" -> {
    "accept" -> "application/json",
    "content-type" -> "application/json"
  },
  "PathParameters" -> {"model"},
  "Parameters" -> {
    "min_length", "max_length", "top_k", "top_p",
    "temperature", "repetition_penalty", "max_time", "inputs"
  },
  "RequiredParameters" -> {"inputs", "model"},
  "ResultsFunction" -> ServiceConnectionUtilities`ImportResponse
};
```

Finally, it calls:

```wl
ServiceConnectionUtilities`DefineServiceConnection[
  HuggingFace`Private`params,
  "LegacyMode" -> True
]
```

That legacy-mode call builds OAuth-era key-service functions rather than exposing a modern `ServiceConnection` paclet extension.

## What requests are available?

After manually loading the files, the hidden request table can be inspected:

```wl
Get["OAuth`"];
Get["/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace/Kernel/HuggingFaceLoad.m"];
Get["/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace/Kernel/HuggingFace.m"];

{
  MemberQ[KeyClient`$predefinedKeyservicelist, "HuggingFace"],
  KeyClient`KeyServicesData["HuggingFace", "RawGets"],
  KeyClient`KeyServicesData["HuggingFace", "RawPosts"],
  KeyClient`KeyServicesData["HuggingFace", "Posts"]
}
```

Output:

```wl
{
  True,
  {
    "RawModels", "RawDatasets", "RawDataset",
    "RawDatasetRevision", "RawMetrics", "RawWho"
  },
  {
    "RawConversation", "RawTextGeneration",
    "RawTextSummarization", "RawAudioTranscription"
  },
  {"Chat", "SpeechRecognize"}
}
```

So the shipped connection knows about:

```text
RawModels
RawDatasets
RawDataset
RawDatasetRevision
RawMetrics
RawWho
RawConversation
RawTextGeneration
RawTextSummarization
RawAudioTranscription
Chat
SpeechRecognize
```

## Setup

The normal `ServiceConnect["HuggingFace"]` route is blocked by the missing `$Services` exposure. Use the lower-level key client instead:

```wl
Get["OAuth`"];
Get["/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace/Kernel/HuggingFaceLoad.m"];
Get["/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace/Kernel/HuggingFace.m"];

hf = KeyClient`keyauthenticate[
  "HuggingFace",
  Automatic,
  {Authentication -> {"APIKey" -> SystemCredential["huggingface_read"]}}
];
```

Verify that it created an authenticated service object:

```wl
id = ServiceConnections`Private`getServiceID[hf];

{
  Head[hf],
  MemberQ[ServiceConnections`Private`$authenticatedservices, id],
  ServiceConnections`Private`availablequeries[id]
}
```

Output:

```wl
{
  ServiceObject,
  True,
  {
    "RawDataset", "RawDatasetRevision", "RawDatasets", "RawMetrics",
    "RawModels", "RawWho", "Chat", "SpeechRecognize",
    "RawAudioTranscription", "RawConversation", "RawTextGeneration",
    "RawTextSummarization", "RawDataset", "RawDatasetRevision",
    "RawDatasets", "RawMetrics", "RawModels", "RawWho", "Chat",
    "SpeechRecognize", "RawAudioTranscription", "RawConversation",
    "RawTextGeneration", "RawTextSummarization", "Authentication",
    "ID", "Information", "Name", "Requests", "RawRequests"
  }
}
```

## Example 1: account information

The `RawWho` request works:

```wl
who = KeyClient`keydata[hf, "RawWho"]
```

Output:

```wl
<|
  "type" -> "user",
  "name" -> "jschrier",
  "fullname" -> "Joshua Schrier",
  "email" -> "jschrier@fordham.edu",
  "isPro" -> False,
  "avatarUrl" -> "/avatars/b6cb05c468167af55c416bb48b6788d6.svg"
  "auth" -> <|
    "type" -> "access_token",
    "accessToken" -> <|
      "displayName" -> "desktop-mathematica-read",
      "role" -> "read",
      "createdAt" -> "2026-06-23T21:44:06.817Z"
    |>
  |>,
  "orgs" -> {}
|>
```

This confirms that the token is accepted by Hugging Face and that Mathematica can use the hidden connection for authenticated Hub API calls.

## Example 2: listing models

List one current model from the Hugging Face Hub:

```wl
models = KeyClient`keydata[hf, "RawModels", "limit" -> 1] // First;
```

Output:

```wl
<|
  "_id" -> "6a30fda88514bfa5f01a33b6",
  "id" -> "zai-org/GLM-5.2",
  "likes" -> 2288, 
  "trendingScore" -> 1247, 
  "private" -> False, 
  "downloads" -> 57186, 
  "tags" -> {"transformers", "safetensors", "glm_moe_dsa", "text-generation", "conversational", "en", "zh", "arxiv:2602.15763", "arxiv:2603.12201", "license:mit", "eval-results", "endpoints_compatible", "region:us"},
  "pipeline_tag" -> "text-generation",
  "library_name" -> "transformers",
  "private" -> False,
  "downloads" -> 40127,
  "createdAt" -> "2026-06-16T07:39:20.000Z",
  "modelId" -> "zai-org/GLM-5.2"
|>
```

Search for a specific family of models:

```wl
gptoss = KeyClient`keydata[
  hf,
  "RawModels",
  "search" -> "gpt-oss",
  "limit" -> 3
];

KeyTake[#, {"id", "pipeline_tag", "downloads"}] & /@ gptoss
```

Example output:

```wl
{
  <|"id" -> "openai/gpt-oss-120b", "pipeline_tag" -> "text-generation", "downloads" -> 4089743|>,
  <|"id" -> "cloudyu/gpt-oss-120b-Fable-5-Distilled", "downloads" -> 4482|>,
  <|"id" -> "openai/gpt-oss-20b", "pipeline_tag" -> "text-generation", "downloads" -> 6950709|>
}
```

## Example 3: current inference through the Hugging Face router

The hidden Mathematica connector's built-in inference endpoint points to:

```text
https://api-inference.huggingface.co/models/...
```

In this test environment, that failed:

```wl
KeyClient`keydata[
  hf,
  "RawTextGeneration",
  "model" -> "gpt2",
  "inputs" -> "The Wolfram Language is",
  "max_length" -> 12
]
```

Output:

```wl
URLRead::invhttp: "Could not resolve host: api-inference.huggingface.co".
Failure["ServiceError", <|"Message" -> "Malformed function call."|>]
```

That appears to be a stale endpoint in the hidden connector, not a bad token. Hugging Face's current Inference Providers documentation uses:

```text
https://router.huggingface.co/v1/chat/completions
```

The router endpoint can be called directly from Wolfram Language:

```wl
body = ExportString[
  <|
    "model" -> "openai/gpt-oss-120b:fastest",
    "messages" -> {
      <|
        "role" -> "user",
        "content" -> "Reply with exactly: Mathematica HuggingFace works"
      |>
    },
    "stream" -> False
  |>,
  "RawJSON"
];

req = HTTPRequest[
  "https://router.huggingface.co/v1/chat/completions",
  <|
    "Method" -> "POST",
    "Headers" -> {
      "Authorization" -> "Bearer " <> SystemCredential["huggingface_read"],
      "Content-Type" -> "application/json"
    },
    "Body" -> body
  |>
];

res = URLRead[req, {"StatusCode", "Body"}];
```

Output:

```wl
<|
  "StatusCode" -> 200,
  "Body" -> "{\"id\":\"chatcmpl-e9ba6ea4-d658-4d44-a0dc-bcbe631164ae\",\"choices\":[{\"finish_reason\":\"stop\",\"index\":0,\"message\":{\"content\":\"Mathematica HuggingFace works\",\"reasoning\":\"User wants a reply with exactly: \\\"Mathematica HuggingFace works\\\". Must respond exactly that phrase, no extra whitespace, punctuation, etc. Ensure exactly that string.\",\"role\":\"assistant\"}}],\"created\":1782251144,\"model\":\"gpt-oss-120b\",\"system_fingerprint\":\"fp_8a76e344b64d754137e2\",\"object\":\"chat.completion\",\"usage\":{\"total_tokens\":129,\"completion_tokens\":52,\"completion_tokens_details\":{\"accepted_prediction_tokens\":0,\"rejected_prediction_tokens\":0,\"reasoning_tokens\":35},\"prompt_tokens\":77,\"prompt_tokens_details\":{\"cached_tokens\":0}},\"time_info\":{\"created\":1782251144.3063283,\"queue_time\":0.004004579,\"prompt_time\":0.003160823,\"completion_time\":0.033123837,\"total_time\":0.042298316955566406}}"
|>
```

Extract the assistant response:

```wl
ImportString[res["Body"], "RawJSON"]["choices"][[1, "message", "content"]]
```

Output:

```wl
"Mathematica HuggingFace works"
```

## Summary

Mathematica 15 ships a real Hugging Face implementation under:

```text
/Applications/Wolfram.app/Contents/SystemFiles/Components/HuggingFace
```

It is hidden because the paclet is not exposed as a public `"ServiceConnection"` extension and `"HuggingFace"` is absent from `$Services`.

The old `ServiceConnect`/`ServiceExecute` path rejects it, but the lower-level key-client API works for Hub API requests:

```wl
KeyClient`keydata[hf, "RawWho"]
KeyClient`keydata[hf, "RawModels", "limit" -> 1]
KeyClient`keydata[hf, "RawDatasets", "limit" -> 1]
KeyClient`keydata[hf, "RawMetrics"]
```

For inference, the bundled endpoint appears stale. The current Hugging Face router API works directly from Wolfram Language using `HTTPRequest` and `URLRead`.

Reference: [Hugging Face Inference Providers documentation](https://huggingface.co/docs/inference-providers/index).
