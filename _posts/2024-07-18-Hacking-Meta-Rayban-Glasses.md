---
title: "Hacking Meta Rayban Glasses"
date: 2024-07-18
tags: fashion diy webdev
---

Confession:  I bought a pair of [Meta Rayban smart glasses](https://www.meta.com/smart-glasses/).  Built in functinality is cool, but of course, a hackers gotta hack.  **So how can you run other things on them?...**

- [Write a WhatsApp server to intercept messages](https://jovanovski.medium.com/part-2-getting-chatgpt-working-on-meta-smart-glasses-82e74c9a6e1e).  The idea is that you can then tell the glasses to send a message to that WhatsApp name, and then your app on the other side can run something and send it back as a WhatsApp message. There's an [implementation that uses PHP](https://github.com/jovanovski/meta-glasses-gpt/tree/main/whatsapp-approach), but I'm sure you could cook up a little Flask app to do this. Heck...host it on Modal with all those credits burning a hole in my pocket 
    - Indeed, there are [tutorials](https://www.youtube.com/watch?v=uN_MNOaoxBU) and [examples](https://github.com/gustavz/whatsbot) on how to build WhatsApp webhook apps in flask.
    - Better:  Meta has an official tutorial on [Sending Messages with WhatsApp in Your Python Applications](https://developers.facebook.com/blog/post/2022/10/24/sending-messages-with-whatsapp-in-your-python-applications/)
- Just use the bluetooth headset and route to [OpenAI app](https://www.reddit.com/r/ChatGPT/comments/18176er/can_i_use_chatgpt_for_handsfree_conversations/) to do hands free chat.  
    - Or if you're feeling frisky, try to use an [Android app that calls the underlying API](https://www.reddit.com/r/ChatGPT/comments/13cv0w5/i_made_a_free_opensource_gptpowered_voiceoperated/) ([recent versions can use Whisper and Anthropic API too](https://play.google.com/store/apps/details?id=org.mtopol.assistant))

- Just in case you were wondering...you don't have to say 'Hey Meta..." to use the voice features.  They all work fine if you say "Ok Meta..." or...you can configure the touch button (touch and hold) to activate the assistant without any wake words.  I'm still waiting for someone to hack the wake word so you can say "Control..." (like in [Max Headroom](https://youtu.be/gCgIEgMpspI?si=2j3FoPuaWEL0PpGG))

# Mini-review

Q: How do you like them? Pros/cons.

A: In summary: they're a camera and bluetooth headphones/microphone that you wear as glasses.  Fit and finish is excellent. Battery life is minimum viable product level: you can drain them in a few hours by taking a bunch of photos or videos or bluetooth audio...maybe fine if you are an optional glasses wearer (and can thus take them off to charge), less good if you have to wear glasses all day.  It's useful to be able to take hands-free photos (I can see lots of opportunities for making tutorials). AI assistant features are hit-or-miss:  It's kind of neat to have "Hey meta, take a look and define this word" (use photo, interpret where finger is pointed, return a definition).  But translation failed on a chinese newspaper headline.   I am a very text-oriented person, so audio-based interactions are novel for me.


# Ideas for applications that should exist

 My running list of app ideas (probably using the Whatsapp hack):

- *You can't schedule a timer with the voice assistant (as of July 2024).*  Idea:  TimerApp -- This seems like it would be easy.  "OK meta, send message to timer on whatsapp.  Set timer to 34 minutes. (Or: Remind to take out the wash in 34 minutes)" (run a flask app, parse inputs with a lightweight model, put it in a cron-job queue, and then send the message back to whatsapp when the timer is up)

- *The AI asssistant feels like a Llama-3-8B class model, with a system prompt that focuses on brevity.* (as of late July 2024...maybe we'll start seeing Llama-3.1 outputs?) Brevity is certainly valuable for voice assistants, but sometimes you want more.  Idea: More comprehensive research assistant:  "OK meta, send message to resarch on whatsapp.  Do a literature search on xxx." (intercepted by a flask app that runs an agent process, results in a written summary delivered via Whatsapp).  By default, when the assistant receives a sufficiently long whatsapp message, it does not read it aloud, and that seems like the right behavior for something like this. 

- Games:  Take a photo and tell me what move I should make in chess/backgammon/go.  Apparently [the current generation of vision models is not good at even looking at schematic chess boards and deducing positions](https://www.linkedin.com/posts/aroraaman_given-an-input-image-of-a-chess-board-can-activity-7219166035889856513-tVS6). So maybe you would need to fine tuning a vision model to do this? Could "readily" be simulated (different angles of viewing the board, different colors, lighting, etc. by rendering).

