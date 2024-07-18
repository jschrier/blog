---
title: "Hacking Meta Rayban Glasses"
date: 2024-07-16
tags: fashion  diy
---

Confession:  I ordered a pair of [Meta Rayban smart glasses](https://www.meta.com/smart-glasses/).  They haven't arrived yet. Built in functinality seems cool, but of course, a hackers gotta hack.  **So how can you run other things on them?...**

- [Write a WhatsApp server to intercept messages](https://jovanovski.medium.com/part-2-getting-chatgpt-working-on-meta-smart-glasses-82e74c9a6e1e).  The idea is that you can then tell the glasses to send a message to that WhatsApp name, and then your app on the other side can run something and send it back as a WhatsApp message. There's an [implementation that uses PHP](https://github.com/jovanovski/meta-glasses-gpt/tree/main/whatsapp-approach), but I'm sure you could cook up a little Flask app to do this. Heck...host it on Modal with all those credits burning a hole in my pocket 
- Just use the bluetooth headset and route to [OpenAI app](https://www.reddit.com/r/ChatGPT/comments/18176er/can_i_use_chatgpt_for_handsfree_conversations/) to do hands free chat.  
    - Or if you're feeling frisky, try to use an [Android app that calls the underlying API](https://www.reddit.com/r/ChatGPT/comments/13cv0w5/i_made_a_free_opensource_gptpowered_voiceoperated/) ([recent versions can use Whisper and Anthropic API too](https://play.google.com/store/apps/details?id=org.mtopol.assistant))