---
Title: "BachScratcher and ModularMonk"
Date: 2023-04-22
Tags: synth audio pico sequencer
---

**Premise:  a [Bach chorale](https://bach-chorales.com/BachChorales.htm) sequencer wtih CV output** or alternatively a **Gregorian chant** sequencer...

# Resources

* Digitized JSB Chorales dataset in JSON [https://github.com/czhuang/JSB-Chorales-dataset] *problem*: does not distinguish between held and repeated notes (so no gate information)
* Bach Soprano-line dataset only with note start and end times [https://archive.ics.uci.edu/ml/datasets/Bach+Chorales]
* [Gregobase corpus](https://github.com/bacor/gregobasecorpus) preprocssed
* [Gregobase](https://gregobase.selapa.net/chant.php?id=16787) uses a GABC format that encodes the melody and text...

# BachScratcher Design ideas

* Spit out each of the four voices on a separate output CV and gate 
* Spit out an arpegiated version?
* Tuning knob (global tuning?)
* tempo knob

# ModularMonk Design ideas

* Only one voice:  CV and gate output
* runing knob
* tempo knob
* random jitter timing
* have a vocodor: Analog [VODER 1939](https://en.wikipedia.org/wiki/Voder) circuit?  Some [technical circuit details in this whitepaper](https://www.specialtyansweringservice.net/wp-content/uploads/resources_papers/what-is-the-voder/The-Voder.pdf) 
