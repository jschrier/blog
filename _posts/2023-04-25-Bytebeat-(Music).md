---
Title: "Bytebeat (music)"
Date: 2023-04-25
Tags: audio synth 8bit mathematica
---

[Bytebeat](https://stellartux.github.io/websynth/guide.html) is a genre of electronic music defined by short C programs of the form:
```c
main() {
for (;; t++) putchar(EXPRESSION); }
```
where `EXPRESSION` consists of standard arithmetic and bitwise operators acting on integers; no function calls are allowed and the only variable is the time counter `t` which is never modified within the expression. While the expression is typically evaluated with 32 or more bits of integer accuracy, only the eight lowest bits of each result show up in the output, and this low byte is interpreted as unsigned [8-bit PCM sample values](https://en.wikipedia.org/wiki/Pulse-code_modulation) with the rate of 8000 samples per second.  Some examples, history and notes, and Mathematica implementations...

# Examples

* [This is a great explorer code (HTML renderer)](https://greggman.com/downloads/examples/html5bytebeat/html5bytebeat.html)
* Viznut's [Bytebeat: Music from very short programs - the 3rd iteration](https://www.youtube.com/watch?v=tCRPUv8V22o&t=0s)
* Gabriel Viznelli's [Music from very short C programs - Continuation](https://www.youtube.com/watch?v=V4GfkFbDojc) 
* Thunderspot's [Music From Byte Beat - Short Codes For Awesome Music (Old Video Lq)](https://www.youtube.com/watch?v=cClYQtXQyv4) -- check the comments to links to some great codes


# How does this work? 
*  An accidental discovery by Viznut in 2011...[Algorithmic symphonies from one line of code -- how and why?](http://countercomplex.blogspot.com/2011/10/algorithmic-symphonies-from-one-line-of.html)
* Viznut (2011) offers [Some deep analysis of one-line music programs.](http://countercomplex.blogspot.com/2011/10/some-deep-analysis-of-one-line-music.html)
* A systematic exploration on [ArXiv:1112.1368 Discovering novel computer music techniques by exploring the space of short computer programs ](https://arxiv.org/abs/1112.1368)
* [26 page beginner's guide to bytebeat for non-programmers](https://github.com/TuesdayNightMachines/Bytebeats/blob/master/Bytebeats_Beginners_Guide_TTNM_v1-5.pdf)---nice heuristic explanations of what is happening, working from the saw-wave forward.  There's some really great insight here on delays and even wavefolding

# In Mathematica

Conveniently, the default settings of [ListPlay](https://reference.wolfram.com/language/ref/ListPlay.html) are set up for the default Bytebeat settings of 8 kHz and 8-bit sampling, so all you need to do is define a putchar operation.

We take extensive use of the default [Listability](https://reference.wolfram.com/language/ref/Listable.html) of the arithmetic and bitwise operations to get this to work with a minimum of effort

```mathematica
putchar[i_] := FromDigits[#, 2] &@IntegerDigits[i, 2, 8]
bytebeat[i_List] := ListPlay@putchar[i]
```

Now a few examples from [Viznut's ArXiV paper](https://arxiv.org/abs/1112.1368).  The classic 31 Hz saw wave:

```mathematica
bytebeat@Range[4000]
```

![1maqlvftwpb5r](/blog/images/2023/4/25/1maqlvftwpb5r.png)

[Sierpinski](https://en.wikipedia.org/wiki/Sierpiński_triangle) music:

```mathematica
sierpinski[t_] := BitAnd[3*t, BitShiftRight[t, 8]]
bytebeat@sierpinski@Range[2^17]
```

![092n6wzw1fzqd](/blog/images/2023/4/25/092n6wzw1fzqd.png)

"Ole '42":

```mathematica
ole42[t_] := BitAnd[BitShiftRight[t, 10], 42]*t
bytebeat@ole42@Range[2^17]
```

![1vo5drlmqk2h4](/blog/images/2023/4/25/1vo5drlmqk2h4.png)

Using bit shifting to create delays:

```mathematica
expt[t_] := BitAnd[BitAnd[t, 96], BitShiftRight[t, 8]]
bytebeat@expt@Range[2^17]
```

![0smo6lhie5fvb](/blog/images/2023/4/25/0smo6lhie5fvb.png)

A nice melody:

```mathematica
rrrola[t_] := With[
    {const = FromDigits["0xCA98"]}, 
    BitOr[t *BitAnd[BitShiftRight[const, BitAnd[BitShiftRight[t, 9], 14]], 15], BitShiftRight[t, 8]]] 
 
bytebeat@rrrola@Range[2^18]
```

![1019jeqt7muqg](/blog/images/2023/4/25/1019jeqt7muqg.png)

I love the [Morse-code-like](https://en.wikipedia.org/wiki/Morse_code) rhythms in this one:

```mathematica
mu6k[t_] := BitAnd[#, 63] &@BitOr[BitOr[BitXor[BitShiftRight[t, 6] , BitShiftRight[t, 8]], BitShiftRight[t, 12]], t] 
 
bytebeat@mu6k@Range[2^19]
```

![0c9j5b57ekt40](/blog/images/2023/4/25/0c9j5b57ekt40.png)


# What does ChatGPT-3.5 know about Bytebeat? 

**PROMPT: Generate some example byte beat formulas and explain what they sound like**

```
Sure, here are some example byte beat formulas along with a brief explanation of what they sound like:

1. t=((t>>12)|(t<<4))&0xFEFA
This formula generates a sound similar to an 8-bit video game console. The "&0xFEFA" at the end of the formula cuts off some of the high frequencies, resulting in a more muffled sound. The shift operations in the formula create a repeating pattern that is somewhat reminiscent of a melody.

2. t=(t*5)&(t>>7)|(t*3)&(t>>10)
This formula creates a more complex sound with multiple layers of repeating patterns. The "*5" and "*3" operations in the formula add some variation to the sound, while the "&(t>>7)" and "&(t>>10)" operations create a sort of echo effect. The resulting sound is similar to a retro arcade game or a chiptune.

3. t=t^(t>>7)^(t>>12)^(t>>16)
This formula generates a sound that is more chaotic and unpredictable than the previous examples. The "t^" operations in the formula XOR the bits of the input value, resulting in a sound that is constantly changing. The resulting sound is similar to white noise or static, but with a hint of melody buried within the chaos.

4. t=t+t%(t>>10|1)
This formula creates a sound that is more melodic and pleasant than some of the previous examples. The "+t%" operation in the formula adds some variation to the sound, while the "(t>>10|1)" operation creates a repeating pattern that is somewhat reminiscent of a melody. The resulting sound is similar to a music box or a simple keyboard.

Keep in mind that byte beat formulas can be modified in many ways to create different sounds, and the resulting sound can vary depending on the implementation. These are just a few examples to give you an idea of what is possible.
```

**PROMPT: generate a bytebeat formula that sounds like Giant Steps**

```
Giant Steps is a famous jazz composition by John Coltrane, known for its complex chord changes and fast-paced melody. It may be challenging to replicate the exact sound of Giant Steps using a byte beat formula, but here is an attempt:

t=((t>>3)|(t<<3))^((t>>7)|(t<<7))^(t*(t>>10|1))

This formula generates a sound that is fast-paced and somewhat unpredictable, similar to the melody of Giant Steps. The "^" operations in the formula XOR the bits of the input value, creating a sound that is constantly changing. The "t*(t>>10|1)" operation adds some variation to the sound, while the ">>3" and "<<3" operations
```

**PROMPT: this is close, but try lowering the pitch by an octave**

```
Sure, here is a modified byte beat formula that lowers the pitch of the sound generated by an octave:

t=((t>>4)|(t<<4))^((t>>7)|(t<<7))^((t>>10)|(t<<10))^((t>>13)|(t<<13))^(t*(t>>9|1))

This formula is similar to the previous one but with additional shift operations that lower the pitch of the sound. The ">>4" and "<<4" operations shift the bits of the input value by 4 positions, which effectively divides the frequency by 2. The other shift operations also contribute to the overall sound of the formula.

As with any byte beat formula, the resulting sound may not exactly match the melody or chord progression of Giant Steps, but this formula should produce a fast-paced and complex sound that is similar in style. Feel free to experiment with different formulas and parameters to achieve the desired effect.
```

*(editor's note: it is sort of reminiscent, but not really...)*

**PROMPT: write a byte beat formula for a blues song**

```
Sure, here's an example byte beat formula for a blues song:

t=(t*5)&(t>>7)^t^((t>>6)&(t*3))^(t>>10)

In this formula, the "*5" and "*3" operations add some variation to the sound, while the "&(t>>7)" and "&(t>>6)" operations create a sort of echo effect. The "^t" operation adds some randomness to the sound, and the "^(t>>10)" operation creates a repeating pattern that is somewhat reminiscent of a blues rhythm.

Of course, the sound generated by this formula may not match the exact style or feel of a blues song, as byte beat music is limited to a certain range of sounds and patterns. However, this formula should give you a starting point for experimenting with different byte beat formulas to create your own unique blues sound.
```

*(editor's note: ummm...not really)*

**PROMPT:  Write a byte beat formula with a II-IV-V chord progression**

```
Sure, here's an example byte beat formula with a II-IV-V chord progression:

t=((t>>5)|(t<<5))^((t>>8)|(t<<8))^((t>>11)|(t<<11))^((t>>13)|(t<<13))^((t>>17)|(t<<17))^((t>>20)|(t<<20))^((t>>23)|(t<<23))^((t>>25)|(t<<25))^((t>>29)|(t<<29))^((t>>32)|(t<<32))^((t>>35)|(t<<35))^((t>>39)|(t<<39))^((t>>42)|(t<<42))^((t>>45)|(t<<45))^((t>>49)|(t<<49))^((t>>52)|(t<<52))^((t>>56)|(t<<56))^((t>>59)|(t<<59))^((t>>63)|(t<<63))^((t>>67)|(t<<67))^((t>>70)|(t<<70))^((t>>74)|(t<<74))^((t>>77)|(t<<77))^((t>>81)|(t<<81))^((t>>84)|(t<<84))^((t>>87)|(t<<87))^((t>>91)|(t<<91))^((t>>94)|(t<<94))^((t>>98)|(t<<98))^((t>>101)|(t<<101))^((t>>105)|(t<<105))^((t>>108)|(t<<108))^((t>>111)|(t<<111))^((t>>115)|(t<<115))^((t>>118)|(t<<118))^((t>>122)|(t<<122))^((t>>125)|(t<<125))^((t>>129)|(t<<129))^((t>>132)|(t<<132))^((t>>135)|(t<<135))^((t>>139)|(t<<139))^((t>>142)|(t<<142))^((t>>146)|(t<<146))^((t>>149)|(t<<149))^((t>>153)|(t<<153))^((t>>156)|(t<<156))^((t>>159)|(t<<159))^((t>>163)|(t<<163))^((t>>166)|(t<<166))^((t>>170)|(t<<170))^((t>>173)|(t<<173))^((t>>177)|(t<<177))^((t>>180)|(t<<180))^((t>>183)|(t<<183))^((t>>187)|(t<<187))^((t>>190)|(t<<190))^((t>>194)|(t<<194))^((t>>197)|(t<<197))^((t>>201)|(t<<201))^((t>>204)|(t<<204))^((t>>207)|(t<<207))^((t>>211)|(t<<211))^((t>>214)|(t<<214))^((t>>218)|(t<<218))^((t>>221)|(t<<221))^((t>>225)|(t<<225))^((t>>228)|(t<<228))^((t>>231)|(t<<231))^((t>>235)|(t<<235))^((t>>238)|(t<<238))^((t>>242)|(t<<242))^((t>>245)|(t<<245))^((t>>249)|(t<<249))^((t>>252)|(t<<252))^((t>>256)|(t<<256))^((t>>259)|(t<<259))^((t>>263)|(t<<263))^((t>>266)|(t<<266))^((t>>270)|(t<<270))^((t>>273)|(t<<273))^((t>>276)|(t<<276))^((t>>280)|(t<<280))^((t>>283)|(t<<283))^(( ...TERMINATED BY USER
```
*(editor's note: no chord changes here...there's some weird loop this entered)*

# Other ideas

* Could you learn a language generation model that tries to approximate a given waveform by generating Bytebeat code?  Try modifying a RNN/GRU/Transformer for [equational representations in Bernard Etienne's book](https://www.wolfram.com/language/introduction-machine-learning/deep-learning-methods/) for the task.