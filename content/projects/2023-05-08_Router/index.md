---
title: Setting up a Protectli Vault
subtitle: A Better router for the home network
date: 2023-05-09
tags: [ IT, IP, Security, Networking ]

type: posts
toc: true
share:
  enable: false
---

## Intro

For the longest time I've been letting my NAS double as a router, DHCP and VPN server on my home
network. While this worked, having dedicated hardware for ingress to my home network would be an
impovement, and a simple one.

While I've wanted to do this for the longest time, it wasn't until I saw the
[Protectli Vault FW4C](https://protectli.com/product/fw4c) that I decided to do something about it.
The Vault is a small computer with 4 NICs running and no mechanical parts whatsoever. SSD storage,
and entirely passively cooled while being cheap to run as they don't eat anywhere near as much power
as a computer does.

![Protectli FW4C](FW4C.jpg)

## The first attempt

The initial idea was to just slap [pfSense](https://pfsense.org) or [OPNSense](https://opnsense.org)
on the shiny new piece of hardware, this quickly turned frustrating. Why one of these? Under the
hood they're both FreeBSD based, OPNSense being a fork of pfSense, which in turn is a fork of the
now discontinued m0n0wall. I love FreeBSD. I've been running FreeBSD since FreeBSD 4.8, so these
make perfect sense!

Both OPNSense and pfSense can do everything I want it to do. They can set up NAT for my home, they
can let me set up firewall rules, including port forwarding for my webserver this page is served
from, and provide network access via several VPN protocols. After just half an hour I was frustrated
with OPNSense.

Setting up firewall rules was... weird. The system provided me with what I'm sure are perfectly
sensible default rules for a home network, but I like to be able to tinker with things and I most
definitely want to be the one in control. A lot of the defaults appear to be non-negotiable and
couldn't be changed. Logging in with a shell and attempting to review stuff directly in pf.conf was
not an option as a surprising amount of things are tied to the web interface.

In the end I decided this was not for me. To be clear, I'm sure the stuff I found frustrating with
both OPNSense and pfSense can be fixed, I just didn't have the patience to deal with it.

## Setting up OpenBSD instead

## Stuff to do
