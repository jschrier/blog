---
title: "Jubilee Camera"
date: 2025-07-02
tags: diy science jubilee raspberrypi
---

**What's the best way to connect a USB webcam to a [Jubilee](https://science-jubilee.readthedocs.io/en/latest/)...**

# Problem statement

There are several mutually incompatible frameworks that have been developed for Jubilee cameras

**Vision:** Run on Raspberry Pi host, access everything through HTTP.  You could imagine an open video stream (open in the client's web browser) to get real-time camera value, as well as an HTTP endpoint that could be called to return specific (time-stamped, specific resolution) still images. This would be available on the `jubilee.local` server, and thus available either to software running on the (Raspberry Pi) localhost or to remote attached computers equally.

# Paths to solution

- [OpenCV](https://raspberrypi-guide.github.io/electronics/using-usb-webcams.html) is the standard path for this; however there are some issues when trying to do streaming video on a headless Raspberry Pi (when remote tunneling to a VSCode instance).  This drives my motivation to do everything through HTTP instead
- [Motion](https://www.instructables.com/How-to-Make-Raspberry-Pi-Webcam-Server-and-Stream-/) is a popular software for streaming webcams on the Raspberry Pi.  However, there is no clear API for extracting still frames
- **Best solution:** Miguel Grinberg has written a nice [Flask framework that will stream USB video on demand over HTTP](https://blog.miguelgrinberg.com/post/flask-video-streaming-revisited); it could be extended to make REST API calls to get the still images.  His framework supports both USB Webcams *and* RaspiCam modules, which seems quite elegant.


