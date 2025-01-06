---
title: "Reading ThermoFischer XCalibur RAW Files"
date: 2023-01-04
tags: science python
---

_[Sarah Maurer](https://directory.ccsu.edu/person/sarah-maurer) asks:  I'm using a [GC/MS](https://en.wikipedia.org/wiki/Gas_chromatography–mass_spectrometry) to analyze some samples, but the ThermoFischer XCalibur software on the instrument only allows us to export the data one CSV at a time, which is an error prone process.  Is there any way to automate this?_  **Here are some notes on how to do this in January 2023...**


# Using MSFileReader and the PyPiWin32 (not recommended)

**tl;dr---this can do the trick and explains many things, but relies on deprecated software and is a bit fiddly.  [This is not the way](https://tenor.com/bul54.gif)** 

I found a [thorough (70 minute) YouTube video describining how to do this](https://www.youtube.com/watch?v=Aj5rd6p1Q1s)

The video mentions [mzXML](http://tools.proteomecenter.org/wiki/index.php?title=Formats%3AmzXML#Thermo.2FXCalibur)...

But instead prefers to use Thermo's [MSFileReader software (reference manual)](https://tools.thermofisher.com/content/sfs/manuals/Man-XCALI-97542-MSFileReader-30-Ref-ManXCALI97542-A-EN.pdf) There's a download link provided in the youtube video comments, but you need a Thermo registration.

However, the MSFileReader library is a C++ library. To use it in python use pypiwin32 (`python -m pip install pypiwin32`). 

Sample code begins at 13:32...and then switches to Python2.7---not sure if this is a problem with PyPiWin32 or with the auteur's python installation environment.

But then he walks through getting the spectra in a RAW file and illustrates many processes.


# RawFileReader + RawQuant/RawTools (recommended)

**tl;dr---This appears to be some convenience wrappers around RawTools that should do what we want without programming [This is the way!](https://tenor.com/bpEmY.gif) alas...with C#...but there appears to be some command line programs and GUIs that do most of what we want to accomplish**

[According to the internets](https://github.com/frallain/pymsfilereader), MSFileReader, the underlying library used by these bindings, is outdated and buggy. Thermo now recommends to use [RawFileReader](https://planetorbitrap.com/rawfilereader) to read Thermo RAW files. 

There is a python binding [RawQuant](https://github.com/kevinkovalchik/RawQuant) for which development stopped in January 2019.

The authors have instead put their effort into [RawTools](https://github.com/kevinkovalchik/RawTools) a C# library which they claim is faster.  They also have a paper about it in [J. Proteom Res 2019](https://pubs.acs.org/doi/10.1021/acs.jproteome.8b00721) and it should work on any operating system.  It appears to be actively developed through May 2022. 

Note that RawTools appears to be a standalone tool with a GUI, so it can probably be used _as is_ withought having to do any programming for what we want. **This is probably the best approach.**

# RawFileReader (?)

**tl;dr--This is ThermoFischer's officially released C#-based parser for RAW files, which is intended to replace MSFileReader.  It appears to be active (updated yesterday!) This is a lower level than RawTools above?** 

[RawFileReader](https://github.com/thermofisherlsms/RawFileReader) is a group of .Net Assemblies written in C# used to read Thermo Scientific RAW files. The assemblies can be used to read RAW files on Windows, Linux, and MacOS using C# or other languages that can acces a .Net assembly.

[ThermoRawFileParser](https://github.com/compomics/ThermoRawFileParser) (see also [paper](https://pubmed.ncbi.nlm.nih.gov/31755270/)) is a 3rd party command line wrapper around RawFileReader


# Other resources found in my readings

* [pyMSFileReader](https://github.com/frallain/pymsfilereader) Python bindings for MSFileReader (tested on versions 3.0SP2 (August 2014) and 3.0SP3.)  However the author notes that these are deprecated, as discussed int he previous section
* [mzXML](http://tools.proteomecenter.org/wiki/index.php?title=Formats%3AmzXML#Thermo.2FXCalibur) n open data format for storage and exchange of mass spectroscopy data, developed at the SPC/Institute for Systems Biology. mzXML provides a standard container for ms and ms/ms proteomics data and is the foundation of our proteomic pipelines. Raw, proprietary file formats from most vendors can be converted to the open mzXML format.
* [ReAdW](http://tools.proteomecenter.org/wiki/index.php?title=Software:ReAdW)  Thermo Xcalibur .raw files to mzXML converter command line program
* However, based on [a github pager ReAdW suggests that it requires MsFileReader_x64.exe](https://github.com/PedrioliLab/ReAdW)  Helpfull it provides a link to Thermo's github for that.
* [XCaliburMethodReader](https://github.com/nickdelgrosso/XCaliburMethodReader) --- A simple command-line program for mass spectrometry researchers that extracts and converts data from Thermo XCalibur Method (.meth) files.
* Proteowizard Toolkit: [2012 paper](https://www.nature.com/articles/nbt.2377), [2017 paper](https://pubmed.ncbi.nlm.nih.gov/28188540/), [another 2017 paper](https://link.springer.com/protocol/10.1007/978-1-4939-6747-6_23#citeas) 

# Continued readings and gleanings

- (20 Jan 2023) Haas CP, Lübbesmeyer M, Jin EH, McDonald MA, Koscher BA, Guimond N, et al. Open-Source Chromatographic Data Analysis for Reaction Optimization and Screening. ChemRxiv 2022. [doi:10.26434/chemrxiv-2022-0pv2d](https://dx.doi.org/10.26434/chemrxiv-2022-0pv2d) --- describes a python library for reading and processing and extracting information from a variety of HPLC machines/vendors.  Subsequently published as MoccA in [ACS Central Sci 2023](https://pubs.acs.org/doi/10.1021/acscentsci.2c01042). **Limitation:  Only the UV chromatogram, not mass spec**
- (06 Jan 2024) Hillenbrand et al, Automated Processing of Chromatograms: A comprehensive Python Package with GUI for Intelligent Peak Identification and Deconvolution in Chemical Reaction Analysis [Digital Discovery 2024](https://dx.doi.org/10.1039/D4DD00214H)---upgrade to MoccA (consider this the latest version) **Limitation:  Only the UV chromatogram, not mass spec**
- (06 Jan 2024) McDonald et al, "Calibration-free reaction yield quantification by HPLC with a machine-learning model of extinction coefficients" [Chem Sci 2024] (https://doi.org/10.1039/D4SC01881H) --- perhaps not strictly necessary, but useful task to remember.
- (06 Jan 2024) It seems that many packages for working with mass spec in python like [Mass-Suite](https://jcheminf.biomedcentral.com/articles/10.1186/s13321-023-00741-9) and [pyOpenMS](https://github.com/OpenMS/pyopenms-docs) use mzML file formats, not .raw. 
    - [PythoMS](https://pubs.acs.org/doi/10.1021/acs.jcim.9b00055) and [github](https://github.com/larsyunker/PythoMS) seems to support converting from RAW to mzML as well as doing processing, but hasn't been maintained since 2020. Also, [under the hood](https://github.com/larsyunker/PythoMS/blob/master/pythoms/mzml.py) it is just calling  [ProteoWizard](https://proteowizard.sourceforge.io) to call the conversion, and only works under windows
    - [ProteoWizard](https://proteowizard.sourceforge.io) is another recommend tool for converting from RAW to mzML.  [youtube video tutorial](https://www.youtube.com/watch?v=sudY7UtkMQg). But appears to only exist for Windows and maybe Linux.
    - [ThermoRawFileParser](https://github.com/compomics/ThermoRawFileParser) (see also [paper](https://pubmed.ncbi.nlm.nih.gov/31755270/)) is a wrapper around thermo's RawFileReader framework (see section above) 
