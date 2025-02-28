---
title: "Hacking Meta Rayban Glasses"
date: 2024-07-18
tags: fashion diy webdev llama3
---

Confession:  I bought a pair of [Meta Rayban smart glasses](https://www.meta.com/smart-glasses/).  Built in functionality is cool, but of course, a hackers gotta hack.  **So how can you run other things on them?...**

- [Write a WhatsApp server to intercept messages](https://jovanovski.medium.com/part-2-getting-chatgpt-working-on-meta-smart-glasses-82e74c9a6e1e).  The idea is that you can then tell the glasses to send a message to that WhatsApp name, and then your app on the other side can run something and send it back as a WhatsApp message. There's an [implementation that uses PHP](https://github.com/jovanovski/meta-glasses-gpt/tree/main/whatsapp-approach), but I'm sure you could cook up a little Flask app to do this. Heck...host it on Modal with all those credits burning a hole in my pocket 
    - Indeed, there are [tutorials](https://www.youtube.com/watch?v=uN_MNOaoxBU) and [examples](https://github.com/gustavz/whatsbot) on how to build WhatsApp webhook apps in flask.
    - Better:  Meta has an official tutorial on [Sending Messages with WhatsApp in Your Python Applications](https://developers.facebook.com/blog/post/2022/10/24/sending-messages-with-whatsapp-in-your-python-applications/)
    - **(Update: 31 July 2024)** It appears that [TryMartin.com](https://news.ycombinator.com/item?id=41119443) essentially does this, sitting on a WhatApp endpoint.  So maybe the problem is solved...but not yet available for Android.
    
- Just use the bluetooth headset and route to [OpenAI app](https://www.reddit.com/r/ChatGPT/comments/18176er/can_i_use_chatgpt_for_handsfree_conversations/) to do hands free chat.  
    - Or if you're feeling frisky, try to use an [Android app that calls the underlying API](https://www.reddit.com/r/ChatGPT/comments/13cv0w5/i_made_a_free_opensource_gptpowered_voiceoperated/) ([recent versions can use Whisper and Anthropic API too](https://play.google.com/store/apps/details?id=org.mtopol.assistant))

- [Livestream the video to Instagram...and then have a separate process watch the video and send messages](https://www.theverge.com/2024/10/2/24260262/ray-ban-meta-smart-glasses-doxxing-privacy).  [Some documentation available](https://docs.google.com/document/d/1iWCqmaOUKhKjcKSktIwC3NNANoFP7vPsRvcbOIup_BA/edit)

- Just in case you were wondering...you don't have to say 'Hey Meta..." to use the voice features.  They all work fine if you say "Ok Meta..." or...you can configure the touch button (touch and hold) to activate the assistant without any wake words.  I'm still waiting for someone to hack the wake word so you can say "Control..." (like in [Max Headroom](https://youtu.be/gCgIEgMpspI?si=2j3FoPuaWEL0PpGG))

# Mini-review and FAQ

- Q: How do you like them? Pros/cons.
- A: In summary: they're a camera and bluetooth headphones/microphone that you wear as glasses.  Fit and finish is excellent. Battery life is minimum viable product level: you can drain them in a few hours by taking a bunch of photos or videos or bluetooth audio...maybe fine if you are an optional glasses wearer (and can thus take them off to charge), less good if you have to wear glasses all day.  It's useful to be able to take hands-free photos (I can see lots of opportunities for making tutorials). AI assistant features are hit-or-miss:  It's kind of neat to have "Hey meta, take a look and define this word" (use photo, interpret where finger is pointed, return a definition).  But translation failed on a chinese newspaper headline (as of 07/2024).   I am a very text-oriented person, so audio-based interactions are novel for me.  
- A: One cool thing I did the other day while reading a book was ask the AI questions and examples related to terms in the book.  It was a nice way not to break the flow of reading.


- Q: How can you connect multiple devices for audio?
- A: [See these Reddit instructions](https://www.reddit.com/r/RayBanStories/comments/17xlych/comment/lfoqt7m/); tldr—-turn off bluetooth on your existing device, put them in the case, push the pairing button on the back of the case until the light turns blue, then just pair them.  You can pair multiple your glasses to multiple devices.  The AI and message functions still pass through from your phone.

# Ideas for applications that should exist

 My running list of app ideas (probably using the Whatsapp hack):

- ~~*You can't schedule a timer with the voice assistant (as of July 2024).*  Idea:  TimerApp -- This seems like it would be easy.  "OK meta, send message to timer on whatsapp.  Set timer to 34 minutes. (Or: Remind to take out the wash in 34 minutes)" (run a flask app, parse inputs with a lightweight model, put it in a cron-job queue, and then send the message back to whatsapp when the timer is up)~~ (**Update 10/2024** This got added as a feature in the latest update. I tested it while doing laundry and it worked great.)

- *The AI asssistant feels like a Llama-3-8B class model, with a system prompt that focuses on brevity.* (as of late July 2024...maybe we'll start seeing Llama-3.1 outputs?) Brevity is certainly valuable for voice assistants, but sometimes you want more.  Idea: More comprehensive research assistant:  "OK meta, send message to resarch on whatsapp.  Do a literature search on xxx." (intercepted by a flask app that runs an agent process, results in a written summary delivered via Whatsapp).  By default, when the assistant receives a sufficiently long whatsapp message, it does not read it aloud, and that seems like the right behavior for something like this. 

- Games:  Take a photo and tell me what move I should make in chess/backgammon/go.  Apparently [the current generation of vision models is not good at even looking at schematic chess boards and deducing positions](https://www.linkedin.com/posts/aroraaman_given-an-input-image-of-a-chess-board-can-activity-7219166035889856513-tVS6). So maybe you would need to fine tuning a vision model to do this? Could "readily" be simulated (different angles of viewing the board, different colors, lighting, etc. by rendering).
    - **Update:  01/2025:** Some [kids recently did this](https://x.com/eddybuild/status/1878263416080482312) by: (i) Livestreaming video to instagram; (ii) having a remote computer do piece detection (presumably with YOLO or something like it) and feed inputs to stockfish; (iii) send response as an instagram live comment, which gets read as audio during the session to the user.  This is essentially the same as the face-recogintion trick described above.
    
